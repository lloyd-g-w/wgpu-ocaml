(* Regression tests for the callback boundary against a real device:

   - an exception raised inside a callback never unwinds into wgpu-native's
     frames, and is recorded on the OCaml side instead of being swallowed;
   - a buffer mapping that does not complete is cancelled rather than leaving a
     token registered for a callback that may still fire;
   - a mapping wgpu rejects reports its status through the callback and its
     validation error through the uncaptured-error callback, and leaks
     nothing. *)

module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils
module Check = Gpu_check

let () =
  let ((_, _, device, queue) as ctx) = Check.setup ~label:"callback-safety" () in
  let size = 16 in
  let src =
    Check.create_buffer device ~label:"src" ~size
      ~usage:T.BufferUsage.(combine [ copy_dst; copy_src ])
  in
  let staging =
    Check.create_buffer device ~label:"staging" ~size
      ~usage:T.BufferUsage.(combine [ map_read; copy_dst ])
  in
  Check.write_buffer queue src (Check.bytes_of_u32 [ 11; 22; 33; 44 ]);
  let encoder_desc = T.CommandEncoderDescriptor.init () in
  let encoder = F.wgpuDeviceCreateCommandEncoder device (Ctypes.addr encoder_desc) in
  F.wgpuCommandEncoderCopyBufferToBuffer encoder src (Check.u64 0) staging (Check.u64 0)
    (Check.u64 size);
  let commands_desc = T.CommandBufferDescriptor.init () in
  let commands = F.wgpuCommandEncoderFinish encoder (Ctypes.addr commands_desc) in
  Check.submit queue commands;
  Check.is_true "no pending callback failures at the start"
    (Wgpu.Callback.pending_failures () = 0);

  (* 1. A raising callback: wgpu-native must see a normal return, and the
        exception must be recorded rather than unwound into Rust. *)
  let raising =
    Wgpu.Callback.permanent T.BufferMapCallback.fn (fun _status _msg _u1 _u2 ->
        Wgpu.Callback.protect ~where:"test raising map callback" (fun () ->
            failwith "deliberate failure in a map callback"))
  in
  let info = T.BufferMapCallbackInfo.init () in
  Ctypes.setf info T.BufferMapCallbackInfo.mode T.CallbackMode.allow_process_events;
  Ctypes.setf info T.BufferMapCallbackInfo.callback raising;
  let (_ : T.Future.t) =
    F.wgpuBufferMapAsync staging T.MapMode.read (Check.sz 0) (Check.sz size) info
  in
  Check.is_true "the poll that ran the raising callback returned normally" (Check.poll device);
  (match Wgpu.Callback.take_failures () with
  | [] -> Check.is_true "the callback failure was recorded" false
  | l ->
      let msg = String.concat " | " (List.map Wgpu.Callback.string_of_failure l) in
      Check.is_true "the recorded failure names the failure"
        (Check.contains msg "deliberate failure in a map callback");
      Check.is_true "the recorded failure names the callback"
        (Check.contains msg "test raising map callback"));
  Check.is_true "failures are cleared once collected" (Wgpu.Callback.pending_failures () = 0);
  (* The map itself succeeded, so put the buffer back in a clean state. *)
  F.wgpuBufferUnmap staging;
  Check.is_true "the device is still usable" (Check.poll device);
  ignore (Check.take_errors ());

  (* 2. A mapping that is not waited for long enough must be cancelled, not
        abandoned: no token may be left registered, and the buffer must stay
        usable. *)
  let before_live = Wgpu.Callback.Userdata.live_count () in
  let before_abandoned = Wgpu.Callback.Userdata.abandoned_count () in
  (match U.Buffer.map_read_sync ~max_polls:0 device staging ~offset:0 ~size with
  | Ok () -> Check.is_true "a mapping with no polls must not report success" false
  | Error (status, message) ->
      Check.is_true "the cancelled mapping is reported as aborted"
        (status = T.MapAsyncStatus.aborted);
      Check.is_true "the message says the mapping did not complete"
        (Check.contains message "did not complete"));
  Check.equal_int "no token is leaked by the cancelled mapping" ~expected:before_live
    ~got:(Wgpu.Callback.Userdata.live_count ());
  Check.equal_int "no token had to be abandoned" ~expected:before_abandoned
    ~got:(Wgpu.Callback.Userdata.abandoned_count ());

  (* ... and the buffer still reads correctly afterwards. *)
  (match U.Buffer.read_bytes device staging ~offset:0 ~size with
  | Ok b ->
      Check.equal_int_list "the buffer is usable after the cancelled mapping"
        ~expected:[ 11; 22; 33; 44 ] ~got:(Check.u32_of_bytes b)
  | Error (s, m) ->
      Check.is_true
        (Printf.sprintf "read after the cancelled mapping: %s (%s)"
           (T.MapAsyncStatus.to_string s) m)
        false);
  Check.equal_int "read_bytes leaves no live tokens" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());
  ignore (Check.take_errors ());

  (* 3. A mapping wgpu rejects outright: wgpu-core guarantees the callback
        still runs ("op.callback is guaranteed to be called",
        [Global::buffer_map_async]) *and* wgpu-native reports the rejection
        through the uncaptured-error callback.  Both must be observable, and
        the token must not leak. *)
  let no_map =
    Check.create_buffer device ~label:"no-map-read" ~size
      ~usage:T.BufferUsage.(combine [ copy_dst; copy_src ])
  in
  (match U.Buffer.map_read_sync device no_map ~offset:0 ~size with
  | Ok () -> Check.is_true "mapping a buffer without MapRead must fail" false
  | Error (status, message) ->
      Check.is_true "the rejection is reported through the map callback"
        (status <> T.MapAsyncStatus.success);
      print_endline
        (Printf.sprintf "rejected mapping: %s (%s)" (T.MapAsyncStatus.to_string status)
           (String.sub message 0 (min 120 (String.length message)))));
  (match Check.take_errors () with
  | [] -> Check.is_true "the rejection is also reported to the device" false
  | l ->
      let msg = Check.string_of_errors l in
      Check.is_true "the device error mentions the usage"
        (Check.contains msg "Validation" || Check.contains msg "usage"
       || Check.contains msg "Usage"));
  Check.equal_int "a rejected mapping leaks no token" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());
  Check.equal_int "a rejected mapping abandons no token" ~expected:before_abandoned
    ~got:(Wgpu.Callback.Userdata.abandoned_count ());
  Check.is_true "no callback raised on the rejection path"
    (Wgpu.Callback.pending_failures () = 0);
  F.wgpuBufferRelease no_map;

  (* The device is clean again: a valid buffer reports nothing. *)
  let fine =
    Check.create_buffer device ~label:"fine" ~size:64
      ~usage:T.BufferUsage.(combine [ map_read; copy_dst ])
  in
  Check.equal_int "the device is clean after the rejected mapping" ~expected:0
    ~got:(List.length (Check.take_errors ()));
  F.wgpuBufferRelease fine;

  F.wgpuCommandBufferRelease commands;
  F.wgpuCommandEncoderRelease encoder;
  F.wgpuBufferRelease staging;
  F.wgpuBufferRelease src;
  Check.teardown ctx;
  Check.finish "callback safety"
