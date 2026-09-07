(* The loader's rejection paths, exercised against tiny C shared libraries
   instead of a second wgpu-native build.

   The loader caches its handle process-wide, so each scenario runs in its own
   process: the scenario name comes from the command line and the dune rules
   below run one process per scenario. *)

let failures = ref 0
let checks = ref 0
let fail fmt = Printf.ksprintf (fun s -> incr failures; prerr_endline ("FAIL: " ^ s)) fmt

let is_true name b =
  incr checks;
  if not b then fail "%s" name

let equal_string name ~expected ~got =
  incr checks;
  if expected <> got then fail "%s: expected %S, got %S" name expected got

let contains haystack needle =
  let n = String.length haystack and m = String.length needle in
  let rec go i = i + m <= n && (String.sub haystack i m = needle || go (i + 1)) in
  go 0

let dtor_log = "dtor.log"

let unloaded () =
  Sys.file_exists dtor_log
  &&
  let ic = open_in dtor_log in
  Fun.protect
    ~finally:(fun () -> close_in ic)
    (fun () -> String.trim (really_input_string ic (in_channel_length ic))) <> ""

let setup lib =
  (try Sys.remove dtor_log with _ -> ());
  Unix.putenv "WGPU_OCAML_TEST_DTOR_LOG" (Filename.concat (Sys.getcwd ()) dtor_log);
  Unix.putenv "WGPU_NATIVE_LIB" (Filename.concat (Sys.getcwd ()) lib)

let () =
  let scenario = if Array.length Sys.argv > 1 then Sys.argv.(1) else "" in
  (match scenario with
  | "wrong-version" ->
      setup "fake_wrong_version.so";
      let e =
        try
          ignore (Wgpu.Loader.runtime_version ());
          None
        with e -> Some e
      in
      (match e with
      | Some (Wgpu.Loader.Version_mismatch msg) ->
          is_true "the message names the version found" (contains msg "1.2.3.4");
          is_true "the message names the pinned version" (contains msg Wgpu.Pin.version);
          is_true "the message says how to override"
            (contains msg "WGPU_OCAML_ALLOW_VERSION_MISMATCH")
      | Some e -> fail "expected Version_mismatch, got %s" (Printexc.to_string e)
      | None -> fail "a library reporting 1.2.3.4 was accepted");
      is_true "no library is left loaded" (Wgpu.Loader.loaded_path () = None);
      is_true "the rejected handle was closed" (unloaded ())
  | "wrong-version-allowed" ->
      setup "fake_wrong_version.so";
      Unix.putenv "WGPU_OCAML_ALLOW_VERSION_MISMATCH" "1";
      equal_string "the override loads the library anyway" ~expected:"1.2.3.4"
        ~got:(Wgpu.Loader.runtime_version ());
      is_true "the library is recorded as loaded" (Wgpu.Loader.loaded_path () <> None)
  | "not-wgpu" ->
      setup "fake_not_wgpu.so";
      let e =
        try
          ignore (Wgpu.Loader.runtime_version ());
          None
        with e -> Some e
      in
      (match e with
      | Some (Wgpu.Loader.Not_found_ msg) ->
          is_true "the diagnostic says it is not a wgpu-native library"
            (contains msg "does not export wgpuGetVersion");
          is_true "the diagnostic still lists what was tried" (contains msg "$WGPU_NATIVE_LIB");
          is_true "the diagnostic still suggests the fetch script"
            (contains msg "fetch_wgpu_native")
      | Some e -> fail "expected Not_found_, got %s" (Printexc.to_string e)
      | None -> fail "a library without wgpuGetVersion was accepted");
      is_true "no library is left loaded" (Wgpu.Loader.loaded_path () = None);
      is_true "the rejected handle was closed" (unloaded ())
  | s -> fail "unknown scenario %S" s);
  if !failures > 0 then begin
    Printf.eprintf "loader %s: %d/%d checks failed\n" scenario !failures !checks;
    exit 1
  end;
  Printf.printf "ok: loader %s (%d checks)\n" scenario !checks
