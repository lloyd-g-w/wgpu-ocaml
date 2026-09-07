(* The generator's "abort rather than guess" rules, exercised on small
   synthetic headers.

   Each fixture in this directory isolates one rule.  Three must make the
   generator fail with a specific message; one must make it *succeed* and emit a
   sentinel it would previously have skipped. *)

let gen = "../../gen/gen.exe"
let pin = "../../vendor/wgpu-native/pin.txt"

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

(* Runs the generator on one fixture; returns (exit code, stdout, stderr). *)
let run_gen header =
  let out = Filename.temp_file "wgpu-gen-out" ".ml" in
  let err = Filename.temp_file "wgpu-gen-err" ".txt" in
  let code =
    Sys.command
      (Printf.sprintf "%s types %s %s > %s 2> %s" (Filename.quote gen) (Filename.quote pin)
         (Filename.quote header) (Filename.quote out) (Filename.quote err))
  in
  let r = (code, read out, read err) in
  Sys.remove out;
  Sys.remove err;
  r

let expect_failure ~header ~message =
  incr checks;
  let code, _, err = run_gen header in
  if code = 0 then fail "%s: the generator accepted it (exit 0)" header
  else if not (contains err message) then
    fail "%s: expected the error to mention %S, got:\n%s" header message err

let expect_success ~header ~emits =
  incr checks;
  let code, out, err = run_gen header in
  if code <> 0 then fail "%s: the generator failed (exit %d):\n%s" header code err
  else if not (contains out emits) then fail "%s: expected the output to define %S" header emits

let () =
  (* Bit sets are OCaml ints: bit 62 and bit 63 are both out of range. *)
  expect_failure ~header:"flags_bit63.h" ~message:"does not fit in an OCaml int";
  expect_failure ~header:"flags_bit62.h" ~message:"does not fit in an OCaml int";
  (* A constant that would shadow a member the module defines itself. *)
  expect_failure ~header:"reserved_name.h"
    ~message:"collides with a member the module defines itself";
  (* An unknown macro in the WGPU_ namespace must stop the generator even when
     it is indented after the hash. *)
  expect_failure ~header:"unknown_define.h" ~message:"unsupported #define value";
  (* ... and a *known* indented sentinel must be picked up, not dropped. *)
  expect_success ~header:"indented_define.h" ~emits:"test_sentinel";
  if !failures > 0 then begin
    Printf.eprintf "generator guards: %d/%d checks failed\n" !failures !checks;
    exit 1
  end;
  Printf.printf "ok: generator guards (%d checks)\n" !checks
