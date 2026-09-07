(* [build_site.exe --out DIR] deletes DIR before rebuilding it.  These tests
   pin down what it is allowed to delete: only a directory it created itself
   (marked with .wgpu-ocaml-site), never through a symbolic link, and never a
   directory that contains the sources it is about to read. *)

let exe = "../../doc/site/build_site.exe"
let root = "../.."

let failures = ref 0
let checks = ref 0
let fail fmt = Printf.ksprintf (fun s -> incr failures; prerr_endline ("FAIL: " ^ s)) fmt

let contains haystack needle =
  let n = String.length haystack and m = String.length needle in
  let rec go i = i + m <= n && (String.sub haystack i m = needle || go (i + 1)) in
  go 0

let read path =
  let ic = open_in_bin path in
  Fun.protect
    ~finally:(fun () -> close_in ic)
    (fun () -> really_input_string ic (in_channel_length ic))

let write path contents =
  let oc = open_out_bin path in
  output_string oc contents;
  close_out oc

(* Runs the site generator; returns (exit code, combined output). *)
let build ?(root = root) out =
  let log = Filename.temp_file "wgpu-site" ".log" in
  let code =
    Sys.command
      (Printf.sprintf "%s --root %s --out %s --no-api > %s 2>&1" (Filename.quote exe)
         (Filename.quote root) (Filename.quote out) (Filename.quote log))
  in
  let text = read log in
  Sys.remove log;
  (code, text)

let rec rm_rf path =
  match Unix.lstat path with
  | { Unix.st_kind = Unix.S_DIR; _ } ->
      Array.iter (fun e -> rm_rf (Filename.concat path e)) (Sys.readdir path);
      Unix.rmdir path
  | _ -> Unix.unlink path
  | exception Unix.Unix_error _ -> ()

let sandbox = "sandbox"

let fresh name =
  let p = Filename.concat sandbox name in
  rm_rf p;
  Unix.mkdir p 0o755;
  p

let check_refused ~what ~code ~text ~expect =
  incr checks;
  if code = 0 then fail "%s: build_site accepted it (exit 0)" what
  else if not (contains text expect) then
    fail "%s: expected the message to mention %S, got:\n%s" what expect text

let () =
  rm_rf sandbox;
  Unix.mkdir sandbox 0o755;

  (* 1. A successful build, twice: the second run adopts the marker it wrote. *)
  let out = Filename.concat sandbox "site" in
  let code, text = build out in
  incr checks;
  if code <> 0 then fail "first build failed:\n%s" text;
  incr checks;
  if not (Sys.file_exists (Filename.concat out ".wgpu-ocaml-site")) then
    fail "the owner marker was not written";
  let code, text = build out in
  incr checks;
  if code <> 0 then fail "rebuilding an owned directory failed:\n%s" text;
  incr checks;
  if not (Sys.file_exists (Filename.concat out "index.html")) then
    fail "the rebuilt site is missing index.html";

  (* 2a. An --out that contains the inputs must be refused: this is the
         `--out .` from the repository root that would have erased the working
         tree. *)
  let code, text = build root in
  check_refused ~what:"--out <root>" ~code ~text ~expect:"it contains the input";
  incr checks;
  if not (Sys.file_exists (Filename.concat root "README.md")) then
    fail "--out <root> destroyed the sources";

  (* 2b. --out . : a non-empty directory this program did not create.  The
         sentinel is written here rather than assuming a source file is present,
         so the check works under `dune --sandbox copy` too. *)
  let own_sentinel = "own_sentinel.txt" in
  write own_sentinel "the test's own working directory";
  let code, text = build "." in
  check_refused ~what:"--out ." ~code ~text ~expect:"has no .wgpu-ocaml-site";
  incr checks;
  if not (Sys.file_exists own_sentinel) then
    fail "--out . destroyed the test's own directory";
  Sys.remove own_sentinel;

  (* 3. An unrelated, non-empty directory must be refused untouched. *)
  let unrelated = fresh "unrelated" in
  write (Filename.concat unrelated "precious.txt") "keep me";
  let code, text = build unrelated in
  check_refused ~what:"unrelated non-empty directory" ~code ~text ~expect:"has no .wgpu-ocaml-site";
  incr checks;
  if not (Sys.file_exists (Filename.concat unrelated "precious.txt")) then
    fail "an unrelated directory was erased";

  (* 4. A symlink pointing at an unrelated directory must be refused, and the
        target must not be touched. *)
  let target = fresh "symlink_target" in
  write (Filename.concat target "sentinel.txt") "keep me too";
  let link = Filename.concat sandbox "link_to_target" in
  rm_rf link;
  Unix.symlink (Filename.concat (Sys.getcwd ()) target) link;
  let code, text = build link in
  check_refused ~what:"--out through a symlink" ~code ~text ~expect:"symbolic link";
  incr checks;
  if not (Sys.file_exists (Filename.concat target "sentinel.txt")) then
    fail "the symlink target was erased";

  (* 5. A symlink *inside* an owned output directory must be unlinked, not
        followed: the directory it points at keeps its contents. *)
  let inner_target = fresh "inner_target" in
  write (Filename.concat inner_target "inner.txt") "still here";
  let inner_link = Filename.concat out "escape" in
  rm_rf inner_link;
  Unix.symlink (Filename.concat (Sys.getcwd ()) inner_target) inner_link;
  let code, text = build out in
  incr checks;
  if code <> 0 then fail "rebuilding an owned directory containing a symlink failed:\n%s" text;
  incr checks;
  if Sys.file_exists (Filename.concat inner_target "inner.txt") then () else fail "the symlink was followed while clearing the output directory: %s was deleted"
      (Filename.concat inner_target "inner.txt");
  incr checks;
  if Sys.file_exists inner_link then fail "the symlink itself was not removed";

  rm_rf sandbox;
  if !failures > 0 then begin
    Printf.eprintf "site output safety: %d/%d checks failed\n" !failures !checks;
    exit 1
  end;
  Printf.printf "ok: site output safety (%d checks)\n" !checks
