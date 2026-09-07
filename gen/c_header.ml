(* Parser for the (small, very regular) subset of C used by the vendored
   [webgpu.h] and [wgpu.h] headers.

   The parser is deliberately strict: anything it does not recognise raises
   [Parse_error] with a line number, so that a header bump can never silently
   drop a declaration.  Everything the generator emits comes from here; no
   constant, layout or signature is hard-coded elsewhere. *)

exception Parse_error of string

let fail fmt = Printf.ksprintf (fun s -> raise (Parse_error s)) fmt

(* ------------------------------------------------------------------ *)
(* Model                                                               *)
(* ------------------------------------------------------------------ *)

type ctype =
  | Void
  | Prim of string  (** [uint32_t], [size_t], [float], [char], ... *)
  | Bool  (** [WGPUBool] *)
  | Enum of string  (** C name, e.g. [WGPULoadOp] *)
  | Flags of string  (** C name of a [WGPUFlags] typedef *)
  | Struct of string  (** C name, e.g. [WGPUBufferDescriptor] *)
  | Handle of string  (** C name, e.g. [WGPUBuffer] *)
  | Callback of string  (** C name of a function-pointer typedef *)
  | Alias of string  (** other integer typedef, e.g. [WGPUSubmissionIndex] *)
  | Ptr of ctype
  | Anon_union of string * field list
      (** anonymous [union] member of a struct; the string is the synthesised
          name [<StructName>_<fieldName>] *)
  | Unresolved of string  (** filled in by {!resolve} *)

and field = { fld_name : string; fld_type : ctype }

type struct_decl = {
  s_name : string;
  s_fields : field list;
  s_header : string;  (** header file the declaration came from *)
}

type enum_decl = { e_name : string; e_values : (string * int64) list; e_header : string }

type flags_decl = {
  f_name : string;
  f_base : string;  (** always ["WGPUFlags"] today *)
  f_values : (string * int64) list;
  f_header : string;
}

type fn_sig = { p_params : (string * ctype) list; p_ret : ctype }

type callback_decl = { cb_name : string; cb_sig : fn_sig; cb_header : string }

type func_decl = { fn_name : string; fn_sig : fn_sig; fn_header : string }

(** Values that appear on the right-hand side of the [WGPU_*_INIT] macros. *)
type init_value =
  | I_null
  | I_int of int64
  | I_float of float
  | I_nan
  | I_const of string  (** a [#define]d sentinel, e.g. [WGPU_STRLEN] *)
  | I_enum of string  (** an enum/flag constant, e.g. [WGPULoadOp_Undefined] *)
  | I_zero_struct  (** [_wgpu_STRUCT_ZERO_INIT] *)
  | I_struct_init of string  (** [WGPU_X_INIT], holds the struct's C name *)
  | I_inline_struct of string * (string * init_value) list

type init_decl = {
  init_macro : string;  (** the [#define]d macro name, e.g. [WGPU_LIMITS_INIT] *)
  init_struct : string;
  init_fields : (string * init_value) list;
}

type const_value = C_int of int64 | C_u32_max | C_u64_max | C_size_max | C_nan

type const_decl = { k_name : string; k_value : const_value }

type header = {
  handles : string list;
  enums : enum_decl list;
  flags : flags_decl list;
  structs : struct_decl list;
  callbacks : callback_decl list;
  functions : func_decl list;
  aliases : (string * string) list;  (** typedef name -> underlying primitive *)
  constants : const_decl list;
  inits : init_decl list;
}

(* ------------------------------------------------------------------ *)
(* Lexer                                                               *)
(* ------------------------------------------------------------------ *)

type token = Ident of string | Num of string | Punct of string | Str of string

type lexer = { toks : (token * int) array; mutable pos : int; file : string }

let strip_comments src =
  let b = Buffer.create (String.length src) in
  let n = String.length src in
  let i = ref 0 in
  while !i < n do
    if !i + 1 < n && src.[!i] = '/' && src.[!i + 1] = '*' then begin
      let start = !i in
      i := !i + 2;
      while !i + 1 < n && not (src.[!i] = '*' && src.[!i + 1] = '/') do
        if src.[!i] = '\n' then Buffer.add_char b '\n';
        incr i
      done;
      if !i + 1 >= n then fail "unterminated block comment at offset %d" start;
      i := !i + 2
    end
    else if !i + 1 < n && src.[!i] = '/' && src.[!i + 1] = '/' then begin
      while !i < n && src.[!i] <> '\n' do
        incr i
      done
    end
    else begin
      Buffer.add_char b src.[!i];
      incr i
    end
  done;
  Buffer.contents b

(* Macros that only carry compiler attributes and can be erased. *)
let attribute_macros =
  [ "WGPU_EXPORT"; "WGPU_ENUM_ATTRIBUTE"; "WGPU_STRUCTURE_ATTRIBUTE";
    "WGPU_OBJECT_ATTRIBUTE"; "WGPU_FUNCTION_ATTRIBUTE"; "WGPU_NULLABLE" ]

let is_ident_start c = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c = '_'
let is_ident_char c = is_ident_start c || (c >= '0' && c <= '9')
let is_digit c = c >= '0' && c <= '9'

let lex ~file src =
  let toks = ref [] in
  let line = ref 1 in
  let n = String.length src in
  let i = ref 0 in
  while !i < n do
    let c = src.[!i] in
    if c = '\n' then (incr line; incr i)
    else if c = ' ' || c = '\t' || c = '\r' then incr i
    else if is_ident_start c then begin
      let start = !i in
      while !i < n && is_ident_char src.[!i] do incr i done;
      let s = String.sub src start (!i - start) in
      if not (List.mem s attribute_macros) then toks := (Ident s, !line) :: !toks
    end
    else if is_digit c then begin
      let start = !i in
      while
        !i < n
        && (is_ident_char src.[!i]
           || (src.[!i] = '.' && !i + 1 < n && (is_digit src.[!i + 1] || src.[!i + 1] = 'f'))
           || (src.[!i] = '.' && (!i + 1 >= n || not (is_ident_char src.[!i + 1]))))
      do
        incr i
      done;
      toks := (Num (String.sub src start (!i - start)), !line) :: !toks
    end
    else if c = '"' then begin
      let start = !i + 1 in
      incr i;
      while !i < n && src.[!i] <> '"' do incr i done;
      toks := (Str (String.sub src start (!i - start)), !line) :: !toks;
      incr i
    end
    else begin
      (* two-character punctuation we care about *)
      let two = if !i + 1 < n then String.sub src !i 2 else "" in
      if two = "<<" || two = ">>" then begin
        toks := (Punct two, !line) :: !toks;
        i := !i + 2
      end
      else begin
        toks := (Punct (String.make 1 c), !line) :: !toks;
        incr i
      end
    end
  done;
  { toks = Array.of_list (List.rev !toks); pos = 0; file }

let peek lx = if lx.pos < Array.length lx.toks then Some (fst lx.toks.(lx.pos)) else None
let line lx = if lx.pos < Array.length lx.toks then snd lx.toks.(lx.pos) else 0

let next lx =
  match peek lx with
  | None -> fail "%s: unexpected end of file" lx.file
  | Some t -> lx.pos <- lx.pos + 1; t

let expect_punct lx p =
  match next lx with
  | Punct q when q = p -> ()
  | t ->
      let d = match t with Ident s -> s | Num s -> s | Punct s -> s | Str s -> s in
      fail "%s:%d: expected '%s', got '%s'" lx.file (line lx) p d

let expect_ident lx =
  match next lx with
  | Ident s -> s
  | _ -> fail "%s:%d: expected an identifier" lx.file (line lx)

let accept_punct lx p =
  match peek lx with Some (Punct q) when q = p -> lx.pos <- lx.pos + 1; true | _ -> false

let accept_ident lx s =
  match peek lx with Some (Ident q) when q = s -> lx.pos <- lx.pos + 1; true | _ -> false

(* ------------------------------------------------------------------ *)
(* Integer expressions ( "1 << 3", "(1 << 0) | (1 << 1)", "0x0A" )      *)
(* ------------------------------------------------------------------ *)

let parse_int_literal lx s =
  let s = if String.length s > 0 && (s.[String.length s - 1] = 'u' || s.[String.length s - 1] = 'U')
          then String.sub s 0 (String.length s - 1) else s in
  match Int64.of_string_opt s with
  | Some v -> v
  | None -> fail "%s:%d: cannot parse integer literal %S" lx.file (line lx) s

let rec parse_or lx =
  let l = parse_shift lx in
  if accept_punct lx "|" then Int64.logor l (parse_or lx) else l

and parse_shift lx =
  let l = parse_atom lx in
  if accept_punct lx "<<" then Int64.shift_left l (Int64.to_int (parse_atom lx)) else l

and parse_atom lx =
  match next lx with
  | Num s -> parse_int_literal lx s
  | Punct "(" ->
      let v = parse_or lx in
      expect_punct lx ")";
      v
  | Punct "-" -> Int64.neg (parse_atom lx)
  | _ -> fail "%s:%d: unsupported constant expression" lx.file (line lx)

(* ------------------------------------------------------------------ *)
(* Types                                                               *)
(* ------------------------------------------------------------------ *)

let prims = [ "uint8_t"; "uint16_t"; "uint32_t"; "uint64_t"; "int8_t"; "int16_t";
              "int32_t"; "int64_t"; "size_t"; "float"; "double"; "char"; "int" ]

(* Parses "[const] [struct] NAME [const] ['*' [const]]*" and returns the type;
   the declarator name (if any) is left for the caller. *)
let parse_type lx =
  ignore (accept_ident lx "const");
  ignore (accept_ident lx "struct");
  let base =
    match next lx with
    | Ident "void" -> Void
    | Ident s when List.mem s prims -> Prim s
    | Ident "WGPUBool" -> Bool
    | Ident s -> Unresolved s
    | _ -> fail "%s:%d: expected a type name" lx.file (line lx)
  in
  let ty = ref base in
  let continue_ = ref true in
  while !continue_ do
    ignore (accept_ident lx "const");
    if accept_punct lx "*" then ty := Ptr !ty else continue_ := false
  done;
  !ty

let parse_params lx =
  expect_punct lx "(";
  if accept_punct lx ")" then []
  else begin
    (* "(void)" means no parameters *)
    match peek lx with
    | Some (Ident "void") when (match fst lx.toks.(lx.pos + 1) with Punct ")" -> true | _ -> false)
      ->
        lx.pos <- lx.pos + 2;
        []
    | _ ->
        let params = ref [] in
        let fin = ref false in
        while not !fin do
          let ty = parse_type lx in
          let name = match peek lx with Some (Ident _) -> expect_ident lx | _ -> "" in
          params := (name, ty) :: !params;
          if not (accept_punct lx ",") then (expect_punct lx ")"; fin := true)
        done;
        List.rev !params
  end

(* ------------------------------------------------------------------ *)
(* #define handling                                                    *)
(* ------------------------------------------------------------------ *)

(* Splits the source into (directive lines, source with directives blanked).
   Line continuations are joined so that multi-line macros stay together. *)
let split_directives src =
  let joined = ref [] in
  let out = Buffer.create (String.length src) in
  let lines = String.split_on_char '\n' src in
  let pending = Buffer.create 256 in
  let in_directive = ref false in
  List.iter
    (fun l ->
      let trimmed = String.trim l in
      let starts_directive = String.length trimmed > 0 && trimmed.[0] = '#' in
      let continues = String.length trimmed > 0 && trimmed.[String.length trimmed - 1] = '\\' in
      let body =
        if continues then String.sub trimmed 0 (String.length trimmed - 1) else trimmed
      in
      if !in_directive || starts_directive then begin
        Buffer.add_string pending body;
        Buffer.add_char pending ' ';
        if continues then in_directive := true
        else begin
          in_directive := false;
          joined := Buffer.contents pending :: !joined;
          Buffer.clear pending
        end;
        Buffer.add_char out '\n'
      end
      else (Buffer.add_string out l; Buffer.add_char out '\n'))
    lines;
  (List.rev !joined, Buffer.contents out)

let starts_with p s = String.length s >= String.length p && String.sub s 0 (String.length p) = p

(* Index of the first occurrence of [needle] in [hay]; raises [Not_found]. *)
let find_sub hay needle =
  let n = String.length hay and m = String.length needle in
  let rec go i = if i + m > n then raise Not_found else if String.sub hay i m = needle then i else go (i + 1) in
  go 0

(* Macros in the WGPU_ namespace that carry no API information.  Anything else
   the generator does not understand is an error, so a header bump cannot
   silently drop a sentinel: see [parse_file]. *)
let ignored_macros =
  [ (* include guards *)
    "WGPU_H_";
    (* compiler attribute macros, erased by the lexer *)
    "WGPU_EXPORT"; "WGPU_ENUM_ATTRIBUTE"; "WGPU_STRUCTURE_ATTRIBUTE"; "WGPU_OBJECT_ATTRIBUTE";
    "WGPU_FUNCTION_ATTRIBUTE"; "WGPU_NULLABLE";
    (* build-time switches, never defined in the vendored headers themselves *)
    "WGPU_SHARED_LIBRARY"; "WGPU_IMPLEMENTATION" ]

(* [#   define NAME value] -> [Some ("NAME", "value")], whatever whitespace the
   header uses between the hash, the keyword and the name.  Function-like
   macros keep their parameter list in the name so that they cannot be mistaken
   for an object-like macro. *)
let directive_define d =
  let n = String.length d in
  if n = 0 || d.[0] <> '#' then None
  else begin
    let i = ref 1 in
    let skip_blanks () = while !i < n && (d.[!i] = ' ' || d.[!i] = '\t') do incr i done in
    skip_blanks ();
    let start = !i in
    while !i < n && is_ident_char d.[!i] do incr i done;
    let keyword = String.sub d start (!i - start) in
    if keyword <> "define" then None
    else begin
      skip_blanks ();
      let start = !i in
      while !i < n && is_ident_char d.[!i] do incr i done;
      let name = String.sub d start (!i - start) in
      if name = "" then None
      else begin
        (* A '(' immediately after the name makes it function-like; keep it in
           the value so the caller still sees a non-empty value. *)
        let value = String.trim (String.sub d !i (n - !i)) in
        Some (name, value)
      end
    end
  end

let parse_sentinel ~file name rest =
  let rest = String.trim rest in
  let v =
    match rest with
    | "(UINT32_MAX)" -> Some C_u32_max
    | "(UINT64_MAX)" -> Some C_u64_max
    | "(SIZE_MAX)" -> Some C_size_max
    | "(NAN)" -> Some C_nan
    | _ ->
        if starts_with "(UINT32_C(" rest || starts_with "(UINT64_C(" rest then
          let i = String.index rest '(' in
          let j = String.index_from rest (i + 1) '(' in
          let k = String.index_from rest j ')' in
          Some (C_int (Int64.of_string (String.trim (String.sub rest (j + 1) (k - j - 1)))))
        else None
  in
  match v with
  | Some value -> Some { k_name = name; k_value = value }
  | None -> fail "%s: unsupported #define value for %s: %S" file name rest

(* Parses the body of a WGPU_*_INIT macro. *)
let rec parse_init ~file ~macro ~text =
  (* text looks like:  _wgpu_MAKE_INIT_STRUCT(WGPUFoo, {  /*.a=*/ X _wgpu_COMMA ... }) *)
  let open_paren = String.index text '(' in
  let comma = String.index_from text open_paren ',' in
  let sname = String.trim (String.sub text (open_paren + 1) (comma - open_paren - 1)) in
  let brace = String.index_from text comma '{' in
  let close = String.rindex text '}' in
  let body = String.sub text (brace + 1) (close - brace - 1) in
  let parts =
    (* split on the _wgpu_COMMA separator, but not inside nested parens/braces *)
    let res = ref [] and buf = Buffer.create 64 and depth = ref 0 in
    let n = String.length body in
    let i = ref 0 in
    while !i < n do
      if body.[!i] = '(' || body.[!i] = '{' then (incr depth; Buffer.add_char buf body.[!i]; incr i)
      else if body.[!i] = ')' || body.[!i] = '}' then
        (decr depth; Buffer.add_char buf body.[!i]; incr i)
      else if !depth = 0 && starts_with "_wgpu_COMMA" (String.sub body !i (min 11 (n - !i))) then begin
        res := Buffer.contents buf :: !res;
        Buffer.clear buf;
        i := !i + 11
      end
      else (Buffer.add_char buf body.[!i]; incr i)
    done;
    if String.trim (Buffer.contents buf) <> "" then res := Buffer.contents buf :: !res;
    List.rev !res
  in
  let rec value_of_string s =
    let s = String.trim s in
    if s = "NULL" then I_null
    else if s = "NAN" then I_nan
    else if s = "_wgpu_STRUCT_ZERO_INIT" then I_zero_struct
    else if starts_with "_wgpu_ENUM_ZERO_INIT" s then I_int 0L
    else if starts_with "_wgpu_MAKE_INIT_STRUCT" s then begin
      let sub = parse_init ~file ~macro ~text:s in
      I_inline_struct (sub.init_struct, sub.init_fields)
    end
    else if starts_with "(WGPUSType)" s then
      value_of_string (String.sub s 11 (String.length s - 11))
    else if String.length s > 5 && starts_with "WGPU_" s && Filename.check_suffix s "_INIT" then
      I_struct_init s
    else if starts_with "WGPU_" s then I_const s
    else if starts_with "WGPU" s then I_enum s
    else
      match Int64.of_string_opt s with
      | Some v -> I_int v
      | None -> (
          let f = if Filename.check_suffix s "f" then String.sub s 0 (String.length s - 1) else s in
          match float_of_string_opt f with
          | Some v -> I_float v
          | None -> fail "%s: unsupported initialiser value %S in %s" file s sname)
  in
  let fields =
    List.filter_map
      (fun part ->
        let part = String.trim part in
        if part = "" then None
        else if starts_with "/*." part then begin
          let eq = String.index part '=' in
          let fname = String.sub part 3 (eq - 3) in
          let close_c = find_sub part "*/" in
          let v = String.sub part (close_c + 2) (String.length part - close_c - 2) in
          Some (fname, value_of_string v)
        end
        else fail "%s: unsupported initialiser fragment %S in %s" file part sname)
      parts
  in
  { init_macro = macro; init_struct = sname; init_fields = fields }

(* ------------------------------------------------------------------ *)
(* Top-level parse                                                     *)
(* ------------------------------------------------------------------ *)

type acc = {
  mutable a_handles : string list;
  mutable a_enums : enum_decl list;
  mutable a_flags : flags_decl list;
  mutable a_structs : struct_decl list;
  mutable a_callbacks : callback_decl list;
  mutable a_functions : func_decl list;
  mutable a_aliases : (string * string) list;
  mutable a_constants : const_decl list;
  mutable a_inits : init_decl list;
  mutable a_flag_values : (string * (string * int64) list) list;
}

let parse_file acc ~file ~src =
  (* Directives are extracted from the raw source because the [WGPU_*_INIT]
     macros carry their field names in /*.field=*/ comments.  The rest of the
     header is comment-stripped before lexing. *)
  let directives, body = split_directives src in
  let body = strip_comments body in
  (* #define handling: sentinels and struct initialisers *)
  List.iter
    (fun d ->
      match directive_define d with
      | None -> ()
      | Some (name, value) ->
          if not (starts_with "WGPU_" name) then
            (* Macros of the implementation namespace (_wgpu_COMMA, ...) and the
               header guards of other headers are not part of the API. *)
            ()
          else if List.mem name ignored_macros then ()
          else if Filename.check_suffix name "_INIT" then
            acc.a_inits <- parse_init ~file ~macro:name ~text:value :: acc.a_inits
          else if value = "" then
            fail
              "%s: #define %s has no value and is not in the generator's ignore list; a header \
               bump added a macro the generator does not understand"
              file name
          else (
            match parse_sentinel ~file name value with
            | Some c -> acc.a_constants <- c :: acc.a_constants
            | None -> ()))
    directives;
  let lx = lex ~file body in
  let rec loop () =
    match peek lx with
    | None -> ()
    | Some (Punct ("{" | "}" | ";")) -> lx.pos <- lx.pos + 1; loop ()
    | Some (Ident "extern") ->
        lx.pos <- lx.pos + 1;
        (match peek lx with Some (Str _) -> lx.pos <- lx.pos + 1 | _ -> ());
        loop ()
    | Some (Ident "struct")
      when (match fst lx.toks.(lx.pos + 2) with Punct ";" -> true | _ -> false) ->
        (* forward declaration: struct WGPUFoo; *)
        lx.pos <- lx.pos + 3;
        loop ()
    | Some (Ident "typedef") -> lx.pos <- lx.pos + 1; parse_typedef (); loop ()
    | Some (Ident "static") -> lx.pos <- lx.pos + 1; parse_static_const (); loop ()
    | Some (Ident _) -> parse_function (); loop ()
    | Some t ->
        let d = match t with Ident s | Num s | Punct s | Str s -> s in
        fail "%s:%d: unexpected token %S at top level" file (line lx) d
  and parse_typedef () =
    match peek lx with
    | Some (Ident "enum") ->
        lx.pos <- lx.pos + 1;
        let name = expect_ident lx in
        expect_punct lx "{";
        let values = ref [] in
        let fin = ref false in
        while not !fin do
          if accept_punct lx "}" then fin := true
          else begin
            let vname = expect_ident lx in
            expect_punct lx "=";
            let v = parse_or lx in
            values := (vname, v) :: !values;
            ignore (accept_punct lx ",")
          end
        done;
        let name2 = expect_ident lx in
        if name2 <> name then fail "%s:%d: enum typedef name mismatch (%s vs %s)" file (line lx) name name2;
        expect_punct lx ";";
        acc.a_enums <- { e_name = name; e_values = List.rev !values; e_header = file } :: acc.a_enums
    | Some (Ident "struct") -> (
        lx.pos <- lx.pos + 1;
        let name = expect_ident lx in
        match peek lx with
        | Some (Punct "{") ->
            lx.pos <- lx.pos + 1;
            let fields = ref [] in
            while not (accept_punct lx "}") do
              if accept_ident lx "union" then begin
                (* anonymous union member: union { ... } name; *)
                expect_punct lx "{";
                let variants = ref [] in
                while not (accept_punct lx "}") do
                  let vty = parse_type lx in
                  let vname = expect_ident lx in
                  expect_punct lx ";";
                  variants := { fld_name = vname; fld_type = vty } :: !variants
                done;
                let fname = expect_ident lx in
                expect_punct lx ";";
                fields :=
                  { fld_name = fname;
                    fld_type = Anon_union (name ^ "_" ^ fname, List.rev !variants) }
                  :: !fields
              end
              else begin
                let ty = parse_type lx in
                let fname = expect_ident lx in
                expect_punct lx ";";
                fields := { fld_name = fname; fld_type = ty } :: !fields
              end
            done;
            let name2 = expect_ident lx in
            if name2 <> name then
              fail "%s:%d: struct typedef name mismatch (%s vs %s)" file (line lx) name name2;
            expect_punct lx ";";
            acc.a_structs <-
              { s_name = name; s_fields = List.rev !fields; s_header = file } :: acc.a_structs
        | Some (Punct "*") ->
            (* opaque handle: typedef struct WGPUFooImpl (star) WGPUFoo; *)
            lx.pos <- lx.pos + 1;
            let hname = expect_ident lx in
            expect_punct lx ";";
            if name <> hname ^ "Impl" then
              fail "%s:%d: unexpected handle typedef %s -> %s" file (line lx) name hname;
            acc.a_handles <- hname :: acc.a_handles
        | _ -> fail "%s:%d: unsupported struct typedef %s" file (line lx) name)
    | Some (Ident _) -> (
        let ty = parse_type lx in
        match peek lx with
        | Some (Punct "(") ->
            (* function pointer typedef: R ( * NAME)(params); *)
            lx.pos <- lx.pos + 1;
            expect_punct lx "*";
            let name = expect_ident lx in
            expect_punct lx ")";
            let params = parse_params lx in
            expect_punct lx ";";
            acc.a_callbacks <-
              { cb_name = name; cb_sig = { p_params = params; p_ret = ty }; cb_header = file }
              :: acc.a_callbacks
        | Some (Ident _) ->
            let name = expect_ident lx in
            expect_punct lx ";";
            let base = match ty with
              | Prim p -> p
              | Unresolved u -> u
              | Bool -> "WGPUBool"
              | _ -> fail "%s:%d: unsupported typedef target for %s" file (line lx) name
            in
            if base = "WGPUFlags" then
              acc.a_flags <- { f_name = name; f_base = base; f_values = []; f_header = file } :: acc.a_flags
            else acc.a_aliases <- (name, base) :: acc.a_aliases
        | _ -> fail "%s:%d: unsupported typedef" file (line lx))
    | _ -> fail "%s:%d: unsupported typedef" file (line lx)
  and parse_static_const () =
    if not (accept_ident lx "const") then fail "%s:%d: expected 'const' after 'static'" file (line lx);
    let tyname = expect_ident lx in
    let cname = expect_ident lx in
    expect_punct lx "=";
    let v = parse_or lx in
    expect_punct lx ";";
    let prev = try List.assoc tyname acc.a_flag_values with Not_found -> [] in
    acc.a_flag_values <-
      (tyname, prev @ [ (cname, v) ]) :: List.remove_assoc tyname acc.a_flag_values
  and parse_function () =
    let ret = parse_type lx in
    let name = expect_ident lx in
    let params = parse_params lx in
    expect_punct lx ";";
    acc.a_functions <-
      { fn_name = name; fn_sig = { p_params = params; p_ret = ret }; fn_header = file }
      :: acc.a_functions
  in
  loop ()

(* Resolve [Unresolved] names now that every declaration has been seen. *)
let resolve h =
  let handle_tbl = Hashtbl.create 64 in
  List.iter (fun n -> Hashtbl.replace handle_tbl n ()) h.handles;
  let enum_tbl = Hashtbl.create 64 in
  List.iter (fun (e : enum_decl) -> Hashtbl.replace enum_tbl e.e_name ()) h.enums;
  let flags_tbl = Hashtbl.create 16 in
  List.iter (fun (f : flags_decl) -> Hashtbl.replace flags_tbl f.f_name ()) h.flags;
  let struct_tbl = Hashtbl.create 128 in
  List.iter (fun (s : struct_decl) -> Hashtbl.replace struct_tbl s.s_name ()) h.structs;
  let cb_tbl = Hashtbl.create 32 in
  List.iter (fun (c : callback_decl) -> Hashtbl.replace cb_tbl c.cb_name ()) h.callbacks;
  let alias_tbl = Hashtbl.create 16 in
  List.iter (fun (n, b) -> Hashtbl.replace alias_tbl n b) h.aliases;
  let rec res t =
    match t with
    | Ptr t -> Ptr (res t)
    | Anon_union (n, fields) ->
        Anon_union (n, List.map (fun f -> { f with fld_type = res f.fld_type }) fields)
    | Unresolved n ->
        if Hashtbl.mem handle_tbl n then Handle n
        else if Hashtbl.mem enum_tbl n then Enum n
        else if Hashtbl.mem flags_tbl n then Flags n
        else if Hashtbl.mem struct_tbl n then Struct n
        else if Hashtbl.mem cb_tbl n then Callback n
        else if Hashtbl.mem alias_tbl n then Alias n
        else fail "unknown type name %S" n
    | t -> t
  in
  let res_sig s =
    { p_params = List.map (fun (n, t) -> (n, res t)) s.p_params; p_ret = res s.p_ret }
  in
  {
    h with
    structs =
      List.map
        (fun s ->
          { s with s_fields = List.map (fun f -> { f with fld_type = res f.fld_type }) s.s_fields })
        h.structs;
    callbacks = List.map (fun c -> { c with cb_sig = res_sig c.cb_sig }) h.callbacks;
    functions = List.map (fun f -> { f with fn_sig = res_sig f.fn_sig }) h.functions;
  }

let read_file path =
  let ic = open_in_bin path in
  let n = in_channel_length ic in
  let s = really_input_string ic n in
  close_in ic;
  s

(** [parse files] parses the given headers in order.  Declaration order from
    the headers is preserved, which is what makes the generator's output
    deterministic. *)
let parse files =
  let acc =
    { a_handles = []; a_enums = []; a_flags = []; a_structs = []; a_callbacks = [];
      a_functions = []; a_aliases = []; a_constants = []; a_inits = []; a_flag_values = [] }
  in
  List.iter (fun path -> parse_file acc ~file:(Filename.basename path) ~src:(read_file path)) files;
  let flags =
    List.rev_map
      (fun f ->
        match List.assoc_opt f.f_name acc.a_flag_values with
        | Some vs -> { f with f_values = vs }
        | None -> fail "flags typedef %s has no constants" f.f_name)
      acc.a_flags
  in
  (* Every "static const" block must belong to a WGPUFlags typedef. *)
  List.iter
    (fun (tyname, _) ->
      if not (List.exists (fun f -> f.f_name = tyname) flags) then
        fail "static const constants for unknown flags type %S" tyname)
    acc.a_flag_values;
  resolve
    {
      handles = List.rev acc.a_handles;
      enums = List.rev acc.a_enums;
      flags;
      structs = List.rev acc.a_structs;
      callbacks = List.rev acc.a_callbacks;
      functions = List.rev acc.a_functions;
      aliases = List.rev acc.a_aliases;
      constants = List.rev acc.a_constants;
      inits = List.rev acc.a_inits;
    }
