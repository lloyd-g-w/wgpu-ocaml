(** [wgpu.utils] — the few helpers a wgpu-native program cannot avoid writing.

    The [wgpu] library is raw bindings only. This separate library holds the
    small set of helpers that (a) nearly every program has to write anyway and
    (b) the other wgpu-native bindings ship too (WebGPU-C++, wgpu_native_zig,
    wgpu-odin, Silk.NET). Nothing else belongs here: no descriptor builders, no
    error sink, no logging wrapper, no arena. Every function below carries the
    one line that justifies its presence.

    Failures are [result] values, never exceptions. Handles are the raw
    {!Wgpu.Types} handles, so anything here mixes freely with {!Wgpu.Fn}. *)

open Wgpu.Types
module F = Wgpu.Fn
module C = Wgpu.Callback

let sz = Unsigned.Size_t.of_int

(** Converting [WGPUStringView] both ways: every program reads one (adapter
    info, every callback message) and writes one (labels, entry points), and
    every peer binding ships the pair. *)
module String_view = struct
  (** The OCaml string a [WGPUStringView] denotes. A [NULL] view is [""], and a
      view whose length is [WGPU_STRLEN] is NUL-terminated. *)
  let to_string (sv : StringView.t) =
    let data = Ctypes.getf sv StringView.data in
    let length = Ctypes.getf sv StringView.length in
    if Ctypes.is_null data then ""
    else if length = Constants.strlen then
      Ctypes.coerce (Ctypes.ptr Ctypes.char) Ctypes.string data
    else Ctypes.string_from_ptr data ~length:(Unsigned.Size_t.to_int length)

  type keepalive = char Ctypes.CArray.t
  (** Owns the bytes a view built by {!of_string} points at. *)

  (** [of_string s] returns a view of a copy of [s] and the value that owns
      that copy. {b The caller must keep the second component reachable} until
      the foreign call that reads the view has returned — the view is a bare
      pointer, and the GC frees the copy as soon as the [keepalive] dies. End
      the call site with [ignore (Sys.opaque_identity keepalive)]. *)
  let of_string s : StringView.t * keepalive =
    let arr = Ctypes.CArray.of_string s in
    let sv = StringView.init () in
    Ctypes.setf sv StringView.data (Ctypes.CArray.start arr);
    Ctypes.setf sv StringView.length (sz (String.length s));
    (sv, arr)
end

(** The two start-up requests. wgpu-native answers both {e inside} the call
    (its futures are stubs returning [NULL_FUTURE]), but the handle still comes
    back through a C callback and a [userdata] pointer, so every program has to
    write this trampoline before it can do anything at all. *)
module Sync = struct
  let adapter_trampoline =
    lazy
      (C.permanent RequestAdapterCallback.fn (fun status adapter message u1 _u2 ->
           C.protect ~where:"wgpuInstanceRequestAdapter callback" (fun () ->
               let cell : (RequestAdapterStatus.t * Adapter.t * string) option ref =
                 C.Userdata.lookup u1
               in
               cell := Some (status, adapter, String_view.to_string message))))

  (** [request_adapter ?options instance] runs [wgpuInstanceRequestAdapter] and
      returns what its callback was handed. [options] defaults to [NULL]. *)
  let request_adapter ?options (instance : Instance.t) =
    let opts =
      match options with
      | Some o -> Ctypes.addr o
      | None -> Ctypes.from_voidp RequestAdapterOptions.t Ctypes.null
    in
    let cell = ref None in
    let token = C.Userdata.register cell in
    let info = RequestAdapterCallbackInfo.init () in
    Ctypes.setf info RequestAdapterCallbackInfo.mode CallbackMode.allow_process_events;
    Ctypes.setf info RequestAdapterCallbackInfo.callback (Lazy.force adapter_trampoline);
    Ctypes.setf info RequestAdapterCallbackInfo.userdata1 (C.Userdata.pointer token);
    (* Synchronous, so once the call has returned - normally or not - the
       callback can no longer fire and the token is safe to free. *)
    Fun.protect
      ~finally:(fun () -> C.Userdata.release token)
      (fun () ->
        let (_ : Future.t) = F.wgpuInstanceRequestAdapter instance opts info in
        ignore (Sys.opaque_identity options));
    match !cell with
    | Some (status, adapter, _) when status = RequestAdapterStatus.success
                                     && not (Adapter.is_null adapter) -> Ok adapter
    | Some (status, _, message) -> Error (status, message)
    | None ->
        Error (RequestAdapterStatus.error, "wgpuInstanceRequestAdapter did not call its callback")

  let device_trampoline =
    lazy
      (C.permanent RequestDeviceCallback.fn (fun status device message u1 _u2 ->
           C.protect ~where:"wgpuAdapterRequestDevice callback" (fun () ->
               let cell : (RequestDeviceStatus.t * Device.t * string) option ref =
                 C.Userdata.lookup u1
               in
               cell := Some (status, device, String_view.to_string message))))

  (** [request_device ?descriptor adapter] runs [wgpuAdapterRequestDevice].
      [descriptor] defaults to [NULL]; pass one to name the device or to
      install an uncaptured-error callback. *)
  let request_device ?descriptor (adapter : Adapter.t) =
    let desc =
      match descriptor with
      | Some d -> Ctypes.addr d
      | None -> Ctypes.from_voidp DeviceDescriptor.t Ctypes.null
    in
    let cell = ref None in
    let token = C.Userdata.register cell in
    let info = RequestDeviceCallbackInfo.init () in
    Ctypes.setf info RequestDeviceCallbackInfo.mode CallbackMode.allow_process_events;
    Ctypes.setf info RequestDeviceCallbackInfo.callback (Lazy.force device_trampoline);
    Ctypes.setf info RequestDeviceCallbackInfo.userdata1 (C.Userdata.pointer token);
    (* Synchronous like the adapter request: safe to free on every exit path. *)
    Fun.protect
      ~finally:(fun () -> C.Userdata.release token)
      (fun () ->
        let (_ : Future.t) = F.wgpuAdapterRequestDevice adapter desc info in
        ignore (Sys.opaque_identity descriptor));
    match !cell with
    | Some (status, device, _) when status = RequestDeviceStatus.success
                                    && not (Device.is_null device) -> Ok device
    | Some (status, _, message) -> Error (status, message)
    | None ->
        Error (RequestDeviceStatus.error, "wgpuAdapterRequestDevice did not call its callback")
end

(** Reading a buffer back. This is the one genuinely asynchronous operation
    every headless program performs, it only settles from [wgpuDevicePoll], and
    getting the callback's lifetime right on the failure path is subtle — which
    is why every peer binding ships a blocking map helper. *)
module Buffer = struct
  let map_trampoline =
    lazy
      (C.permanent BufferMapCallback.fn (fun status message u1 _u2 ->
           C.protect ~where:"wgpuBufferMapAsync callback" (fun () ->
               let cell : (MapAsyncStatus.t * string) option ref = C.Userdata.lookup u1 in
               cell := Some (status, String_view.to_string message))))

  let poll device =
    try
      ignore
        (F.wgpuDevicePoll device (Unsigned.UInt32.of_int 1)
           (Ctypes.from_voidp Ctypes.uint64_t Ctypes.null)
          : Unsigned.UInt32.t)
    with _ -> ()

  (** [map_read_sync device buffer ~offset ~size] maps [size] bytes for reading
      and blocks in [wgpuDevicePoll ~wait:true] — at most [max_polls] times —
      until the callback fires. On [Ok ()] the buffer is left mapped; unmap it
      with [Wgpu.Fn.wgpuBufferUnmap].

      The callback is genuinely deferred, so a token whose callback may still
      fire is never freed. When the polls run out the mapping is {e cancelled}
      instead: [wgpuBufferUnmap] on a buffer whose map is pending makes
      wgpu-core deliver the callback immediately with [MapAborted] (wgpu-core
      29.0.3, [resource.rs], [Buffer::unmap] / [unmap_inner]), a bounded drain
      of eight polls follows, and only then is the token abandoned — leaking a
      few words rather than risking a use-after-free. *)
  let map_read_sync ?(max_polls = 64) device buffer ~offset ~size =
    let cell = ref None in
    let token = C.Userdata.register cell in
    let info = BufferMapCallbackInfo.init () in
    Ctypes.setf info BufferMapCallbackInfo.mode CallbackMode.allow_process_events;
    Ctypes.setf info BufferMapCallbackInfo.callback (Lazy.force map_trampoline);
    Ctypes.setf info BufferMapCallbackInfo.userdata1 (C.Userdata.pointer token);
    let (_ : Future.t) = F.wgpuBufferMapAsync buffer MapMode.read (sz offset) (sz size) info in
    let rec pump n = if !cell = None && n > 0 then (poll device; pump (n - 1)) in
    pump max_polls;
    match !cell with
    | Some (status, message) ->
        C.Userdata.release token;
        if status = MapAsyncStatus.success then Ok () else Error (status, message)
    | None ->
        (try F.wgpuBufferUnmap buffer with _ -> ());
        pump 8;
        if !cell = None then C.Userdata.abandon token else C.Userdata.release token;
        Error
          ( MapAsyncStatus.aborted,
            Printf.sprintf "the buffer mapping did not complete after %d polls" max_polls )

  (** [read_bytes device buffer ~offset ~size] maps, copies and unmaps, so a
      failed read leaves the buffer usable. *)
  let read_bytes device buffer ~offset ~size =
    match map_read_sync device buffer ~offset ~size with
    | Error _ as e -> e
    | Ok () ->
        let p = F.wgpuBufferGetConstMappedRange buffer (sz offset) (sz size) in
        let r =
          if Ctypes.is_null p then
            Error (MapAsyncStatus.error, "wgpuBufferGetConstMappedRange returned NULL")
          else
            Ok
              (Bytes.of_string
                 (Ctypes.string_from_ptr (Ctypes.from_voidp Ctypes.char p) ~length:size))
        in
        F.wgpuBufferUnmap buffer;
        r
end
