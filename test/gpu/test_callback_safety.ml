(* Regression tests for the callback boundary against a real device:

   - an exception raised inside a callback never unwinds into wgpu-native's
     frames, and is delivered on the OCaml side instead of being swallowed;
   - a buffer mapping that does not complete is cancelled rather than leaving a
     token registered for a callback that may still fire;
   - an error scope reports the caller's exception, not its own. *)

exception Caller_exception

let contains haystack needle =
  let n = String.length haystack and m = String.length needle in
  let rec go i = i + m <= n && (String.sub haystack i m = needle || go (i + 1)) in
  go 0

let () =
  let ((_, _, device, queue) as ctx) = Gpu_check.setup ~label:"callback-safety" () in
  let size = 16 in
  let src =
    Wgpu.Device.create_buffer device ~label:"src" ~size
      ~usage:Wgpu.Types.BufferUsage.(combine [ copy_dst; copy_src ])
  in
  let staging =
    Wgpu.Device.create_buffer device ~label:"staging" ~size
      ~usage:Wgpu.Types.BufferUsage.(combine [ map_read; copy_dst ])
  in
  Wgpu.Queue.write_buffer queue src (Gpu_check.bytes_of_u32 [ 11; 22; 33; 44 ]);
  let encoder = Wgpu.Device.create_command_encoder device in
  Wgpu.Command_encoder.copy_buffer_to_buffer encoder ~src ~src_offset:0 ~dst:staging ~dst_offset:0
    ~size;
  let commands = Wgpu.Command_encoder.finish encoder in
  Wgpu.Queue.submit queue [ commands ];
  Gpu_check.is_true "no pending callback failures at the start"
    (Wgpu.Callback.pending_failures () = 0);

  (* 1. A raising callback: wgpu-native must see a normal return, and the OCaml
        side must learn about it at the next checkpoint. *)
  let raising =
    Wgpu.Callback.permanent Wgpu.Types.BufferMapCallback.fn (fun _status _msg _u1 _u2 ->
        Wgpu.Callback.protect ~where:"test raising map callback" (fun () ->
            failwith "deliberate failure in a map callback"))
  in
  let info = Wgpu.Types.BufferMapCallbackInfo.init () in
  Ctypes.setf info Wgpu.Types.BufferMapCallbackInfo.mode
    Wgpu.Types.CallbackMode.allow_process_events;
  Ctypes.setf info Wgpu.Types.BufferMapCallbackInfo.callback raising;
  let (_ : Wgpu.Types.Future.t) =
    Wgpu.Fn.wgpuBufferMapAsync staging Wgpu.Types.MapMode.read (Unsigned.Size_t.of_int 0)
      (Unsigned.Size_t.of_int size) info
  in
  let e = Gpu_check.raises "the callback failure is delivered" (fun () ->
      ignore (Wgpu.Device.poll device))
  in
  (match e with
  | Wgpu.Error msg ->
      Gpu_check.is_true "the delivered message names the failure"
        (contains msg "deliberate failure in a map callback");
      Gpu_check.is_true "the delivered message names the callback"
        (contains msg "test raising map callback")
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);
  Gpu_check.is_true "failures are cleared once delivered"
    (Wgpu.Callback.pending_failures () = 0);
  (* The map itself succeeded, so put the buffer back in a clean state. *)
  Wgpu.Buffer.unmap staging;
  Gpu_check.is_true "the device is still usable" (Wgpu.Device.poll device);

  (* 2. A mapping that is not waited for long enough must be cancelled, not
        abandoned: no token may be left registered, and the buffer must stay
        usable. *)
  let before_live = Wgpu.Callback.Userdata.live_count () in
  let before_abandoned = Wgpu.Callback.Userdata.abandoned_count () in
  let e =
    Gpu_check.raises "a mapping that does not complete raises" (fun () ->
        Wgpu.Buffer.map_read_sync ~max_polls:0 ~device staging ~offset:0 ~size)
  in
  (match e with
  | Wgpu.Error msg ->
      Gpu_check.is_true "the message says the mapping did not complete"
        (contains msg "did not complete")
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);
  Gpu_check.equal_int "no token is leaked by the failed mapping" ~expected:before_live
    ~got:(Wgpu.Callback.Userdata.live_count ());
  Gpu_check.equal_int "no token had to be abandoned" ~expected:before_abandoned
    ~got:(Wgpu.Callback.Userdata.abandoned_count ());

  (* ... and the buffer still reads correctly afterwards. *)
  let got = Gpu_check.u32_of_bytes (Wgpu.Buffer.read_sync ~device staging ~offset:0 ~size) in
  Gpu_check.equal_int_list "the buffer is usable after the cancelled mapping"
    ~expected:[ 11; 22; 33; 44 ] ~got;
  Gpu_check.equal_int "read_sync leaves no live tokens" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());

  (* 2c. A mapping wgpu rejects outright: wgpu-core guarantees the callback
         still runs ("op.callback is guaranteed to be called",
         `Global::buffer_map_async`) *and* wgpu-native reports the rejection to
         the device error sink.  Both describe this call, so the device must be
         clean afterwards - a stale sink entry would fire under some later,
         unrelated operation. *)
  let no_map =
    Wgpu.Device.create_buffer device ~label:"no-map-read" ~size
      ~usage:Wgpu.Types.BufferUsage.(combine [ copy_dst; copy_src ])
  in
  let e =
    Gpu_check.raises "mapping a buffer without MapRead raises" (fun () ->
        Wgpu.Buffer.map_read_sync ~device no_map ~offset:0 ~size)
  in
  (match e with
  | Wgpu.Error msg ->
      Gpu_check.is_true "the message names the failing entry point"
        (contains msg "wgpuBufferMapAsync");
      (* The sink entry is reported with this call rather than left behind. *)
      Gpu_check.is_true "the message carries the validation error too"
        (contains msg "Validation" || contains msg "usage" || contains msg "Usage");
      print_endline ("rejected mapping: " ^ String.sub msg 0 (min 160 (String.length msg)))
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);
  Gpu_check.is_true "the device is clean after a rejected mapping"
    (match Wgpu.Device.check device with () -> true | exception _ -> false);
  Gpu_check.equal_int "a rejected mapping leaks no token" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());
  Wgpu.Buffer.release no_map;

  (* 2d. A failure recorded *before* a constructor must stop it before it
         allocates: the pre-flight check reports the pending failure, the native
         call never runs (so it records no validation error of its own), and no
         handle is created to be leaked. *)
  Wgpu.Callback.protect ~where:"test pre-existing callback failure" (fun () ->
      failwith "recorded before the constructor ran");
  let e =
    Gpu_check.raises "a pending callback failure stops the constructor" (fun () ->
        ignore
          (Wgpu.Device.create_buffer device ~label:"never-created" ~size:64
             ~usage:Wgpu.Types.BufferUsage.(combine [ map_read; map_write ])))
  in
  (match e with
  | Wgpu.Error msg ->
      Gpu_check.is_true "the pending failure is what is reported"
        (contains msg "recorded before the constructor ran");
      Gpu_check.is_true "the constructor's own validation error is absent"
        (not (contains msg "Validation"))
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);
  (* If the invalid create had run, its validation error would be waiting here. *)
  Gpu_check.is_true "the device is clean, so the native call never ran"
    (match Wgpu.Device.check device with () -> true | exception _ -> false);

  (* 2e. A failure recorded *during* a constructor must release the handle that
         constructor produced - exactly once, with the entry point that matches
         its type. *)
  let created = ref Wgpu.Types.Buffer.null in
  let released = ref [] in
  let desc = Wgpu.Types.BufferDescriptor.init () in
  Ctypes.setf desc Wgpu.Types.BufferDescriptor.usage
    Wgpu.Types.BufferUsage.(combine [ copy_dst; copy_src ]);
  Ctypes.setf desc Wgpu.Types.BufferDescriptor.size (Unsigned.UInt64.of_int 64);
  let e =
    Gpu_check.raises "a callback failure during the call is reported" (fun () ->
        ignore
          (Wgpu.Device.checked device "wgpuDeviceCreateBuffer"
             ~release:(fun h ->
               released := h :: !released;
               Wgpu.Fn.wgpuBufferRelease h)
             (fun () ->
               let b = Wgpu.Fn.wgpuDeviceCreateBuffer device (Ctypes.addr desc) in
               created := b;
               (* Exactly how a real callback records a failure. *)
               Wgpu.Callback.protect ~where:"test callback during create" (fun () ->
                   failwith "raised while the native call was running");
               b)))
  in
  (match e with
  | Wgpu.Error msg ->
      Gpu_check.is_true "the failure raised during the call is reported"
        (contains msg "raised while the native call was running")
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);
  Gpu_check.is_true "the constructor really produced a native handle"
    (not (Wgpu.Types.Buffer.is_null !created));
  Gpu_check.equal_int "the handle is released exactly once" ~expected:1
    ~got:(List.length !released);
  Gpu_check.is_true "the handle released is the one the call returned"
    (List.for_all
       (fun h ->
         Ctypes.raw_address_of_ptr (Ctypes.to_voidp h)
         = Ctypes.raw_address_of_ptr (Ctypes.to_voidp !created))
       !released);
  Gpu_check.is_true "the device is clean after the released handle"
    (match Wgpu.Device.check device with () -> true | exception _ -> false);

  (* 2f. A callback that fails *while a mapping is in flight* must not leave the
         buffer mapped: the caller gets an exception and no handle on the
         mapping, so nothing else could ever unmap it.  A log handler that
         raises once is a faithful stand-in for any callback failing during the
         call (wgpu-native's log sink is global and fires from inside these
         calls).  Which of the two guards runs - the cancellation path when the
         wait itself raises, or the post-map unwind when the completion check
         does - depends on when the record lands; the buffer must end up
         unmapped either way. *)
  let armed = ref true in
  Wgpu.Log.set ~level:Wgpu.Types.LogLevel.trace (fun _ _ ->
      if !armed then begin
        armed := false;
        failwith "raised from the log callback during a mapping"
      end);
  let e =
    Gpu_check.raises "a callback failure during a successful mapping is reported" (fun () ->
        Fun.protect
          ~finally:(fun () -> Wgpu.Log.to_stderr ~level:Wgpu.Types.LogLevel.error ())
          (fun () -> Wgpu.Buffer.map_read_sync ~device staging ~offset:0 ~size))
  in
  (match e with
  | Wgpu.Error msg ->
      Gpu_check.is_true "the log-callback failure is what is reported"
        (contains msg "raised from the log callback during a mapping")
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);
  Gpu_check.is_true "the log handler fired exactly once" (not !armed);
  (* Proof that the buffer is not left mapped: unmapping again must now be the
     thing that complains.  wgpu-core answers `NotMapped` for an idle buffer
     (`resource.rs`, `unmap_inner`) and wgpu-native routes that to the error
     sink, so the device is *not* clean here - whereas a buffer left mapped
     would have accepted this unmap silently. *)
  Wgpu.Buffer.unmap staging;
  Gpu_check.is_true "the buffer had already been unmapped by the failure path"
    (match Wgpu.Device.check device with () -> false | exception _ -> true);
  let got = Gpu_check.u32_of_bytes (Wgpu.Buffer.read_sync ~device staging ~offset:0 ~size) in
  Gpu_check.equal_int_list "and it can still be read afterwards" ~expected:[ 11; 22; 33; 44 ]
    ~got;

  (* 3. An error scope must not replace the caller's exception with its own. *)
  let e =
    Gpu_check.raises "with_error_scope propagates the caller's exception" (fun () ->
        Wgpu.Device.with_error_scope device (fun () -> raise Caller_exception))
  in
  Gpu_check.is_true "the caller's exception survives the scope" (e == Caller_exception);

  (* ... while a scope that captures a validation error still reports it. *)
  let e =
    Gpu_check.raises "with_error_scope reports a captured error" (fun () ->
        Wgpu.Device.with_error_scope device (fun () ->
            let b =
              Wgpu.Device.create_buffer device ~label:"bad" ~size:64
                ~usage:Wgpu.Types.BufferUsage.(combine [ map_read; map_write ])
            in
            Wgpu.Buffer.release b))
  in
  (match e with
  | Wgpu.Error _ -> Gpu_check.is_true "captured validation error" true
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);

  Wgpu.Command_buffer.release commands;
  Wgpu.Command_encoder.release encoder;
  Wgpu.Buffer.release staging;
  Wgpu.Buffer.release src;
  Gpu_check.teardown ctx;
  Gpu_check.finish "callback safety"
