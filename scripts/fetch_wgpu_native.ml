(* Downloads and installs the pinned wgpu-native release.

   The pin (version, asset names, SHA-256 checksums) comes from
   [vendor/wgpu-native/pin.txt] through the generated {!Wgpu.Pin} module, so
   this script cannot drift from the bindings.  [curl] and [unzip] are invoked
   as external tools; everything else is OCaml.

   Usage:
     dune exec scripts/fetch_wgpu_native.exe [-- --platform linux-x86_64] [--force]

   Installs into $WGPU_OCAML_CACHE_DIR (or $XDG_CACHE_HOME/wgpu-ocaml, or
   ~/.cache/wgpu-ocaml), which is exactly where {!Wgpu.Loader} looks. *)

module Pin = Wgpu.Pin

let detect_platform () =
  let uname flag =
    let ic = Unix.open_process_in ("uname " ^ flag) in
    let s = try String.trim (input_line ic) with End_of_file -> "" in
    ignore (Unix.close_process_in ic);
    s
  in
  let os = String.lowercase_ascii (uname "-s") in
  let arch = String.lowercase_ascii (uname "-m") in
  let arch = match arch with "arm64" -> "aarch64" | "amd64" -> "x86_64" | a -> a in
  let os =
    match os with
    | "linux" -> "linux"
    | "darwin" -> "macos"
    | s when String.length s >= 6 && String.sub s 0 6 = "mingw6" -> "windows"
    | s -> s
  in
  os ^ "-" ^ arch

let run fmt =
  Printf.ksprintf
    (fun cmd ->
      prerr_endline ("+ " ^ cmd);
      match Sys.command cmd with 0 -> () | n -> failwith (Printf.sprintf "%S failed with %d" cmd n))
    fmt

let sha256 = Wgpu_scripts.Sha256.digest_file

let rec mkdir_p dir =
  if not (Sys.file_exists dir) then begin
    mkdir_p (Filename.dirname dir);
    try Unix.mkdir dir 0o755 with Unix.Unix_error (Unix.EEXIST, _, _) -> ()
  end

let cache_root () =
  let getenv n = match Sys.getenv_opt n with Some "" | None -> None | v -> v in
  match getenv "WGPU_OCAML_CACHE_DIR" with
  | Some d -> d
  | None -> (
      match getenv "XDG_CACHE_HOME" with
      | Some d -> Filename.concat d "wgpu-ocaml"
      | None -> (
          match getenv "HOME" with
          | Some h -> Filename.concat (Filename.concat h ".cache") "wgpu-ocaml"
          | None -> Filename.concat (Filename.get_temp_dir_name ()) "wgpu-ocaml"))

let () =
  let platform = ref None and force = ref false in
  let args = List.tl (Array.to_list Sys.argv) in
  let rec parse = function
    | [] -> ()
    | "--platform" :: p :: rest -> platform := Some p; parse rest
    | "--force" :: rest -> force := true; parse rest
    | "--help" :: _ ->
        print_endline
          "usage: fetch_wgpu_native.exe [--platform <plat>] [--force]\n\nplatforms:";
        List.iter (fun (p, a, _, _) -> Printf.printf "  %-16s %s\n" p a) Pin.archives;
        exit 0
    | a :: _ -> failwith ("unexpected argument " ^ a)
  in
  parse args;
  let platform = match !platform with Some p -> p | None -> detect_platform () in
  let _, asset, expected_sha, lib_in_archive =
    match List.find_opt (fun (p, _, _, _) -> p = platform) Pin.archives with
    | Some a -> a
    | None ->
        failwith
          (Printf.sprintf "no pinned archive for platform %S (known: %s)" platform
             (String.concat ", " (List.map (fun (p, _, _, _) -> p) Pin.archives)))
  in
  let root = Filename.concat (cache_root ()) ("wgpu-native-" ^ Pin.version) in
  let lib_name = Filename.basename lib_in_archive in
  let installed = Filename.concat (Filename.concat root "lib") lib_name in
  if Sys.file_exists installed && not !force then begin
    Printf.printf "already installed: %s\n" installed;
    Printf.printf "(use --force to re-download)\n"
  end
  else begin
    mkdir_p root;
    let archive = Filename.concat root asset in
    if not (Sys.file_exists archive) || !force then
      run "curl --fail --location --silent --show-error --output %s %s" (Filename.quote archive)
        (Filename.quote (Pin.release_url_prefix ^ asset));
    let got = sha256 archive in
    if got <> expected_sha then begin
      Printf.eprintf
        "checksum mismatch for %s\n  expected %s\n  got      %s\nThe pin in vendor/wgpu-native/pin.txt does not match the downloaded file; refusing to install.\n"
        asset expected_sha got;
      (try Sys.remove archive with _ -> ());
      exit 1
    end;
    Printf.printf "sha256 ok: %s\n" got;
    run "unzip -o -q %s -d %s" (Filename.quote archive) (Filename.quote root);
    if not (Sys.file_exists installed) then
      failwith (Printf.sprintf "%s not found in %s" lib_in_archive asset);
    Printf.printf "installed %s\n" installed
  end;
  Printf.printf "\nwgpu-ocaml will find it automatically; to be explicit:\n";
  Printf.printf "  export WGPU_NATIVE_LIB=%s\n" installed
