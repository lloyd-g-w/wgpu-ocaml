(* Callbacks arriving on a thread the OCaml runtime has never seen.

   DESIGN.md §5 claims these bindings support that (because wgpu-native's log
   sink is process-global and webgpu.h documents the uncaptured-error callback
   as callable from any thread).  This test proves the mechanism rather than
   asserting it: a C fixture spawns a real pthread and calls back into OCaml
   through exactly the same {!Wgpu.Callback.permanent} closures the ergonomic
   layer installs, including a struct passed by value.

   It needs a C compiler but no GPU and no libwgpu_native. *)

open Ctypes

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

let contains haystack needle =
  let n = String.length haystack and m = String.length needle in
  let rec go i = i + m <= n && (String.sub haystack i m = needle || go (i + 1)) in
  go 0

let lib =
  Dl.dlopen
    ~filename:(Filename.concat (Sys.getcwd ()) "libforeign_thread_probe.so")
    ~flags:[ Dl.RTLD_NOW; Dl.RTLD_LOCAL ]

(* Bound exactly like the generated entry points: the domain lock is released
   for the duration of the call, which is what lets the spawned thread acquire
   it from the callback. *)
let foreign name fn = Foreign.foreign ~from:lib ~release_runtime_lock:true name fn

let plain_cb_fn = uint32_t @-> ptr void @-> returning void
let sv_cb_fn = Wgpu.Types.StringView.t @-> ptr void @-> returning void

let call_from_new_thread =
  foreign "probe_call_from_new_thread"
    (static_funptr plain_cb_fn @-> uint32_t @-> ptr void @-> returning void)

let call_with_struct =
  foreign "probe_call_with_struct"
    (static_funptr sv_cb_fn @-> string @-> ptr void @-> returning void)

let sleep_ms = foreign "probe_sleep_ms" (uint32_t @-> returning void)

let () =
  (* 1. Plain callbacks from a foreign thread, allocating and collecting. *)
  let seen = ref 0 and sizes_ok = ref true in
  let cb =
    Wgpu.Callback.permanent plain_cb_fn (fun i _ ->
        Wgpu.Callback.protect ~where:"probe plain callback" (fun () ->
            let l = List.init 32 (fun k -> string_of_int (k + Unsigned.UInt32.to_int i)) in
            Gc.full_major ();
            if List.length l <> 32 then sizes_ok := false;
            incr seen))
  in
  call_from_new_thread cb (Unsigned.UInt32.of_int 200) null;
  equal_int "callbacks from a foreign thread" ~expected:200 ~got:!seen;
  is_true "OCaml allocation and Gc.full_major inside a foreign-thread callback" !sizes_ok;
  is_true "no callback failures were recorded" (Wgpu.Callback.pending_failures () = 0);

  (* 2. A struct passed by value, like every real wgpu callback. *)
  let got = ref "" in
  let sv_cb =
    Wgpu.Callback.permanent sv_cb_fn (fun sv _ ->
        Wgpu.Callback.protect ~where:"probe struct callback" (fun () ->
            got := Wgpu.string_of_view sv))
  in
  call_with_struct sv_cb "hello from a foreign thread" null;
  equal_string "struct-by-value argument on a foreign thread"
    ~expected:"hello from a foreign thread" ~got:!got;

  (* 3. An exception inside a callback is recorded, never unwound into C. *)
  let raising =
    Wgpu.Callback.permanent plain_cb_fn (fun _ _ ->
        Wgpu.Callback.protect ~where:"probe raising callback" (fun () ->
            failwith "deliberate failure inside a callback"))
  in
  call_from_new_thread raising (Unsigned.UInt32.of_int 3) null;
  let recorded = Wgpu.Callback.take_failures () in
  equal_int "failures recorded" ~expected:3 ~got:(List.length recorded);
  is_true "the failure keeps the message"
    (List.for_all
       (fun f -> contains (Wgpu.Callback.string_of_failure f) "deliberate failure")
       recorded);
  is_true "the failure records where it happened"
    (List.for_all
       (fun f -> contains (Wgpu.Callback.string_of_failure f) "probe raising callback")
       recorded);
  is_true "failures are cleared once taken" (Wgpu.Callback.pending_failures () = 0);

  (* 4. No deadlock: a foreign thread calls back while an OCaml thread is
        running OCaml code, and while another OCaml thread sits inside a native
        call with the domain lock released. *)
  let spinner_done = ref false in
  let spinner =
    Thread.create
      (fun () ->
        let x = ref 0 in
        for i = 1 to 20_000_000 do
          x := (!x + i) land 0xffff
        done;
        spinner_done := !x >= 0)
      ()
  in
  let sleeper = Thread.create (fun () -> sleep_ms (Unsigned.UInt32.of_int 50)) () in
  let concurrent = ref 0 in
  let cb2 =
    Wgpu.Callback.permanent plain_cb_fn (fun _ _ ->
        Wgpu.Callback.protect ~where:"probe concurrent callback" (fun () -> incr concurrent))
  in
  call_from_new_thread cb2 (Unsigned.UInt32.of_int 1000) null;
  Thread.join spinner;
  Thread.join sleeper;
  equal_int "callbacks while OCaml threads run" ~expected:1000 ~got:!concurrent;
  is_true "the busy OCaml thread finished" !spinner_done;

  (* 5. The closures survive compaction, as the permanent contract promises. *)
  Gc.compact ();
  let after = ref 0 in
  let cb3 =
    Wgpu.Callback.permanent plain_cb_fn (fun _ _ ->
        Wgpu.Callback.protect ~where:"probe post-compaction callback" (fun () -> incr after))
  in
  call_from_new_thread cb (Unsigned.UInt32.of_int 1) null;
  call_from_new_thread cb3 (Unsigned.UInt32.of_int 1) null;
  equal_int "a closure created before Gc.compact still runs" ~expected:201 ~got:!seen;
  equal_int "a closure created after Gc.compact runs" ~expected:1 ~got:!after;
  is_true "the closures are rooted" (Wgpu.Callback.retained_count () >= 8);
  is_true "no stray failures" (Wgpu.Callback.pending_failures () = 0);

  if !failures > 0 then begin
    Printf.eprintf "foreign-thread callbacks: %d/%d checks failed\n" !failures !checks;
    exit 1
  end;
  Printf.printf "ok: foreign-thread callbacks (%d checks)\n" !checks
