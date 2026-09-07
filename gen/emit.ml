(* Emits the generated OCaml modules and the C ABI probe from the parsed
   headers.  Output must be deterministic: everything below iterates over the
   declaration order of the headers, never over a hash table. *)

open C_header

let buf_add = Buffer.add_string

(* ------------------------------------------------------------------ *)
(* Naming                                                              *)
(* ------------------------------------------------------------------ *)

let ocaml_keywords =
  [ "and"; "as"; "assert"; "asr"; "begin"; "class"; "constraint"; "do"; "done"; "downto"; "else";
    "end"; "exception"; "external"; "false"; "for"; "fun"; "function"; "functor"; "if"; "in";
    "include"; "inherit"; "initializer"; "land"; "lazy"; "let"; "lor"; "lsl"; "lsr"; "lxor";
    "match"; "method"; "mod"; "module"; "mutable"; "new"; "nonrec"; "object"; "of"; "open"; "or";
    "private"; "rec"; "sig"; "struct"; "then"; "to"; "true"; "try"; "type"; "val"; "virtual";
    "when"; "while"; "with" ]

let escape_id s = if List.mem s ocaml_keywords then s ^ "_" else s

(* [WGPUBufferDescriptor] -> [BufferDescriptor] *)
let module_name c_name =
  if String.length c_name > 4 && String.sub c_name 0 4 = "WGPU" then
    String.sub c_name 4 (String.length c_name - 4)
  else c_name

let is_upper c = c >= 'A' && c <= 'Z'
let is_lower c = c >= 'a' && c <= 'z'
let is_digit c = c >= '0' && c <= '9'

(* CamelCase (with acronym runs and digits) -> snake_case. *)
let snake_case s =
  let b = Buffer.create (String.length s + 8) in
  let n = String.length s in
  String.iteri
    (fun i c ->
      let prev = if i > 0 then Some s.[i - 1] else None in
      let next = if i + 1 < n then Some s.[i + 1] else None in
      let boundary =
        match prev with
        | None -> false
        | Some p ->
            (is_upper c && (is_lower p || is_digit p))
            || (is_upper c && is_upper p && match next with Some nx -> is_lower nx | None -> false)
            || (is_digit c && is_upper p && false)
      in
      if boundary then Buffer.add_char b '_';
      Buffer.add_char b (Char.lowercase_ascii c))
    s;
  Buffer.contents b

(* [WGPUBufferUsage_MapRead] with prefix [WGPUBufferUsage] -> [map_read] *)
let constant_name ~type_c_name const_c_name =
  let prefix = type_c_name ^ "_" in
  let plen = String.length prefix in
  let base =
    if String.length const_c_name > plen && String.sub const_c_name 0 plen = prefix then
      String.sub const_c_name plen (String.length const_c_name - plen)
    else
      (* wgpu.h extends standard enums with differently-prefixed constants,
         e.g. WGPUSurfaceGetCurrentTextureStatus_Occluded declared inside
         WGPUNativeSurfaceGetCurrentTextureStatus. Keep the tail after '_'. *)
      match String.index_opt const_c_name '_' with
      | Some i -> String.sub const_c_name (i + 1) (String.length const_c_name - i - 1)
      | None -> const_c_name
  in
  let s = snake_case base in
  let s = if String.length s > 0 && is_digit s.[0] then "v" ^ s else s in
  escape_id s

(* Members every generated module defines itself.  A constant or field whose
   generated name collided with one of these would silently shadow it instead of
   failing to compile, so they seed [check_unique]. *)
let reserved_enum = [ "c_name"; "t"; "values"; "to_string" ]
let reserved_flags = [ "c_name"; "t"; "values"; "+"; "combine"; "mem"; "to_string" ]
let reserved_handle = [ "c_name"; "impl"; "t"; "null"; "is_null" ]
let reserved_struct = [ "c_name"; "s"; "t"; "field_names"; "init" ]
let reserved_union = [ "c_name"; "s"; "t"; "field_names" ]
let reserved_callback = [ "c_name"; "fn"; "t"; "null" ]
let reserved_constants = [ "names" ]

let check_unique ?(reserved = []) what names =
  let tbl = Hashtbl.create 64 in
  List.iter (fun n -> Hashtbl.replace tbl n `Reserved) reserved;
  List.iter
    (fun n ->
      (match Hashtbl.find_opt tbl n with
      | Some `Reserved ->
          failwith
            (Printf.sprintf "%s: generated name %S collides with a member the module defines itself"
               what n)
      | Some `Generated ->
          failwith (Printf.sprintf "%s: duplicate generated name %S" what n)
      | None -> ());
      Hashtbl.replace tbl n `Generated)
    names

(* ------------------------------------------------------------------ *)
(* Type mapping                                                        *)
(* ------------------------------------------------------------------ *)

let prim_ctypes = function
  | "uint8_t" -> "Ctypes.uint8_t"
  | "uint16_t" -> "Ctypes.uint16_t"
  | "uint32_t" -> "Ctypes.uint32_t"
  | "uint64_t" -> "Ctypes.uint64_t"
  | "int8_t" -> "Ctypes.int8_t"
  | "int16_t" -> "Ctypes.int16_t"
  | "int32_t" -> "Ctypes.int32_t"
  | "int64_t" -> "Ctypes.int64_t"
  | "size_t" -> "Ctypes.size_t"
  | "float" -> "Ctypes.float"
  | "double" -> "Ctypes.double"
  | "char" -> "Ctypes.char"
  | "int" -> "Ctypes.int"
  | p -> failwith ("unsupported primitive " ^ p)

let rec ctypes_of ?self ~alias_base t =
  let ctypes_of ?(self = self) = ctypes_of ?self in
  let qualify n = if Some n = self then "t" else module_name n ^ ".t" in
  match t with
  | Void -> "Ctypes.void"
  | Prim p -> prim_ctypes p
  | Bool -> "Ctypes.uint32_t"
  | Enum n -> module_name n ^ ".t"
  | Flags n -> module_name n ^ ".t"
  | Struct n -> qualify n
  | Handle n -> module_name n ^ ".t"
  | Callback n -> qualify n
  | Alias n -> prim_ctypes (alias_base n)
  | Ptr Void -> "(Ctypes.ptr Ctypes.void)"
  | Ptr t -> "(Ctypes.ptr " ^ ctypes_of ~alias_base t ^ ")"
  | Anon_union (n, _) -> module_name n ^ ".t"
  | Unresolved n -> failwith ("unresolved type " ^ n)

(* OCaml value type of a ctypes type, used only in generated doc comments. *)
let rec ocaml_type_of ?self ~alias_base t =
  let ocaml_type_of ?(self = self) = ocaml_type_of ?self in
  let qualify n = if Some n = self then "t" else module_name n ^ ".t" in
  match t with
  | Void -> "unit"
  | Prim "uint8_t" -> "Unsigned.UInt8.t"
  | Prim "uint16_t" -> "Unsigned.UInt16.t"
  | Prim "uint32_t" -> "Unsigned.UInt32.t"
  | Prim "uint64_t" -> "Unsigned.UInt64.t"
  | Prim "int8_t" -> "int"
  | Prim "int16_t" -> "int"
  | Prim "int32_t" -> "int32"
  | Prim "int64_t" -> "int64"
  | Prim "size_t" -> "Unsigned.Size_t.t"
  | Prim "float" -> "float"
  | Prim "double" -> "float"
  | Prim "char" -> "char"
  | Prim "int" -> "int"
  | Prim p -> failwith ("unsupported primitive " ^ p)
  | Bool -> "Unsigned.UInt32.t"
  | Enum n -> module_name n ^ ".t"
  | Flags n -> module_name n ^ ".t"
  | Struct n -> qualify n
  | Handle n -> module_name n ^ ".t"
  | Callback n -> qualify n
  | Alias n -> ocaml_type_of ~alias_base (Prim (alias_base n))
  | Ptr Void -> "unit Ctypes.ptr"
  | Ptr t -> ocaml_type_of ~alias_base t ^ " Ctypes.ptr"
  | Anon_union (n, _) -> module_name n ^ ".t"
  | Unresolved n -> failwith ("unresolved type " ^ n)

(* ------------------------------------------------------------------ *)
(* Dependency ordering for structs                                     *)
(* ------------------------------------------------------------------ *)

type item = Item_struct of struct_decl | Item_callback of callback_decl

(* A module must be emitted after every module it mentions, because OCaml has no
   forward references.  Structs and function-pointer typedefs refer to each
   other (a callback takes a [WGPUStringView], a callback-info struct holds a
   callback), so they are sorted together.  Self-references are fine: a
   module's own [t] is in scope inside its body. *)
let sort_items (structs : struct_decl list) (callbacks : callback_decl list) =
  let items =
    List.map (fun s -> (s.s_name, Item_struct s)) structs
    @ List.map (fun c -> (c.cb_name, Item_callback c)) callbacks
  in
  let rec type_deps self t =
    match t with
    | Struct n | Callback n -> if n = self then [] else [ n ]
    | Ptr t -> type_deps self t
    | Anon_union (_, variants) -> List.concat_map (fun f -> type_deps self f.fld_type) variants
    | _ -> []
  in
  let deps = function
    | Item_struct s -> List.concat_map (fun f -> type_deps s.s_name f.fld_type) s.s_fields
    | Item_callback c ->
        List.concat_map (fun (_, t) -> type_deps c.cb_name t) c.cb_sig.p_params
        @ type_deps c.cb_name c.cb_sig.p_ret
  in
  let emitted = Hashtbl.create 512 in
  let in_progress = Hashtbl.create 16 in
  let out = ref [] in
  let rec visit name =
    if not (Hashtbl.mem emitted name) then begin
      if Hashtbl.mem in_progress name then
        failwith (Printf.sprintf "cyclic type dependency involving %s" name);
      Hashtbl.replace in_progress name ();
      let it = List.assoc name items in
      List.iter visit (deps it);
      Hashtbl.remove in_progress name;
      Hashtbl.replace emitted name ();
      out := it :: !out
    end
  in
  List.iter (fun (n, _) -> visit n) items;
  List.rev !out

(* ------------------------------------------------------------------ *)
(* Header banner                                                       *)
(* ------------------------------------------------------------------ *)

(* [canonical] is the public path the module is re-exported under by
   [lib/wgpu.ml]; odoc needs it to render types from this module as
   [Wgpu.Types.Foo.t] rather than through the hidden wrapped name. *)
let banner b ~pin ~what ~canonical =
  buf_add b (Printf.sprintf "(** @canonical %s *)\n\n" canonical);
  buf_add b
    (Printf.sprintf
       "(* %s\n\n   GENERATED FILE -- DO NOT EDIT.\n\n   Produced by [gen/gen.ml] from the vendored headers\n   [vendor/wgpu-native/include/webgpu/{webgpu,wgpu}.h], pinned at\n   wgpu-native %s (commit %s, webgpu-headers %s).\n\n   Run [dune build @gen] to regenerate and [dune promote] to accept. *)\n\n"
       what
       (List.assoc "version" pin) (List.assoc "commit" pin)
       (List.assoc "webgpu_headers_commit" pin))

(* ------------------------------------------------------------------ *)
(* wgpu_types.ml                                                       *)
(* ------------------------------------------------------------------ *)

let emit_enum b (e : enum_decl) =
  let m = module_name e.e_name in
  let names = List.map (fun (n, _) -> constant_name ~type_c_name:e.e_name n) e.e_values in
  check_unique ~reserved:reserved_enum e.e_name names;
  buf_add b (Printf.sprintf "(** [%s] (from %s) *)\nmodule %s = struct\n" e.e_name e.e_header m);
  buf_add b (Printf.sprintf "  let c_name = %S\n\n" e.e_name);
  buf_add b "  type t = int\n\n";
  buf_add b
    "  let t : t Ctypes.typ =\n\
    \    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t\n\n";
  List.iter2
    (fun (cn, v) name -> buf_add b (Printf.sprintf "  (** [%s] *)\n  let %s : t = %Ld\n\n" cn name v))
    e.e_values names;
  buf_add b "  let values : (string * t) list =\n    [";
  List.iter (fun (cn, v) -> buf_add b (Printf.sprintf " (%S, %Ld);" cn v)) e.e_values;
  buf_add b " ]\n\n";
  buf_add b
    "  let to_string (v : t) =\n\
    \    match List.find_opt (fun (_, x) -> x = v) values with\n\
    \    | Some (n, _) -> n\n\
    \    | None -> Printf.sprintf \"%s(0x%08x)\" c_name v\n\
     end\n\n"

let emit_flags b (f : flags_decl) =
  let m = module_name f.f_name in
  let names = List.map (fun (n, _) -> constant_name ~type_c_name:f.f_name n) f.f_values in
  check_unique ~reserved:reserved_flags f.f_name names;
  (* Bit sets are OCaml [int]s, which are 63-bit and signed: a constant using
     bit 62 or bit 63 is not representable and must stop the generator rather
     than produce an out-of-range literal. *)
  List.iter
    (fun (n, v) ->
      if v < 0L || v > Int64.of_int max_int then
        failwith
          (Printf.sprintf
             "%s: constant %s = 0x%Lx does not fit in an OCaml int on 64-bit platforms" f.f_name n v))
    f.f_values;
  buf_add b
    (Printf.sprintf "(** [%s] -- a bit set over [%s] (from %s) *)\nmodule %s = struct\n" f.f_name
       f.f_base f.f_header m);
  buf_add b (Printf.sprintf "  let c_name = %S\n\n" f.f_name);
  buf_add b "  type t = int\n\n";
  buf_add b
    "  let t : t Ctypes.typ =\n\
    \    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t\n\n";
  List.iter2
    (fun (cn, v) name -> buf_add b (Printf.sprintf "  (** [%s] *)\n  let %s : t = %Ld\n\n" cn name v))
    f.f_values names;
  buf_add b "  let values : (string * t) list =\n    [";
  List.iter (fun (cn, v) -> buf_add b (Printf.sprintf " (%S, %Ld);" cn v)) f.f_values;
  buf_add b " ]\n\n";
  buf_add b "  let ( + ) : t -> t -> t = ( lor )\n\n";
  buf_add b "  let combine (l : t list) : t = List.fold_left ( lor ) 0 l\n\n";
  buf_add b "  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0\n\n";
  buf_add b
    "  let to_string (v : t) =\n\
    \    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in\n\
    \    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in\n\
    \    let names = List.map fst set in\n\
    \    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf \"0x%x\" (v land lnot covered) ] else names in\n\
    \    match names with [] -> c_name ^ \"_None\" | l -> String.concat \"|\" l\n\
     end\n\n"

let emit_handle b name =
  check_unique ~reserved:reserved_handle name [];
  let m = module_name name in
  buf_add b
    (Printf.sprintf
       "(** [%s] -- opaque, reference counted handle. *)\n\
        module %s = struct\n\
       \  let c_name = %S\n\n\
       \  type impl\n\n\
       \  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure \"%sImpl\"\n\n\
       \  type t = impl Ctypes.structure Ctypes.ptr\n\n\
       \  let t : t Ctypes.typ = Ctypes.ptr impl\n\n\
       \  let null : t = Ctypes.from_voidp impl Ctypes.null\n\n\
       \  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0\n\
        end\n\n"
       name m name name)

let emit_callback b ~alias_base (c : callback_decl) =
  check_unique ~reserved:reserved_callback c.cb_name [];
  let m = module_name c.cb_name in
  let params = if c.cb_sig.p_params = [] then [ ("", Void) ] else c.cb_sig.p_params in
  let fn =
    String.concat " @-> " (List.map (fun (_, t) -> ctypes_of ~self:c.cb_name ~alias_base t) params)
    ^ " @-> Ctypes.returning "
    ^ ctypes_of ~self:c.cb_name ~alias_base c.cb_sig.p_ret
  in
  let ml_sig =
    String.concat " -> " (List.map (fun (_, t) -> ocaml_type_of ~self:c.cb_name ~alias_base t) params)
    ^ " -> "
    ^ ocaml_type_of ~self:c.cb_name ~alias_base c.cb_sig.p_ret
  in
  buf_add b (Printf.sprintf "(** [%s] (from %s) *)\n" c.cb_name c.cb_header);
  buf_add b (Printf.sprintf "module %s = struct\n" m);
  buf_add b (Printf.sprintf "  let c_name = %S\n\n" c.cb_name);
  buf_add b (Printf.sprintf "  (** The C signature, as a ctypes function type. *)\n  let fn : (%s) Ctypes.fn = Ctypes.(%s)\n\n" ml_sig fn);
  buf_add b (Printf.sprintf "  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or\n      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a\n      controlled lifetime. *)\n  type t = (%s) Ctypes.static_funptr\n\n" ml_sig);
  buf_add b "  let t : t Ctypes.typ = Ctypes.static_funptr fn\n\n";
  buf_add b "  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null\n";
  buf_add b "end\n\n"

(* Expression for the default value of a field of type [ty], as written in the
   header's WGPU_*_INIT macro.  Returns [None] when the default is "all zero",
   which [zeroed] has already produced. *)
let rec init_expr ~structs ~alias_base ~enum_const ~where (ty : ctype) (v : init_value) : string option =
  let bad fmt = Printf.ksprintf (fun m -> failwith (where ^ ": " ^ m)) fmt in
  let num v =
    match ty with
    | Prim "uint8_t" -> Printf.sprintf "Unsigned.UInt8.of_int %Ld" v
    | Prim "uint16_t" -> Printf.sprintf "Unsigned.UInt16.of_int %Ld" v
    | Prim "uint32_t" | Bool -> Printf.sprintf "Unsigned.UInt32.of_int %Ld" v
    | Prim "uint64_t" -> Printf.sprintf "Unsigned.UInt64.of_int64 %LdL" v
    | Prim "size_t" -> Printf.sprintf "Unsigned.Size_t.of_int %Ld" v
    | Prim "int32_t" -> Printf.sprintf "%Ldl" v
    | Prim "int64_t" -> Printf.sprintf "%LdL" v
    | Prim "int" -> Printf.sprintf "%Ld" v
    | Prim ("float" | "double") -> Printf.sprintf "%Ld." v
    | Enum _ | Flags _ -> Printf.sprintf "%Ld" v
    | Alias n -> (
        match alias_base n with
        | "uint64_t" -> Printf.sprintf "Unsigned.UInt64.of_int64 %LdL" v
        | "uint32_t" -> Printf.sprintf "Unsigned.UInt32.of_int %Ld" v
        | b -> bad "unsupported alias default of type %s" b)
    | _ -> bad "numeric default on a non-numeric field"
  in
  match v with
  | I_int 0L -> None (* already zero *)
  | I_int n -> Some (num n)
  | I_null -> None (* NULL is all-zero *)
  | I_zero_struct -> None
  | I_float 0.0 -> None
  | I_float f -> (
      match ty with
      | Prim ("float" | "double") -> Some (Printf.sprintf "%h" f)
      | _ -> bad "float default on a non-float field")
  | I_nan -> Some "Float.nan"
  | I_const name -> (
      let base = constant_name ~type_c_name:"WGPU" name in
      match ty with
      | Prim ("uint32_t" | "uint64_t" | "size_t" | "float" | "double") | Bool ->
          Some (Printf.sprintf "Constants.%s" base)
      | _ -> bad "constant default %s on an unsupported field type" name)
  | I_enum name -> (
      (* The declaring enum is not always the field's own type: wgpu.h extends
         WGPUSType with constants declared in WGPUNativeSType. *)
      match (enum_const name, ty) with
      | Some owner, (Enum _ | Flags _) ->
          Some (Printf.sprintf "%s.%s" (module_name owner) (constant_name ~type_c_name:owner name))
      | None, _ -> bad "unknown enum constant %s" name
      | Some _, _ -> bad "enum default %s on a non-enum field" name)
  | I_struct_init _ -> (
      match ty with
      | Struct n -> Some (Printf.sprintf "%s.init ()" (module_name n))
      | _ -> bad "struct default on a non-struct field")
  | I_inline_struct (sname, sub) -> (
      match ty with
      | Struct n when n = sname ->
          let sd =
            match List.find_opt (fun (s : struct_decl) -> s.s_name = sname) structs with
            | Some sd -> sd
            | None -> bad "unknown struct %s in initialiser" sname
          in
          let m = module_name sname in
          let sets =
            List.filter_map
              (fun (fname, value) ->
                let fld =
                  match List.find_opt (fun f -> f.fld_name = fname) sd.s_fields with
                  | Some f -> f
                  | None -> bad "unknown field %s of %s" fname sname
                in
                match
                  init_expr ~structs ~alias_base ~enum_const ~where:(where ^ "." ^ fname)
                    fld.fld_type value
                with
                | None -> None
                | Some e ->
                    Some (Printf.sprintf "Ctypes.setf s %s.%s (%s);" m (escape_id fname) e))
              sub
          in
          Some
            (Printf.sprintf "let s = %s.init () in %s s" m
               (if sets = [] then "" else String.concat " " sets ^ " "))
      | _ -> bad "inline struct default on a field of another type")

let emit_struct b ~structs ~alias_base ~enum_const ~inits (s : struct_decl) =
  let m = module_name s.s_name in
  let fields = List.map (fun f -> (f, escape_id f.fld_name)) s.s_fields in
  check_unique ~reserved:reserved_struct s.s_name (List.map snd fields);
  buf_add b (Printf.sprintf "(** [%s] (from %s) *)\nmodule %s = struct\n" s.s_name s.s_header m);
  buf_add b (Printf.sprintf "  let c_name = %S\n\n" s.s_name);
  buf_add b "  type s\n\n";
  buf_add b (Printf.sprintf "  type t = s Ctypes.structure\n\n");
  buf_add b (Printf.sprintf "  let t : t Ctypes.typ = Ctypes.structure %S\n\n" s.s_name);
  (* Anonymous unions become nested modules, emitted before the field that
     refers to them. *)
  List.iter
    (fun (f, _) ->
      match f.fld_type with
      | Anon_union (uname, variants) ->
          let um = module_name uname in
          buf_add b
            (Printf.sprintf
               "  (** Anonymous union [%s.%s]. *)\n  module %s = struct\n    let c_name = %S\n\n    type s\n\n    type t = s Ctypes.union\n\n    let t : t Ctypes.typ = Ctypes.union %S\n\n"
               s.s_name f.fld_name um uname uname);
          check_unique ~reserved:reserved_union uname
            (List.map (fun v -> escape_id v.fld_name) variants);
          List.iter
            (fun v ->
              buf_add b
                (Printf.sprintf "    let %s = Ctypes.field t %S %s\n" (escape_id v.fld_name)
                   v.fld_name
                   (ctypes_of ~self:s.s_name ~alias_base v.fld_type)))
            variants;
          buf_add b "\n    let () = Ctypes.seal t\n\n    let field_names = [";
          List.iter (fun v -> buf_add b (Printf.sprintf " %S;" v.fld_name)) variants;
          buf_add b " ]\n  end\n\n"
      | _ -> ())
    fields;
  List.iter
    (fun (f, oname) ->
      buf_add b
        (Printf.sprintf "  (** [%s %s] : [%s] *)\n  let %s = Ctypes.field t %S %s\n\n" s.s_name
           f.fld_name
           (ocaml_type_of ~self:s.s_name ~alias_base f.fld_type)
           oname f.fld_name
           (ctypes_of ~self:s.s_name ~alias_base f.fld_type)))
    fields;
  buf_add b "  let () = Ctypes.seal t\n\n";
  buf_add b "  let field_names = [";
  List.iter (fun (f, _) -> buf_add b (Printf.sprintf " %S;" f.fld_name)) fields;
  buf_add b " ]\n\n";
  (* default initialiser derived from the header's WGPU_*_INIT macro *)
  (match List.find_opt (fun i -> i.init_struct = s.s_name) inits with
  | None ->
      buf_add b
        "  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)\n\
        \  let init () : t = zeroed t\n"
  | Some init ->
      buf_add b
        (Printf.sprintf
           "  (** A fresh value carrying the defaults of the header's [%s_INIT]\n      macro.  Zero is *not* a valid default for every WebGPU struct, so\n      always start from this. *)\n  let init () : t =\n    let v = zeroed t in\n"
           (String.uppercase_ascii (snake_case (module_name s.s_name))));
      List.iter
        (fun (fname, value) ->
          let f, oname =
            match List.find_opt (fun (f, _) -> f.fld_name = fname) fields with
            | Some x -> x
            | None ->
                failwith (Printf.sprintf "%s: INIT macro mentions unknown field %s" s.s_name fname)
          in
          match
            init_expr ~structs ~alias_base ~enum_const ~where:(s.s_name ^ "." ^ fname) f.fld_type
              value
          with
          | None -> ()
          | Some expr -> buf_add b (Printf.sprintf "    Ctypes.setf v %s (%s);\n" oname expr))
        init.init_fields;
      buf_add b "    v\n");
  buf_add b "end\n\n"

let emit_constants b (constants : const_decl list) =
  check_unique ~reserved:reserved_constants "WGPU (constants)"
    (List.map (fun k -> constant_name ~type_c_name:"WGPU" k.k_name) constants);
  buf_add b "(** Sentinel values from the [#define]s in the headers. *)\nmodule Constants = struct\n";
  List.iter
    (fun k ->
      let name = constant_name ~type_c_name:"WGPU" k.k_name in
      let value, ty =
        match k.k_value with
        | C_int v -> (Printf.sprintf "Unsigned.UInt32.of_int %Ld" v, "Unsigned.UInt32.t")
        | C_u32_max -> ("Unsigned.UInt32.max_int", "Unsigned.UInt32.t")
        | C_u64_max -> ("Unsigned.UInt64.max_int", "Unsigned.UInt64.t")
        | C_size_max -> ("Unsigned.Size_t.max_int", "Unsigned.Size_t.t")
        | C_nan -> ("Float.nan", "float")
      in
      buf_add b (Printf.sprintf "  (** [%s] *)\n  let %s : %s = %s\n\n" k.k_name name ty value))
    constants;
  (* Untyped integer views, handy when a sentinel has to be compared against a
     field whose ctypes representation is a plain int. *)
  buf_add b "  let names : string list = [";
  List.iter (fun k -> buf_add b (Printf.sprintf " %S;" k.k_name)) constants;
  buf_add b " ]\nend\n\n"

let emit_types ~pin ~(h : header) =
  let b = Buffer.create (1 lsl 20) in
  let alias_base n = try List.assoc n h.aliases with Not_found -> failwith ("unknown alias " ^ n) in
  (* Which enum or bit set declares a given C constant name. *)
  let owners = Hashtbl.create 512 in
  List.iter (fun (e : enum_decl) -> List.iter (fun (n, _) -> Hashtbl.replace owners n e.e_name) e.e_values) h.enums;
  List.iter (fun (f : flags_decl) -> List.iter (fun (n, _) -> Hashtbl.replace owners n f.f_name) f.f_values) h.flags;
  let enum_const n = Hashtbl.find_opt owners n in
  banner b ~pin ~canonical:"Wgpu.Types"
    ~what:"Raw WebGPU / wgpu-native types: enums, bit sets, handles, structs.";
  buf_add b
    "(* Naming: C type [WGPUFoo] becomes module [Foo]; struct fields keep their C\n\
    \   spelling; enum constant [WGPUFoo_BarBaz] becomes [Foo.bar_baz].  Every\n\
    \   module records its C name in [c_name] and its constants in [values]. *)\n\n\
     (* Fresh, fully zeroed storage.  ctypes does not promise to zero the memory\n\
    \   it hands out, and several WebGPU structs are only valid when the fields\n\
    \   the INIT macro does not mention are zero. *)\n\
     let zeroed : type a. a Ctypes.structure Ctypes.typ -> a Ctypes.structure =\n\
    \ fun t ->\n\
    \  let v = Ctypes.make t in\n\
    \  let bytes =\n\
    \    Ctypes.CArray.from_ptr\n\
    \      (Ctypes.coerce (Ctypes.ptr t) (Ctypes.ptr Ctypes.char) (Ctypes.addr v))\n\
    \      (Ctypes.sizeof t)\n\
    \  in\n\
    \  for i = 0 to Ctypes.CArray.length bytes - 1 do\n\
    \    Ctypes.CArray.set bytes i '\\000'\n\
    \  done;\n\
    \  v\n\n";
  emit_constants b h.constants;
  List.iter (fun n -> emit_handle b n) h.handles;
  List.iter (fun e -> emit_enum b e) h.enums;
  List.iter (fun f -> emit_flags b f) h.flags;
  List.iter
    (function
      | Item_struct s -> emit_struct b ~structs:h.structs ~alias_base ~enum_const ~inits:h.inits s
      | Item_callback c -> emit_callback b ~alias_base c)
    (sort_items h.structs h.callbacks);
  (* Integer typedefs that are not flags, e.g. WGPUSubmissionIndex. *)
  buf_add b "(** Plain integer typedefs from the headers. *)\nmodule Alias = struct\n";
  List.iter
    (fun (n, base) ->
      if n <> "WGPUFlags" && n <> "WGPUBool" then
        buf_add b
          (Printf.sprintf "  (** [typedef %s %s] *)\n  let %s = %s\n\n" base n
             (snake_case (module_name n)) (prim_ctypes base)))
    h.aliases;
  buf_add b "  let () = ()\nend\n";
  Buffer.contents b

(* ------------------------------------------------------------------ *)
(* wgpu_pin.ml                                                         *)
(* ------------------------------------------------------------------ *)

(* The pin file is the single source of truth for the upstream version; this
   turns it into an OCaml module so the loader can gate on it and the fetch
   script can verify checksums. *)
let emit_pin ~pin ~pin_lines =
  let b = Buffer.create 4096 in
  buf_add b "(** @canonical Wgpu.Pin *)\n\n";
  buf_add b
    "(* The pinned wgpu-native release.\n\n   GENERATED FILE -- DO NOT EDIT.  Produced by [gen/gen.ml] from\n   [vendor/wgpu-native/pin.txt]; see [vendor/wgpu-native/PROVENANCE.md]. *)\n\n";
  let get k = try List.assoc k pin with Not_found -> failwith ("pin.txt: missing key " ^ k) in
  List.iter
    (fun (k, doc) ->
      buf_add b (Printf.sprintf "(** %s *)\nlet %s = %S\n\n" doc k (get k)))
    [ ("tag", "Upstream release tag."); ("version", "Upstream release version.");
      ("commit", "Upstream wgpu-native commit.");
      ("webgpu_headers_commit", "Upstream webgpu-headers commit.");
      ("release_url_prefix", "Base URL of the release assets.") ];
  let split line =
    String.split_on_char ' ' line |> List.filter (fun s -> s <> "")
  in
  buf_add b
    "(** Release archives: platform, asset name, SHA-256, path of the shared\n    library inside the archive. *)\nlet archives : (string * string * string * string) list =\n  [";
  List.iter
    (fun line ->
      match split line with
      | [ "archive"; plat; asset; sha; libpath ] ->
          buf_add b (Printf.sprintf "\n    (%S, %S, %S, %S);" plat asset sha libpath)
      | "archive" :: _ -> failwith ("pin.txt: malformed archive line: " ^ line)
      | _ -> ())
    pin_lines;
  buf_add b "\n  ]\n\n";
  buf_add b "(** SHA-256 of the vendored headers. *)\nlet header_sha256 : (string * string) list =\n  [";
  List.iter
    (fun line ->
      match split line with
      | [ "header_sha256"; name; sha ] -> buf_add b (Printf.sprintf "\n    (%S, %S);" name sha)
      | "header_sha256" :: _ -> failwith ("pin.txt: malformed header_sha256 line: " ^ line)
      | _ -> ())
    pin_lines;
  buf_add b "\n  ]\n\n";
  buf_add b
    "(** Entry points that this wgpu-native release declares but does not\n    implement: calling one aborts the process.  See\n    [vendor/wgpu-native/PROVENANCE.md]. *)\nlet unimplemented : string list =\n  [";
  List.iter
    (fun line ->
      match split line with
      | [ "unimplemented"; name ] -> buf_add b (Printf.sprintf "\n    %S;" name)
      | "unimplemented" :: _ -> failwith ("pin.txt: malformed unimplemented line: " ^ line)
      | _ -> ())
    pin_lines;
  buf_add b "\n  ]\n\n";
  buf_add b
    "(** The version encoding returned by [wgpuGetVersion]: one byte each for\n    major, minor, patch and build. *)\nlet version_u32 =\n  match String.split_on_char '.' version with\n  | [ a; b; c; d ] ->\n      let i = int_of_string in\n      Int32.of_int (((i a land 0xff) lsl 24) lor ((i b land 0xff) lsl 16) lor ((i c land 0xff) lsl 8) lor (i d land 0xff))\n  | _ -> failwith \"unexpected version format\"\n\n";
  buf_add b
    "let string_of_version_u32 (v : int32) =\n\
    \  let byte n = Int32.to_int (Int32.logand (Int32.shift_right_logical v n) 0xffl) in\n\
    \  Printf.sprintf \"%d.%d.%d.%d\" (byte 24) (byte 16) (byte 8) (byte 0)\n";
  Buffer.contents b

(* ------------------------------------------------------------------ *)
(* wgpu_fn.ml                                                          *)
(* ------------------------------------------------------------------ *)

let emit_fn ~pin ~(h : header) =
  let b = Buffer.create (1 lsl 20) in
  let alias_base n = try List.assoc n h.aliases with Not_found -> failwith ("unknown alias " ^ n) in
  banner b ~pin ~canonical:"Wgpu.Fn" ~what:"Raw WebGPU / wgpu-native entry points.";
  buf_add b
    "(* One OCaml function per C entry point, keeping the exact C name.  Symbols\n\
    \   are resolved lazily on first call through {!Wgpu_loader}, so simply\n\
    \   referring to this module does not load libwgpu_native. *)\n\n\
     open Wgpu_types\n\n";
  List.iter
    (fun (f : func_decl) ->
      let params = if f.fn_sig.p_params = [] then [ ("", Void) ] else f.fn_sig.p_params in
      let fn =
        String.concat " @-> " (List.map (fun (_, t) -> ctypes_of ~alias_base t) params)
        ^ " @-> Ctypes.returning "
        ^ ctypes_of ~alias_base f.fn_sig.p_ret
      in
      let args =
        List.mapi (fun i (n, _) -> if n = "" then Printf.sprintf "a%d" i else escape_id n) params
      in
      let doc =
        String.concat " -> "
          (List.map (fun (n, t) -> Printf.sprintf "(* %s *) %s" (if n = "" then "_" else n) (ocaml_type_of ~alias_base t)) params)
        ^ " -> "
        ^ ocaml_type_of ~alias_base f.fn_sig.p_ret
      in
      buf_add b (Printf.sprintf "(** [%s] (from %s)\n\n    [%s] *)\n" f.fn_name f.fn_header doc);
      buf_add b
        (Printf.sprintf "let %s =\n  let s = lazy (Wgpu_loader.foreign %S Ctypes.(%s)) in\n  fun %s -> (Lazy.force s) %s\n\n"
           f.fn_name f.fn_name fn
           (String.concat " " args)
           (String.concat " " args)))
    h.functions;
  buf_add b "(** Every entry point bound by this module, in header order. *)\nlet names : string list =\n  [";
  List.iter (fun (f : func_decl) -> buf_add b (Printf.sprintf " %S;" f.fn_name)) h.functions;
  buf_add b " ]\n";
  Buffer.contents b


(* Default values from the WGPU_*_INIT macros, printed field by field so that
   the C compiler's view of the macro and the generated [init ()] can be
   compared without depending on padding. *)
let rec emit_init_dump_ml b ~structs ~alias_base ~path ~expr (s : struct_decl) =
  List.iter
    (fun f ->
      let get = Printf.sprintf "(Ctypes.getf %s %s.%s)" expr (module_name s.s_name) (escape_id f.fld_name) in
      let p = path ^ "." ^ f.fld_name in
      match f.fld_type with
      | Struct n ->
          let sd = List.find (fun (x : struct_decl) -> x.s_name = n) structs in
          buf_add b (Printf.sprintf "  let %s = %s in\n" (init_tmp p) get);
          emit_init_dump_ml b ~structs ~alias_base ~path:p ~expr:(init_tmp p) sd
      | Anon_union _ -> ()
      | Ptr _ | Handle _ | Callback _ ->
          let nullness =
            match f.fld_type with
            | Callback n ->
                Printf.sprintf
                  "(if Ctypes.raw_address_of_ptr (Ctypes.coerce %s.t (Ctypes.ptr Ctypes.void) %s) = 0n then \"null\" else \"nonnull\")"
                  (module_name n) get
            | _ ->
                Printf.sprintf "(if Ctypes.is_null (Ctypes.to_voidp %s) then \"null\" else \"nonnull\")" get
          in
          buf_add b (Printf.sprintf "  Printf.printf \"init %s=%%s\\n\" %s;\n" p nullness)
      | Prim ("float" | "double") ->
          buf_add b
            (Printf.sprintf
               "  Printf.printf \"init %s=%%s\\n\" (if Float.is_nan %s then \"nan\" else Printf.sprintf \"%%.17g\" %s);\n"
               p get get)
      | Prim "int32_t" -> buf_add b (Printf.sprintf "  Printf.printf \"init %s=%%ld\\n\" %s;\n" p get)
      | Prim "int" -> buf_add b (Printf.sprintf "  Printf.printf \"init %s=%%d\\n\" %s;\n" p get)
      | Prim "int64_t" -> buf_add b (Printf.sprintf "  Printf.printf \"init %s=%%Ld\\n\" %s;\n" p get)
      | Enum _ | Flags _ -> buf_add b (Printf.sprintf "  Printf.printf \"init %s=%%d\\n\" %s;\n" p get)
      | Prim ("uint8_t" | "uint16_t" | "uint32_t" | "uint64_t" | "size_t") | Bool | Alias _ ->
          let to_string =
            match f.fld_type with
            | Prim "uint8_t" -> "Unsigned.UInt8.to_string"
            | Prim "uint16_t" -> "Unsigned.UInt16.to_string"
            | Prim "uint32_t" | Bool -> "Unsigned.UInt32.to_string"
            | Prim "uint64_t" -> "Unsigned.UInt64.to_string"
            | Prim "size_t" -> "Unsigned.Size_t.to_string"
            | Alias n -> (
                match alias_base n with
                | "uint64_t" -> "Unsigned.UInt64.to_string"
                | "uint32_t" -> "Unsigned.UInt32.to_string"
                | b -> failwith ("unsupported alias " ^ b))
            | _ -> assert false
          in
          buf_add b (Printf.sprintf "  Printf.printf \"init %s=%%s\\n\" (%s %s);\n" p to_string get)
      | Void | Prim _ | Unresolved _ -> failwith ("unsupported field type in " ^ p))
    s.s_fields

and init_tmp path =
  "v_" ^ String.map (fun c -> if c = '.' then '_' else c) (snake_case path)

(* ------------------------------------------------------------------ *)
(* wgpu_abi.ml -- the OCaml half of the ABI check                      *)
(* ------------------------------------------------------------------ *)

let emit_abi ~pin ~(h : header) =
  let b = Buffer.create (1 lsl 18) in
  let alias_base n = try List.assoc n h.aliases with Not_found -> failwith ("unknown alias " ^ n) in
  banner b ~pin ~canonical:"Wgpu.Abi"
    ~what:"ABI description computed by ctypes, compared against the C headers by test/abi.";
  buf_add b "open Wgpu_types\n\n";
  buf_add b "let dump () =\n";
  List.iter
    (fun (s : struct_decl) ->
      let m = module_name s.s_name in
      buf_add b
        (Printf.sprintf
           "  Printf.printf \"struct %s size=%%d align=%%d\\n\" (Ctypes.sizeof %s.t) (Ctypes.alignment %s.t);\n"
           s.s_name m m);
      List.iter
        (fun f ->
          buf_add b
            (Printf.sprintf "  Printf.printf \"field %s.%s offset=%%d\\n\" (Ctypes.offsetof %s.%s);\n"
               s.s_name f.fld_name m (escape_id f.fld_name));
          match f.fld_type with
          | Anon_union (uname, variants) ->
              let um = m ^ "." ^ module_name uname in
              buf_add b
                (Printf.sprintf
                   "  Printf.printf \"union %s.%s size=%%d\\n\" (Ctypes.sizeof %s.t);\n" s.s_name
                   f.fld_name um);
              (* ctypes has no [offsetof] for union members; they are at offset
                 0 by construction, so the C side must report the offset of the
                 union field itself. *)
              List.iter
                (fun v ->
                  buf_add b
                    (Printf.sprintf
                       "  Printf.printf \"uvariant %s.%s.%s offset=%%d\\n\" (Ctypes.offsetof %s.%s);\n"
                       s.s_name f.fld_name v.fld_name m (escape_id f.fld_name)))
                variants
          | _ -> ())
        s.s_fields)
    h.structs;
  List.iter
    (fun (e : enum_decl) ->
      buf_add b
        (Printf.sprintf "  Printf.printf \"enum %s size=%%d\\n\" (Ctypes.sizeof %s.t);\n" e.e_name
           (module_name e.e_name));
      List.iter
        (fun (cn, v) -> buf_add b (Printf.sprintf "  Printf.printf \"value %s=%%Ld\\n\" %LdL;\n" cn v))
        e.e_values)
    h.enums;
  List.iter
    (fun (f : flags_decl) ->
      buf_add b
        (Printf.sprintf "  Printf.printf \"flags %s size=%%d\\n\" (Ctypes.sizeof %s.t);\n" f.f_name
           (module_name f.f_name));
      List.iter
        (fun (cn, v) -> buf_add b (Printf.sprintf "  Printf.printf \"value %s=%%Ld\\n\" %LdL;\n" cn v))
        f.f_values)
    h.flags;
  List.iter
    (fun (k : const_decl) ->
      let name = constant_name ~type_c_name:"WGPU" k.k_name in
      let expr =
        match k.k_value with
        | C_int _ -> Printf.sprintf "Unsigned.UInt32.to_string Constants.%s" name
        | C_u32_max -> Printf.sprintf "Unsigned.UInt32.to_string Constants.%s" name
        | C_u64_max -> Printf.sprintf "Unsigned.UInt64.to_string Constants.%s" name
        | C_size_max -> Printf.sprintf "Unsigned.Size_t.to_string Constants.%s" name
        | C_nan -> Printf.sprintf "(if Float.is_nan Constants.%s then \"nan\" else \"not-nan\")" name
      in
      buf_add b (Printf.sprintf "  Printf.printf \"const %s=%%s\\n\" (%s);\n" k.k_name expr))
    h.constants;
  List.iter
    (fun (i : init_decl) ->
      let sd = List.find (fun (x : struct_decl) -> x.s_name = i.init_struct) h.structs in
      let root = init_tmp i.init_struct in
      buf_add b (Printf.sprintf "  let %s = %s.init () in\n" root (module_name i.init_struct));
      emit_init_dump_ml b ~structs:h.structs ~alias_base ~path:i.init_struct ~expr:root sd)
    h.inits;
  buf_add b "  ()\n\n";
  (* Declaration inventories, so that tests can check the generated surface
     against an independent scan of the headers. *)
  let list_of name items =
    buf_add b
      (Printf.sprintf "(** Every %s declared by the vendored headers, in header order. *)\nlet %ss : string list =\n  [" name name);
    List.iter (fun n -> buf_add b (Printf.sprintf " %S;" n)) items;
    buf_add b " ]\n\n"
  in
  list_of "handle" h.handles;
  list_of "struct" (List.map (fun (s : struct_decl) -> s.s_name) h.structs);
  list_of "enum" (List.map (fun (e : enum_decl) -> e.e_name) h.enums);
  list_of "flag" (List.map (fun (f : flags_decl) -> f.f_name) h.flags);
  list_of "callback" (List.map (fun (c : callback_decl) -> c.cb_name) h.callbacks);
  list_of "constant" (List.map (fun (k : const_decl) -> k.k_name) h.constants);
  list_of "init_macro" (List.map (fun (i : init_decl) -> i.init_macro) h.inits);
  Buffer.contents b


let rec emit_init_dump_c b ~structs ~path ~expr (s : struct_decl) =
  List.iter
    (fun f ->
      let get = Printf.sprintf "%s.%s" expr f.fld_name in
      let p = path ^ "." ^ f.fld_name in
      match f.fld_type with
      | Struct n ->
          let sd = List.find (fun (x : struct_decl) -> x.s_name = n) structs in
          emit_init_dump_c b ~structs ~path:p ~expr:get sd
      | Anon_union _ -> ()
      | Ptr _ | Handle _ | Callback _ ->
          buf_add b
            (Printf.sprintf "  printf(\"init %s=%%s\\n\", (%s) ? \"nonnull\" : \"null\");\n" p get)
      | Prim ("float" | "double") ->
          buf_add b
            (Printf.sprintf
               "  if (isnan(%s)) printf(\"init %s=nan\\n\"); else printf(\"init %s=%%.17g\\n\", (double)%s);\n"
               get p p get)
      | Prim ("int32_t" | "int" | "int64_t") ->
          buf_add b
            (Printf.sprintf "  printf(\"init %s=%%\" PRId64 \"\\n\", (int64_t)%s);\n" p get)
      | Enum _ | Flags _ | Bool | Alias _
      | Prim ("uint8_t" | "uint16_t" | "uint32_t" | "uint64_t" | "size_t") ->
          buf_add b
            (Printf.sprintf "  printf(\"init %s=%%\" PRIu64 \"\\n\", (uint64_t)%s);\n" p get)
      | Void | Prim _ | Unresolved _ -> failwith ("unsupported field type in " ^ p))
    s.s_fields

(* ------------------------------------------------------------------ *)
(* abi_probe.c -- the C half of the ABI check                          *)
(* ------------------------------------------------------------------ *)

let emit_abi_probe ~(h : header) =
  let b = Buffer.create (1 lsl 18) in
  buf_add b
    "/* GENERATED FILE -- DO NOT EDIT.  Produced by gen/gen.ml.\n\
    \   Prints the struct layouts, enum values and sentinels that the real C\n\
    \   compiler computes from the vendored headers.  test/abi diffs this\n\
    \   against what ctypes computes from the generated OCaml bindings. */\n\n\
     #include <inttypes.h>\n\
     #include <math.h>\n\
     #include <stddef.h>\n\
     #include <stdio.h>\n\
     #include <webgpu/webgpu.h>\n\
     #include <webgpu/wgpu.h>\n\n\
     int main(void) {\n";
  List.iter
    (fun (s : struct_decl) ->
      buf_add b
        (Printf.sprintf "  printf(\"struct %s size=%%zu align=%%zu\\n\", sizeof(%s), _Alignof(%s));\n"
           s.s_name s.s_name s.s_name);
      List.iter
        (fun f ->
          buf_add b
            (Printf.sprintf "  printf(\"field %s.%s offset=%%zu\\n\", offsetof(%s, %s));\n" s.s_name
               f.fld_name s.s_name f.fld_name);
          match f.fld_type with
          | Anon_union (_, variants) ->
              buf_add b
                (Printf.sprintf
                   "  printf(\"union %s.%s size=%%zu\\n\", sizeof(((%s *)0)->%s));\n" s.s_name
                   f.fld_name s.s_name f.fld_name);
              List.iter
                (fun v ->
                  buf_add b
                    (Printf.sprintf
                       "  printf(\"uvariant %s.%s.%s offset=%%zu\\n\", offsetof(%s, %s.%s));\n"
                       s.s_name f.fld_name v.fld_name s.s_name f.fld_name v.fld_name))
                variants
          | _ -> ())
        s.s_fields)
    h.structs;
  List.iter
    (fun (e : enum_decl) ->
      buf_add b (Printf.sprintf "  printf(\"enum %s size=%%zu\\n\", sizeof(%s));\n" e.e_name e.e_name);
      List.iter
        (fun (cn, _) ->
          buf_add b (Printf.sprintf "  printf(\"value %s=%%\" PRId64 \"\\n\", (int64_t)%s);\n" cn cn))
        e.e_values)
    h.enums;
  List.iter
    (fun (f : flags_decl) ->
      buf_add b (Printf.sprintf "  printf(\"flags %s size=%%zu\\n\", sizeof(%s));\n" f.f_name f.f_name);
      List.iter
        (fun (cn, _) ->
          buf_add b (Printf.sprintf "  printf(\"value %s=%%\" PRId64 \"\\n\", (int64_t)%s);\n" cn cn))
        f.f_values)
    h.flags;
  List.iter
    (fun (k : const_decl) ->
      match k.k_value with
      | C_nan ->
          buf_add b
            (Printf.sprintf "  printf(\"const %s=%%s\\n\", isnan(%s) ? \"nan\" : \"not-nan\");\n"
               k.k_name k.k_name)
      | _ ->
          buf_add b
            (Printf.sprintf "  printf(\"const %s=%%\" PRIu64 \"\\n\", (uint64_t)%s);\n" k.k_name k.k_name))
    h.constants;
  List.iter
    (fun (i : init_decl) ->
      let sd = List.find (fun (x : struct_decl) -> x.s_name = i.init_struct) h.structs in
      let var = "init_" ^ String.lowercase_ascii (module_name i.init_struct) in
      buf_add b (Printf.sprintf "  { %s %s = %s;\n" i.init_struct var i.init_macro);
      emit_init_dump_c b ~structs:h.structs ~path:i.init_struct ~expr:var sd;
      buf_add b "  }\n")
    h.inits;
  buf_add b "  return 0;\n}\n";
  Buffer.contents b
