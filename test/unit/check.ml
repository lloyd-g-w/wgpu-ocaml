(* Minimal assertion helpers shared by the unit tests.  A failing check prints
   what it expected and exits non-zero; the last line of a successful run is
   "ok: <name> (<n> checks)". *)

let failures = ref 0
let checks = ref 0

let fail fmt = Printf.ksprintf (fun s -> incr failures; prerr_endline ("FAIL: " ^ s)) fmt

let is_true name b =
  incr checks;
  if not b then fail "%s" name

let equal_string name ~expected ~got =
  incr checks;
  if expected <> got then fail "%s: expected %S, got %S" name expected got

let equal_int name ~expected ~got =
  incr checks;
  if expected <> got then fail "%s: expected %d, got %d" name expected got

let equal_string_set name ~expected ~got =
  incr checks;
  let module S = Set.Make (String) in
  let e = S.of_list expected and g = S.of_list got in
  let missing = S.diff e g and extra = S.diff g e in
  if not (S.is_empty missing && S.is_empty extra) then
    fail "%s: %d missing (%s), %d unexpected (%s)" name (S.cardinal missing)
      (String.concat ", " (S.elements missing))
      (S.cardinal extra)
      (String.concat ", " (S.elements extra))

(* Runs [f], which must raise; returns the exception (or [Not_found] after
   recording a failure, so that the caller can keep checking). *)
let raises name f =
  incr checks;
  match f () with
  | () ->
      fail "%s: expected an exception" name;
      Not_found
  | exception e -> e

let finish name =
  if !failures > 0 then begin
    Printf.eprintf "%s: %d/%d checks failed\n" name !failures !checks;
    exit 1
  end;
  Printf.printf "ok: %s (%d checks)\n" name !checks
