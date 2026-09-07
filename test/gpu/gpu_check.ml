(* Shared helpers for the tests that need a real adapter.  Kept separate from
   test/unit/check.ml so that the unit tests never link anything that touches
   libwgpu_native. *)

let failures = ref 0
let checks = ref 0

let fail fmt = Printf.ksprintf (fun s -> incr failures; prerr_endline ("FAIL: " ^ s)) fmt

let is_true name b =
  incr checks;
  if not b then fail "%s" name

let equal_int name ~expected ~got =
  incr checks;
  if expected <> got then fail "%s: expected %d, got %d" name expected got

let equal_string name ~expected ~got =
  incr checks;
  if expected <> got then fail "%s: expected %S, got %S" name expected got

let equal_int_list name ~expected ~got =
  incr checks;
  if expected <> got then
    fail "%s: expected [%s], got [%s]" name
      (String.concat "; " (List.map string_of_int expected))
      (String.concat "; " (List.map string_of_int got))

let raises name f =
  incr checks;
  match f () with
  | () -> fail "%s: expected an exception" name; Not_found
  | exception e -> e

let finish name =
  if !failures > 0 then begin
    Printf.eprintf "%s: %d/%d checks failed\n" name !failures !checks;
    exit 1
  end;
  Printf.printf "ok: %s (%d checks)\n" name !checks

(* Every GPU test starts the same way. *)
let setup ?(label = "test") () =
  Wgpu.Log.to_stderr ~level:Wgpu.Types.LogLevel.error ();
  let instance = Wgpu.Instance.create () in
  let adapter = Wgpu.Instance.request_adapter instance in
  let device = Wgpu.Adapter.request_device ~label adapter in
  let queue = Wgpu.Device.queue device in
  (instance, adapter, device, queue)

let teardown (instance, adapter, device, queue) =
  Wgpu.Queue.release queue;
  Wgpu.Device.release device;
  Wgpu.Adapter.release adapter;
  Wgpu.Instance.release instance

let bytes_of_u32 l =
  let b = Bytes.create (4 * List.length l) in
  List.iteri (fun i v -> Bytes.set_int32_le b (4 * i) (Int32.of_int v)) l;
  b

let u32_of_bytes b =
  List.init (Bytes.length b / 4) (fun i -> Int32.to_int (Bytes.get_int32_le b (4 * i)))
