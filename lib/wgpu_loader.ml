(* Dynamic loading of libwgpu_native.

   The bindings deliberately contain no C stubs: the shared library is opened
   with [Dl.dlopen] on first use and every entry point is resolved lazily with
   [Foreign.foreign].  That keeps the build free of C headers and of a
   compile-time dependency on wgpu-native. *)

exception Not_found_ of string
(** Raised when the shared library cannot be located or opened.  The payload is
    a multi-line diagnostic listing everything that was tried. *)

exception Version_mismatch of string
(** Raised when the loaded library reports a version other than the pinned
    {!Wgpu.Pin.version}.  Set [WGPU_OCAML_ALLOW_VERSION_MISMATCH=1] to downgrade
    this to a warning on stderr. *)

exception Not_wgpu_native of string
(** Internal to the version check: a shared library opened successfully but does
    not export [wgpuGetVersion], so it is not a wgpu-native build at all.

    {!open_library} catches this, closes the handle and folds the message into
    the {!Not_found_} diagnostic as the reason that candidate failed, so it is
    not what callers of the loader observe; it is only visible if you call
    {!check_version} or {!version_of} on a handle yourself. *)

(** Shared library file names to try, in order, for this platform. *)
let default_file_names =
  match Sys.os_type with
  | "Win32" | "Cygwin" -> [ "wgpu_native.dll" ]
  | _ -> [ "libwgpu_native.so"; "libwgpu_native.dylib" ]

let default_file_name = List.hd default_file_names

let getenv name = match Sys.getenv_opt name with Some "" -> None | v -> v

let cache_root () =
  match getenv "WGPU_OCAML_CACHE_DIR" with
  | Some d -> d
  | None -> (
      match getenv "XDG_CACHE_HOME" with
      | Some d -> Filename.concat d "wgpu-ocaml"
      | None -> (
          match getenv "HOME" with
          | Some h -> Filename.concat (Filename.concat h ".cache") "wgpu-ocaml"
          | None -> Filename.concat (Filename.get_temp_dir_name ()) "wgpu-ocaml"))

(** Directory [scripts/fetch_wgpu_native.ml] installs the pinned release into. *)
let cache_lib_dir () =
  Filename.concat (Filename.concat (cache_root ()) ("wgpu-native-" ^ Wgpu_pin.version)) "lib"

type candidate = { description : string; path : string; must_exist : bool }

(* [WGPU_NATIVE_LIB] and [WGPU_NATIVE_LIB_DIR] are authoritative: when one is
   set and does not work, loading fails instead of silently picking up some
   other copy of the library. *)
let candidates () =
  let l = ref [] in
  let add description path must_exist = l := { description; path; must_exist } :: !l in
  match getenv "WGPU_NATIVE_LIB" with
  | Some p -> [ { description = "$WGPU_NATIVE_LIB"; path = p; must_exist = true } ]
  | None -> (
      match getenv "WGPU_NATIVE_LIB_DIR" with
      | Some d ->
          List.map
            (fun f ->
              { description = "$WGPU_NATIVE_LIB_DIR"; path = Filename.concat d f; must_exist = true })
            default_file_names
      | None ->
          List.iter
            (fun f -> add "fetch cache" (Filename.concat (cache_lib_dir ()) f) true)
            default_file_names;
          List.iter (fun f -> add "system search path" f false) default_file_names;
          List.rev !l)

let opened : (Dl.library * string) option ref = ref None

let diagnostic tried =
  let lines =
    List.map (fun (c, why) -> Printf.sprintf "  - %s: %s (%s)" c.description c.path why) tried
  in
  String.concat "\n"
    ([ Printf.sprintf
         "wgpu-ocaml could not load the wgpu-native shared library (%s, pinned release %s)."
         default_file_name Wgpu_pin.tag;
       "Tried, in order:" ]
    @ lines
    @ [ "";
        "Install the pinned release with:";
        "  dune exec scripts/fetch_wgpu_native.exe";
        "or point the bindings at an existing build:";
        "  export WGPU_NATIVE_LIB=/path/to/" ^ default_file_name;
        "  export WGPU_NATIVE_LIB_DIR=/path/to/lib" ])

(* Resolving [wgpuGetVersion] is also how we recognise a wgpu-native library at
   all: a same-named shared object that lacks it is reported as such instead of
   escaping as a bare [Dl.DL_error]. *)
let version_of lib path =
  let get_version =
    match Foreign.foreign ~from:lib "wgpuGetVersion" Ctypes.(void @-> returning uint32_t) with
    | f -> f
    | exception Dl.DL_error msg ->
        raise
          (Not_wgpu_native
             (Printf.sprintf
                "%s loaded but does not export wgpuGetVersion, so it is not a wgpu-native \
                 library (%s)."
                path msg))
  in
  Unsigned.UInt32.to_int32 (get_version ())

let check_version lib path =
  let found = version_of lib path in
  if found <> Wgpu_pin.version_u32 then begin
    let msg =
      Printf.sprintf
        "%s reports wgpu-native %s (0x%08lx) but these bindings are generated for %s (0x%08lx)."
        path
        (Wgpu_pin.string_of_version_u32 found)
        found Wgpu_pin.version Wgpu_pin.version_u32
    in
    match getenv "WGPU_OCAML_ALLOW_VERSION_MISMATCH" with
    | Some ("1" | "true" | "yes") -> prerr_endline ("wgpu-ocaml: warning: " ^ msg)
    | _ ->
        raise
          (Version_mismatch
             (msg ^ "\nSet WGPU_OCAML_ALLOW_VERSION_MISMATCH=1 to use it anyway."))
  end

let open_library () =
  match !opened with
  | Some (lib, _) -> lib
  | None ->
      let tried = ref [] in
      let rec go = function
        | [] -> raise (Not_found_ (diagnostic (List.rev !tried)))
        | c :: rest -> (
            if c.must_exist && not (Sys.file_exists c.path) then begin
              tried := (c, "no such file") :: !tried;
              go rest
            end
            else
              match Dl.dlopen ~filename:c.path ~flags:[ Dl.RTLD_NOW; Dl.RTLD_LOCAL ] with
              | lib -> (
                  (* A handle we reject must be closed again: keeping it would
                     leave a rejected library mapped, and its initialisers
                     live, for the rest of the process. *)
                  match check_version lib c.path with
                  | () ->
                      opened := Some (lib, c.path);
                      lib
                  | exception Not_wgpu_native msg ->
                      (try Dl.dlclose ~handle:lib with _ -> ());
                      tried := (c, msg) :: !tried;
                      go rest
                  | exception e ->
                      (try Dl.dlclose ~handle:lib with _ -> ());
                      raise e)
              | exception Dl.DL_error msg ->
                  tried := (c, msg) :: !tried;
                  go rest)
      in
      go (candidates ())

(** Path of the shared library that was loaded, or [None] if it has not been
    opened yet. *)
let loaded_path () = match !opened with Some (_, p) -> Some p | None -> None

(** Version reported by [wgpuGetVersion], loading the library if needed. *)
let runtime_version () =
  let lib = open_library () in
  let path = match !opened with Some (_, p) -> p | None -> "<library>" in
  Wgpu_pin.string_of_version_u32 (version_of lib path)

(** Resolve a symbol.

    The OCaml domain lock is released for the duration of every wgpu call.  That
    is what lets wgpu-native call back into OCaml from a thread the runtime has
    not seen (the log sink is process-global and the uncaptured-error callback
    is documented as "any thread"): the closures created by
    [Wgpu_callback.permanent] acquire the lock and register the thread, which
    can only work if no thread is sitting inside a wgpu call holding it.

    ctypes rejects releasing the lock for a signature that passes OCaml heap
    memory ([ocaml_string]/[ocaml_bytes]); no generated signature does, and the
    binding would raise [Ctypes.Unsupported] here if one ever did. *)
let foreign : type a b. string -> (a -> b) Ctypes.fn -> a -> b =
 fun name fn -> Foreign.foreign ~from:(open_library ()) ~release_runtime_lock:true name fn
