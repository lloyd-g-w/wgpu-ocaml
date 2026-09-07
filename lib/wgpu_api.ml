(* The small ergonomic layer.

   Design rules (see DESIGN.md §4):
   - it adds no state that the raw layer does not have, except the per-device
     error sink needed to turn WebGPU's asynchronous errors into exceptions;
   - lifetimes are explicit: every [create]/[request] has a matching [release],
     and the [with_*] helpers just wrap those in [Fun.protect];
   - it never hides a raw entry point: anything missing here is still reachable
     through {!Wgpu.Fn} using {!Wgpu.Types}. *)

open Wgpu_types
module F = Wgpu_fn

exception Error of string
(** Raised for a failed request, a null handle, or an uncaptured WebGPU error
    reported by the device between two ergonomic calls. *)

let error fmt = Printf.ksprintf (fun s -> raise (Error s)) fmt

(* Exceptions raised inside a wgpu callback cannot cross the C frames that
   invoked it ({!Wgpu_callback.protect} records them instead).  Every ergonomic
   operation that can have driven a callback re-raises them here, so a bug in a
   trampoline surfaces as an OCaml exception rather than disappearing. *)
let check_callback_failures () =
  match Wgpu_callback.take_failures () with
  | [] -> ()
  | l ->
      error "exception raised inside a wgpu callback: %s"
        (String.concat " | " (List.map Wgpu_callback.string_of_failure l))

let u32 = Unsigned.UInt32.of_int
let u32_to_int = Unsigned.UInt32.to_int
let u64 = Unsigned.UInt64.of_int
let u64_to_int = Unsigned.UInt64.to_int
let sz = Unsigned.Size_t.of_int
let sz_to_int = Unsigned.Size_t.to_int
let cbool b = u32 (if b then 1 else 0)

(* ------------------------------------------------------------------ *)
(* Arena: keeps ctypes allocations alive for the duration of a call     *)
(* ------------------------------------------------------------------ *)

(* A C descriptor is a tree of pointers into memory that ctypes owns.  Passing
   only the root to a foreign call is not enough: the OCaml values holding the
   sub-allocations must stay reachable until the call returns, or the GC may
   free memory the callee is still reading.  An arena is that set of roots. *)
module Arena = struct
  type t = { mutable roots : Obj.t list }

  let create () = { roots = [] }
  let keep t (v : 'a) : 'a = t.roots <- Obj.repr v :: t.roots; v

  (** A {!Types.StringView} pointing at a copy of [s] owned by the arena. *)
  let string_view t s =
    let arr = keep t (Ctypes.CArray.of_string s) in
    let sv = keep t (StringView.init ()) in
    Ctypes.setf sv StringView.data (Ctypes.CArray.start arr);
    Ctypes.setf sv StringView.length (sz (String.length s));
    sv

  (** The "no string" view ([NULL], {!Types.Constants.strlen}), which WebGPU
      distinguishes from the empty string. *)
  let no_string () = StringView.init ()

  let opt_string_view t = function None -> no_string () | Some s -> string_view t s

  (** [array t typ l] copies [l] into arena-owned memory and returns
      [(pointer, length)]; the pointer is [null] for an empty list. *)
  let array t typ l =
    match l with
    | [] -> (Ctypes.from_voidp typ Ctypes.null, 0)
    | _ ->
        let arr = keep t (Ctypes.CArray.of_list typ l) in
        (Ctypes.CArray.start arr, List.length l)

  (** Address of an arena-owned copy of the structure [v]. *)
  let addr t (v : 'a Ctypes.structure) = Ctypes.addr (keep t v)

  let null_ptr typ = Ctypes.from_voidp typ Ctypes.null

  (** Call after the foreign call that consumed the arena.  Keeps the roots
      reachable across the call even under aggressive optimisation. *)
  let finish t = ignore (Sys.opaque_identity t.roots)
end

let string_of_view sv =
  let data = Ctypes.getf sv StringView.data in
  let len = sz_to_int (Ctypes.getf sv StringView.length) in
  if Ctypes.is_null data then ""
  else if len = sz_to_int Constants.strlen then
    (* WGPU_STRLEN means "NUL-terminated". *)
    Ctypes.coerce (Ctypes.ptr Ctypes.char) Ctypes.string data
  else Ctypes.string_from_ptr data ~length:len

(* ------------------------------------------------------------------ *)
(* Logging                                                             *)
(* ------------------------------------------------------------------ *)

module Log = struct
  type level = LogLevel.t

  let off = LogLevel.off
  let error = LogLevel.error
  let warn = LogLevel.warn
  let info = LogLevel.info
  let debug = LogLevel.debug
  let trace = LogLevel.trace

  let handler : (level -> string -> unit) ref = ref (fun _ _ -> ())

  (* A single permanent trampoline; wgpu-native keeps the pointer forever.

     [wgpuSetLogCallback] installs a process-global Rust log sink, so this is
     the callback most likely to arrive on a thread the OCaml runtime has never
     seen (any thread inside wgpu, wgpu-hal or naga that emits a record).  It is
     safe because of the threading model documented in {!Wgpu_callback}; keep
     the handler cheap, and do not call back into wgpu from it. *)
  let trampoline =
    lazy
      (Wgpu_callback.permanent LogCallback.fn (fun level message _userdata ->
           Wgpu_callback.protect ~where:"wgpu log callback" (fun () ->
               let h = Wgpu_callback.with_lock (fun () -> !handler) in
               h level (string_of_view message))))

  (** Install [f] as the wgpu-native log sink and set the level.  The callback
      may run on any thread wgpu-native logs from, so keep it cheap and do not
      re-enter the wgpu API from it. *)
  let set ?(level = LogLevel.warn) f =
    Wgpu_callback.with_lock (fun () -> handler := f);
    F.wgpuSetLogCallback (Lazy.force trampoline) Ctypes.null;
    F.wgpuSetLogLevel level

  (** Send wgpu-native logs to [stderr]. *)
  let to_stderr ?(level = LogLevel.warn) () =
    set ~level (fun l m -> Printf.eprintf "[wgpu %s] %s\n%!" (LogLevel.to_string l) m)
end

(* ------------------------------------------------------------------ *)
(* Device error sink                                                   *)
(* ------------------------------------------------------------------ *)

(* WebGPU reports validation failures asynchronously through the device's
   uncaptured-error callback.  In wgpu-native v29 it is invoked synchronously,
   on the thread that made the failing call, so collecting messages here and
   checking them after each ergonomic call turns them into precise exceptions.
   [webgpu.h] nevertheless permits that callback on *any* thread, so this table
   is guarded by the same lock as the rest of the callback state. *)
module Device_errors = struct
  type t = { mutable errors : (ErrorType.t * string) list; mutable lost : string option }

  let table : (nativeint, t) Hashtbl.t = Hashtbl.create 8
  let key (d : Device.t) = Ctypes.raw_address_of_ptr (Ctypes.to_voidp d)

  let create d =
    Wgpu_callback.with_lock (fun () ->
        let s = { errors = []; lost = None } in
        Hashtbl.replace table (key d) s;
        s)

  let find d = Wgpu_callback.with_lock (fun () -> Hashtbl.find_opt table (key d))
  let forget d = Wgpu_callback.with_lock (fun () -> Hashtbl.remove table (key d))

  let record d ty msg =
    Wgpu_callback.with_lock (fun () ->
        match Hashtbl.find_opt table (key d) with
        | Some s -> s.errors <- (ty, msg) :: s.errors
        | None -> ())

  let record_lost d msg =
    Wgpu_callback.with_lock (fun () ->
        match Hashtbl.find_opt table (key d) with Some s -> s.lost <- Some msg | None -> ())

  let take d =
    Wgpu_callback.with_lock (fun () ->
        match Hashtbl.find_opt table (key d) with
        | None -> []
        | Some s ->
            let l = List.rev s.errors in
            s.errors <- [];
            l)
end

(* ------------------------------------------------------------------ *)
(* Instance                                                            *)
(* ------------------------------------------------------------------ *)

let check_handle what h =
  if Ctypes.is_null (Ctypes.to_voidp h) then error "%s returned a null handle" what else h

module Instance = struct
  type t = Instance.t

  (** [create ()] creates an instance.  [backends] and [flags] are the
      wgpu-native [WGPUInstanceExtras] extension; omit them for the defaults. *)
  let create ?backends ?flags () =
    let a = Arena.create () in
    let desc = InstanceDescriptor.init () in
    (match (backends, flags) with
    | None, None -> ()
    | _ ->
        let extras = InstanceExtras.init () in
        let chain = Ctypes.getf extras InstanceExtras.chain in
        Ctypes.setf chain ChainedStruct.sType NativeSType.instance_extras;
        Ctypes.setf extras InstanceExtras.chain chain;
        Option.iter (fun b -> Ctypes.setf extras InstanceExtras.backends b) backends;
        Option.iter (fun f -> Ctypes.setf extras InstanceExtras.flags f) flags;
        let p = Arena.addr a extras in
        Ctypes.setf desc InstanceDescriptor.nextInChain
          (Ctypes.coerce (Ctypes.ptr InstanceExtras.t) (Ctypes.ptr ChainedStruct.t) p));
    let inst = F.wgpuCreateInstance (Arena.addr a desc) in
    Arena.finish a;
    check_handle "wgpuCreateInstance" inst

  let release (t : t) = F.wgpuInstanceRelease t
  let add_ref (t : t) = F.wgpuInstanceAddRef t

  (** Runs pending callbacks (buffer mapping, work-done, ...). *)
  let process_events (t : t) = F.wgpuInstanceProcessEvents t

  let with_instance ?backends ?flags f =
    let t = create ?backends ?flags () in
    Fun.protect ~finally:(fun () -> release t) (fun () -> f t)

  (* One permanent trampoline for adapter requests; the per-call closure is
     reached through the userdata token. *)
  let adapter_trampoline =
    lazy
      (Wgpu_callback.permanent RequestAdapterCallback.fn (fun status adapter message u1 _u2 ->
           Wgpu_callback.protect ~where:"wgpuInstanceRequestAdapter callback" (fun () ->
               let cell : (RequestAdapterStatus.t * Adapter.t * string) option ref =
                 Wgpu_callback.Userdata.lookup u1
               in
               cell := Some (status, adapter, string_of_view message))))

  (** Synchronous adapter request: wgpu-native calls the callback before
      returning, so no event loop is needed. *)
  let request_adapter ?power_preference ?force_fallback_adapter ?backend_type ?compatible_surface
      (t : t) =
    let a = Arena.create () in
    let opts = RequestAdapterOptions.init () in
    Option.iter (fun p -> Ctypes.setf opts RequestAdapterOptions.powerPreference p) power_preference;
    Option.iter
      (fun b -> Ctypes.setf opts RequestAdapterOptions.forceFallbackAdapter (cbool b))
      force_fallback_adapter;
    Option.iter (fun b -> Ctypes.setf opts RequestAdapterOptions.backendType b) backend_type;
    Option.iter (fun s -> Ctypes.setf opts RequestAdapterOptions.compatibleSurface s) compatible_surface;
    let cell = ref None in
    let token = Wgpu_callback.Userdata.register cell in
    let info = RequestAdapterCallbackInfo.init () in
    Ctypes.setf info RequestAdapterCallbackInfo.mode CallbackMode.allow_process_events;
    Ctypes.setf info RequestAdapterCallbackInfo.callback (Lazy.force adapter_trampoline);
    Ctypes.setf info RequestAdapterCallbackInfo.userdata1 (Wgpu_callback.Userdata.pointer token);
    (* wgpu-native runs this callback synchronously, inside the call (its
       futures are stubs that return NULL_FUTURE), so once the call has
       returned - normally or not - the callback can no longer fire and the
       token is safe to free unconditionally. *)
    Fun.protect
      ~finally:(fun () -> Wgpu_callback.Userdata.release token)
      (fun () ->
        let (_ : Future.t) = F.wgpuInstanceRequestAdapter t (Arena.addr a opts) info in
        Arena.finish a);
    check_callback_failures ();
    match !cell with
    | None -> error "wgpuInstanceRequestAdapter did not call its callback"
    | Some (status, adapter, message) ->
        if status <> RequestAdapterStatus.success || Ctypes.is_null (Ctypes.to_voidp adapter) then
          error "no adapter: %s (%s)" (RequestAdapterStatus.to_string status) message
        else adapter

  (** wgpu-native extension: list every adapter the instance can see.
      [backends] defaults to [WGPUInstanceBackend_All], which is zero.  The
      returned adapters are owned by the caller and must be released.

      {b Upstream precondition.} [wgpuInstanceEnumerateAdapters] has no capacity
      argument: called with a NULL array it returns the count, called with an
      array it fills in as many entries as it finds *at that moment*
      ([src/lib.rs] builds [std::slice::from_raw_parts_mut(adapters, count)]
      from the second enumeration's own count).  Each call re-enumerates the
      driver — wgpu-core 29.0.3 [Instance::enumerate_adapters] iterates the
      fixed [instance_per_backend] list and calls [hal::Instance::enumerate_adapters]
      afresh, and the sizing call drops the ids it created — so the count is not
      cached and the caller cannot bound the write. Clamping the returned count
      on this side would not help: the out-of-bounds write, if it ever happened,
      would already have taken place inside the native call. The two-call
      protocol is therefore only sound while the adapter set is stable, which is
      a property of the platform (physical GPU hot-plug), not of these bindings;
      the set of *backends* cannot change, because it is fixed when the instance
      is created. *)
  let enumerate_adapters ?(backends = InstanceBackend.all) (t : t) =
    let opts = InstanceEnumerateAdapterOptions.init () in
    Ctypes.setf opts InstanceEnumerateAdapterOptions.backends backends;
    let a = Arena.create () in
    let popts = Arena.addr a opts in
    let n = sz_to_int (F.wgpuInstanceEnumerateAdapters t popts (Arena.null_ptr Adapter.t)) in
    let arr = Ctypes.CArray.make Adapter.t (max n 1) in
    let n = sz_to_int (F.wgpuInstanceEnumerateAdapters t popts (Ctypes.CArray.start arr)) in
    Arena.finish a;
    List.init n (Ctypes.CArray.get arr)
end

(* ------------------------------------------------------------------ *)
(* Adapter                                                             *)
(* ------------------------------------------------------------------ *)

module Adapter = struct
  type t = Adapter.t

  type info = {
    vendor : string;
    architecture : string;
    device : string;
    description : string;
    backend_type : BackendType.t;
    adapter_type : AdapterType.t;
    vendor_id : int;
    device_id : int;
  }

  let release (t : t) = F.wgpuAdapterRelease t

  let info (t : t) =
    let ai = AdapterInfo.init () in
    let a = Arena.create () in
    let p = Arena.addr a ai in
    let status = F.wgpuAdapterGetInfo t p in
    if status <> Status.success then error "wgpuAdapterGetInfo: %s" (Status.to_string status);
    let g f = string_of_view (Ctypes.getf ai f) in
    let r =
      { vendor = g AdapterInfo.vendor;
        architecture = g AdapterInfo.architecture;
        device = g AdapterInfo.device;
        description = g AdapterInfo.description;
        backend_type = Ctypes.getf ai AdapterInfo.backendType;
        adapter_type = Ctypes.getf ai AdapterInfo.adapterType;
        vendor_id = u32_to_int (Ctypes.getf ai AdapterInfo.vendorID);
        device_id = u32_to_int (Ctypes.getf ai AdapterInfo.deviceID) }
    in
    F.wgpuAdapterInfoFreeMembers ai;
    Arena.finish a;
    r

  let string_of_info i =
    Printf.sprintf "%s (%s, %s, backend %s, type %s, vendor 0x%04x device 0x%04x)" i.device
      i.vendor i.architecture
      (BackendType.to_string i.backend_type)
      (AdapterType.to_string i.adapter_type)
      i.vendor_id i.device_id

  let limits (t : t) =
    let l = Limits.init () in
    let a = Arena.create () in
    let status = F.wgpuAdapterGetLimits t (Arena.addr a l) in
    Arena.finish a;
    if status <> Status.success then error "wgpuAdapterGetLimits: %s" (Status.to_string status);
    l

  let features (t : t) =
    let sf = SupportedFeatures.init () in
    let a = Arena.create () in
    F.wgpuAdapterGetFeatures t (Arena.addr a sf);
    let n = sz_to_int (Ctypes.getf sf SupportedFeatures.featureCount) in
    let p = Ctypes.getf sf SupportedFeatures.features in
    let l = List.init n (fun i -> Ctypes.(!@(p +@ i))) in
    F.wgpuSupportedFeaturesFreeMembers sf;
    Arena.finish a;
    l

  let has_feature (t : t) f = F.wgpuAdapterHasFeature t f <> Unsigned.UInt32.zero

  let device_trampoline =
    lazy
      (Wgpu_callback.permanent RequestDeviceCallback.fn (fun status device message u1 _u2 ->
           Wgpu_callback.protect ~where:"wgpuAdapterRequestDevice callback" (fun () ->
               let cell : (RequestDeviceStatus.t * Device.t * string) option ref =
                 Wgpu_callback.Userdata.lookup u1
               in
               cell := Some (status, device, string_of_view message))))

  let uncaptured_trampoline =
    lazy
      (Wgpu_callback.permanent UncapturedErrorCallback.fn (fun device ty message _u1 _u2 ->
           Wgpu_callback.protect ~where:"uncaptured error callback" (fun () ->
               Device_errors.record Ctypes.(!@device) ty (string_of_view message))))

  let lost_trampoline =
    lazy
      (Wgpu_callback.permanent DeviceLostCallback.fn (fun device reason message _u1 _u2 ->
           Wgpu_callback.protect ~where:"device lost callback" (fun () ->
               Device_errors.record_lost Ctypes.(!@device)
                 (Printf.sprintf "%s: %s"
                    (DeviceLostReason.to_string reason)
                    (string_of_view message)))))

  (** Synchronous device request.  The returned device has an uncaptured-error
      handler installed; see {!Device.check}. *)
  let request_device ?label ?(required_features = []) ?required_limits (t : t) =
    let a = Arena.create () in
    let desc = DeviceDescriptor.init () in
    Ctypes.setf desc DeviceDescriptor.label (Arena.opt_string_view a label);
    let fp, fn_ = Arena.array a FeatureName.t required_features in
    Ctypes.setf desc DeviceDescriptor.requiredFeatureCount (sz fn_);
    Ctypes.setf desc DeviceDescriptor.requiredFeatures fp;
    (match required_limits with
    | None -> ()
    | Some l -> Ctypes.setf desc DeviceDescriptor.requiredLimits (Arena.addr a l));
    let uc = UncapturedErrorCallbackInfo.init () in
    Ctypes.setf uc UncapturedErrorCallbackInfo.callback (Lazy.force uncaptured_trampoline);
    Ctypes.setf desc DeviceDescriptor.uncapturedErrorCallbackInfo uc;
    let dl = DeviceLostCallbackInfo.init () in
    Ctypes.setf dl DeviceLostCallbackInfo.mode CallbackMode.allow_process_events;
    Ctypes.setf dl DeviceLostCallbackInfo.callback (Lazy.force lost_trampoline);
    Ctypes.setf desc DeviceDescriptor.deviceLostCallbackInfo dl;
    let cell = ref None in
    let token = Wgpu_callback.Userdata.register cell in
    let info = RequestDeviceCallbackInfo.init () in
    Ctypes.setf info RequestDeviceCallbackInfo.mode CallbackMode.allow_process_events;
    Ctypes.setf info RequestDeviceCallbackInfo.callback (Lazy.force device_trampoline);
    Ctypes.setf info RequestDeviceCallbackInfo.userdata1 (Wgpu_callback.Userdata.pointer token);
    (* Synchronous like the adapter request above: safe to free the token on
       every exit path. *)
    Fun.protect
      ~finally:(fun () -> Wgpu_callback.Userdata.release token)
      (fun () ->
        let (_ : Future.t) = F.wgpuAdapterRequestDevice t (Arena.addr a desc) info in
        Arena.finish a);
    check_callback_failures ();
    match !cell with
    | None -> error "wgpuAdapterRequestDevice did not call its callback"
    | Some (status, device, message) ->
        if status <> RequestDeviceStatus.success || Ctypes.is_null (Ctypes.to_voidp device) then
          error "no device: %s (%s)" (RequestDeviceStatus.to_string status) message
        else begin
          ignore (Device_errors.create device);
          device
        end
end

(* ------------------------------------------------------------------ *)
(* Device                                                              *)
(* ------------------------------------------------------------------ *)

module Device = struct
  type t = Device.t

  (** Raise if the device reported errors since the last check, or if a wgpu
      callback raised. *)
  let check (t : t) =
    check_callback_failures ();
    match Device_errors.take t with
    | [] -> ()
    | l ->
        error "%s"
          (String.concat "; "
             (List.map (fun (ty, m) -> Printf.sprintf "%s: %s" (ErrorType.to_string ty) m) l))

  let lost (t : t) = match Device_errors.find t with Some s -> s.Device_errors.lost | None -> None

  (* Every constructor goes through this.

     The *pre-flight* check reports anything already pending before the call
     runs: an error that belongs to an earlier operation must not be blamed on
     this one, and - more importantly - must not make us allocate a handle and
     then throw it away.

     The *post-flight* check reports what this call produced.  If it raises, the
     handle [f] returned is about to become unreachable, so it is released
     exactly once with the entry point that matches its type, and the original
     exception (and backtrace) is what propagates. *)
  let checked : type a.
      t ->
      string ->
      release:(a Ctypes.structure Ctypes.ptr -> unit) ->
      (unit -> a Ctypes.structure Ctypes.ptr) ->
      a Ctypes.structure Ctypes.ptr =
   fun t what ~release f ->
    check t;
    let r = f () in
    match check t with
    | () -> check_handle what r
    | exception e ->
        let bt = Printexc.get_raw_backtrace () in
        (* A failure while releasing must never replace the real error. *)
        if not (Ctypes.is_null (Ctypes.to_voidp r)) then (try release r with _ -> ());
        Printexc.raise_with_backtrace e bt

  let release (t : t) = Device_errors.forget t; F.wgpuDeviceRelease t
  let destroy (t : t) = F.wgpuDeviceDestroy t
  let queue (t : t) = check_handle "wgpuDeviceGetQueue" (F.wgpuDeviceGetQueue t)

  let limits (t : t) =
    let l = Limits.init () in
    let a = Arena.create () in
    let status = F.wgpuDeviceGetLimits t (Arena.addr a l) in
    Arena.finish a;
    if status <> Status.success then error "wgpuDeviceGetLimits: %s" (Status.to_string status);
    l

  (** wgpu-native extension: run the device's submission queue.  With
      [~wait:true] it blocks until every submitted command buffer has
      completed, which is how buffer-mapping callbacks are driven. *)
  let poll ?(wait = true) (t : t) =
    let done_ = F.wgpuDevicePoll t (cbool wait) (Arena.null_ptr Ctypes.uint64_t) in
    check t;
    done_ <> Unsigned.UInt32.zero

  let create_buffer ?label ?(mapped_at_creation = false) ~usage ~size (t : t) =
    checked t "wgpuDeviceCreateBuffer" ~release:F.wgpuBufferRelease (fun () ->
        let a = Arena.create () in
        let d = BufferDescriptor.init () in
        Ctypes.setf d BufferDescriptor.label (Arena.opt_string_view a label);
        Ctypes.setf d BufferDescriptor.usage usage;
        Ctypes.setf d BufferDescriptor.size (u64 size);
        Ctypes.setf d BufferDescriptor.mappedAtCreation (cbool mapped_at_creation);
        let b = F.wgpuDeviceCreateBuffer t (Arena.addr a d) in
        Arena.finish a;
        b)

  (** Compile a WGSL shader.  Compilation errors arrive through the device's
      error sink and are raised here. *)
  let create_shader_module_wgsl ?label (t : t) code =
    checked t "wgpuDeviceCreateShaderModule" ~release:F.wgpuShaderModuleRelease (fun () ->
        let a = Arena.create () in
        let src = ShaderSourceWGSL.init () in
        Ctypes.setf src ShaderSourceWGSL.code (Arena.string_view a code);
        let d = ShaderModuleDescriptor.init () in
        Ctypes.setf d ShaderModuleDescriptor.label (Arena.opt_string_view a label);
        Ctypes.setf d ShaderModuleDescriptor.nextInChain
          (Ctypes.coerce (Ctypes.ptr ShaderSourceWGSL.t) (Ctypes.ptr ChainedStruct.t)
             (Arena.addr a src));
        let m = F.wgpuDeviceCreateShaderModule t (Arena.addr a d) in
        Arena.finish a;
        m)

  let create_command_encoder ?label (t : t) =
    checked t "wgpuDeviceCreateCommandEncoder" ~release:F.wgpuCommandEncoderRelease (fun () ->
        let a = Arena.create () in
        let d = CommandEncoderDescriptor.init () in
        Ctypes.setf d CommandEncoderDescriptor.label (Arena.opt_string_view a label);
        let e = F.wgpuDeviceCreateCommandEncoder t (Arena.addr a d) in
        Arena.finish a;
        e)

  let create_compute_pipeline ?label ?layout ?(entry_point = "main") ~shader_module (t : t) =
    checked t "wgpuDeviceCreateComputePipeline" ~release:F.wgpuComputePipelineRelease (fun () ->
        let a = Arena.create () in
        let d = ComputePipelineDescriptor.init () in
        Ctypes.setf d ComputePipelineDescriptor.label (Arena.opt_string_view a label);
        Option.iter (fun l -> Ctypes.setf d ComputePipelineDescriptor.layout l) layout;
        let cs = ComputeState.init () in
        Ctypes.setf cs ComputeState.module_ shader_module;
        Ctypes.setf cs ComputeState.entryPoint (Arena.string_view a entry_point);
        Ctypes.setf d ComputePipelineDescriptor.compute cs;
        let p = F.wgpuDeviceCreateComputePipeline t (Arena.addr a d) in
        Arena.finish a;
        p)

  type binding =
    | Buffer_binding of { binding : int; buffer : Buffer.t; offset : int; size : int }
    | Texture_view_binding of { binding : int; view : TextureView.t }
    | Sampler_binding of { binding : int; sampler : Sampler.t }

  let create_bind_group ?label ~layout ~entries (t : t) =
    checked t "wgpuDeviceCreateBindGroup" ~release:F.wgpuBindGroupRelease (fun () ->
        let a = Arena.create () in
        let mk = function
          | Buffer_binding { binding; buffer; offset; size } ->
              let e = BindGroupEntry.init () in
              Ctypes.setf e BindGroupEntry.binding (u32 binding);
              Ctypes.setf e BindGroupEntry.buffer buffer;
              Ctypes.setf e BindGroupEntry.offset (u64 offset);
              Ctypes.setf e BindGroupEntry.size (u64 size);
              e
          | Texture_view_binding { binding; view } ->
              let e = BindGroupEntry.init () in
              Ctypes.setf e BindGroupEntry.binding (u32 binding);
              Ctypes.setf e BindGroupEntry.textureView view;
              e
          | Sampler_binding { binding; sampler } ->
              let e = BindGroupEntry.init () in
              Ctypes.setf e BindGroupEntry.binding (u32 binding);
              Ctypes.setf e BindGroupEntry.sampler sampler;
              e
        in
        let ptr, n = Arena.array a BindGroupEntry.t (List.map mk entries) in
        let d = BindGroupDescriptor.init () in
        Ctypes.setf d BindGroupDescriptor.label (Arena.opt_string_view a label);
        Ctypes.setf d BindGroupDescriptor.layout layout;
        Ctypes.setf d BindGroupDescriptor.entryCount (sz n);
        Ctypes.setf d BindGroupDescriptor.entries ptr;
        let g = F.wgpuDeviceCreateBindGroup t (Arena.addr a d) in
        Arena.finish a;
        g)

  let create_texture ?label ?(mip_level_count = 1) ?(sample_count = 1)
      ?(dimension = TextureDimension.v2_d) ~usage ~format ~width ~height ?(depth_or_layers = 1)
      (t : t) =
    checked t "wgpuDeviceCreateTexture" ~release:F.wgpuTextureRelease (fun () ->
        let a = Arena.create () in
        let d = TextureDescriptor.init () in
        Ctypes.setf d TextureDescriptor.label (Arena.opt_string_view a label);
        Ctypes.setf d TextureDescriptor.usage usage;
        Ctypes.setf d TextureDescriptor.dimension dimension;
        Ctypes.setf d TextureDescriptor.format format;
        Ctypes.setf d TextureDescriptor.mipLevelCount (u32 mip_level_count);
        Ctypes.setf d TextureDescriptor.sampleCount (u32 sample_count);
        let e = Extent3D.init () in
        Ctypes.setf e Extent3D.width (u32 width);
        Ctypes.setf e Extent3D.height (u32 height);
        Ctypes.setf e Extent3D.depthOrArrayLayers (u32 depth_or_layers);
        Ctypes.setf d TextureDescriptor.size e;
        let tex = F.wgpuDeviceCreateTexture t (Arena.addr a d) in
        Arena.finish a;
        tex)

  type color_target = { format : TextureFormat.t; write_mask : ColorWriteMask.t }

  let create_render_pipeline ?label ?layout ?(vertex_entry_point = "vs_main")
      ?(fragment_entry_point = "fs_main") ?(topology = PrimitiveTopology.triangle_list)
      ?(cull_mode = CullMode.none) ?(front_face = FrontFace.ccw) ?(sample_count = 1)
      ~shader_module ~targets (t : t) =
    checked t "wgpuDeviceCreateRenderPipeline" ~release:F.wgpuRenderPipelineRelease (fun () ->
        let a = Arena.create () in
        let d = RenderPipelineDescriptor.init () in
        Ctypes.setf d RenderPipelineDescriptor.label (Arena.opt_string_view a label);
        Option.iter (fun l -> Ctypes.setf d RenderPipelineDescriptor.layout l) layout;
        let vs = VertexState.init () in
        Ctypes.setf vs VertexState.module_ shader_module;
        Ctypes.setf vs VertexState.entryPoint (Arena.string_view a vertex_entry_point);
        Ctypes.setf d RenderPipelineDescriptor.vertex vs;
        let prim = PrimitiveState.init () in
        Ctypes.setf prim PrimitiveState.topology topology;
        Ctypes.setf prim PrimitiveState.cullMode cull_mode;
        Ctypes.setf prim PrimitiveState.frontFace front_face;
        Ctypes.setf d RenderPipelineDescriptor.primitive prim;
        let ms = MultisampleState.init () in
        Ctypes.setf ms MultisampleState.count (u32 sample_count);
        Ctypes.setf d RenderPipelineDescriptor.multisample ms;
        let mk_target (ct : color_target) =
          let c = ColorTargetState.init () in
          Ctypes.setf c ColorTargetState.format ct.format;
          Ctypes.setf c ColorTargetState.writeMask ct.write_mask;
          c
        in
        let tp, tn = Arena.array a ColorTargetState.t (List.map mk_target targets) in
        let fs = FragmentState.init () in
        Ctypes.setf fs FragmentState.module_ shader_module;
        Ctypes.setf fs FragmentState.entryPoint (Arena.string_view a fragment_entry_point);
        Ctypes.setf fs FragmentState.targetCount (sz tn);
        Ctypes.setf fs FragmentState.targets tp;
        Ctypes.setf d RenderPipelineDescriptor.fragment (Arena.addr a fs);
        let p = F.wgpuDeviceCreateRenderPipeline t (Arena.addr a d) in
        Arena.finish a;
        p)

  (* Error scopes.  wgpu-native calls the pop callback synchronously. *)
  let pop_trampoline =
    lazy
      (Wgpu_callback.permanent PopErrorScopeCallback.fn (fun status ty message u1 _u2 ->
           Wgpu_callback.protect ~where:"wgpuDevicePopErrorScope callback" (fun () ->
               let cell : (PopErrorScopeStatus.t * ErrorType.t * string) option ref =
                 Wgpu_callback.Userdata.lookup u1
               in
               cell := Some (status, ty, string_of_view message))))

  let push_error_scope (t : t) filter = F.wgpuDevicePushErrorScope t filter

  (** Pops the current error scope and returns the captured error, if any. *)
  let pop_error_scope (t : t) =
    let cell = ref None in
    let token = Wgpu_callback.Userdata.register cell in
    let info = PopErrorScopeCallbackInfo.init () in
    Ctypes.setf info PopErrorScopeCallbackInfo.mode CallbackMode.allow_process_events;
    Ctypes.setf info PopErrorScopeCallbackInfo.callback (Lazy.force pop_trampoline);
    Ctypes.setf info PopErrorScopeCallbackInfo.userdata1 (Wgpu_callback.Userdata.pointer token);
    (* Synchronous in wgpu-native: the error sink answers inside the call. *)
    Fun.protect
      ~finally:(fun () -> Wgpu_callback.Userdata.release token)
      (fun () -> ignore (F.wgpuDevicePopErrorScope t info : Future.t));
    check_callback_failures ();
    match !cell with
    | None -> error "wgpuDevicePopErrorScope did not call its callback"
    | Some (status, _, message) when status <> PopErrorScopeStatus.success ->
        error "wgpuDevicePopErrorScope: %s (%s)" (PopErrorScopeStatus.to_string status) message
    | Some (_, ty, message) -> if ty = ErrorType.no_error then None else Some (ty, message)

  (** Runs [f] inside an error scope; raises {!Error} if it captured one.

      If [f] itself raises, that exception wins: the scope is still popped, but
      any failure of the pop is discarded rather than replacing the caller's
      exception (and its backtrace). *)
  let with_error_scope ?(filter = ErrorFilter.validation) (t : t) f =
    push_error_scope t filter;
    let r =
      match f () with
      | r -> r
      | exception e ->
          let bt = Printexc.get_raw_backtrace () in
          (try ignore (pop_error_scope t) with _ -> ());
          Printexc.raise_with_backtrace e bt
    in
    match pop_error_scope t with
    | None -> r
    | Some (ty, message) -> error "%s: %s" (ErrorType.to_string ty) message
end

(* ------------------------------------------------------------------ *)
(* Queue / buffers                                                     *)
(* ------------------------------------------------------------------ *)

module Queue = struct
  type t = Queue.t

  let release (t : t) = F.wgpuQueueRelease t

  (** Copy [data] into [buffer] at [offset]. *)
  let write_buffer ?(offset = 0) (t : t) buffer (data : Bytes.t) =
    let n = Bytes.length data in
    let arr = Ctypes.CArray.of_string (Bytes.unsafe_to_string data) in
    F.wgpuQueueWriteBuffer t buffer (u64 offset)
      (Ctypes.to_voidp (Ctypes.CArray.start arr))
      (sz n);
    ignore (Sys.opaque_identity arr)

  let submit (t : t) (buffers : CommandBuffer.t list) =
    let a = Arena.create () in
    let p, n = Arena.array a CommandBuffer.t buffers in
    F.wgpuQueueSubmit t (sz n) p;
    Arena.finish a
end

module Buffer = struct
  type t = Buffer.t

  let release (t : t) = F.wgpuBufferRelease t
  let destroy (t : t) = F.wgpuBufferDestroy t
  let size (t : t) = u64_to_int (F.wgpuBufferGetSize t)
  let usage (t : t) = F.wgpuBufferGetUsage t
  let unmap (t : t) = F.wgpuBufferUnmap t

  let map_trampoline =
    lazy
      (Wgpu_callback.permanent BufferMapCallback.fn (fun status message u1 _u2 ->
           Wgpu_callback.protect ~where:"wgpuBufferMapAsync callback" (fun () ->
               let cell : (MapAsyncStatus.t * string) option ref =
                 Wgpu_callback.Userdata.lookup u1
               in
               cell := Some (status, string_of_view message))))

  (** Map [size] bytes for reading and block (through [wgpuDevicePoll]) until
      the mapping is ready.  The buffer stays mapped; call {!unmap}.

      Unlike the synchronous requests, this callback is genuinely deferred: it
      fires from [wgpuDevicePoll].  So if the wait fails, the token behind
      [userdata1] must not simply be freed while wgpu-native still holds the
      pointer.  The failure path cancels the mapping instead — unmapping a
      buffer whose map is still pending makes wgpu-core deliver the callback
      immediately with [MapAborted] (wgpu-core 29.0.3, [resource.rs],
      [Buffer::unmap] / [unmap_inner]) — then drains a bounded number of polls,
      and only if the callback still has not fired does it abandon the token
      (leaking a few words rather than risking a use-after-free). *)
  let map_read_sync ?(max_polls = 64) ~device (t : t) ~offset ~size =
    (* Pre-flight, like the device constructors: anything already pending
       belongs to an earlier operation and is reported now, so that whatever the
       sink holds afterwards was produced by this mapping. *)
    Device.check device;
    let cell = ref None in
    let token = Wgpu_callback.Userdata.register cell in
    let info = BufferMapCallbackInfo.init () in
    Ctypes.setf info BufferMapCallbackInfo.mode CallbackMode.allow_process_events;
    Ctypes.setf info BufferMapCallbackInfo.callback (Lazy.force map_trampoline);
    Ctypes.setf info BufferMapCallbackInfo.userdata1 (Wgpu_callback.Userdata.pointer token);
    let raw_poll () =
      try
        ignore
          (F.wgpuDevicePoll device (cbool true) (Arena.null_ptr Ctypes.uint64_t)
            : Unsigned.UInt32.t)
      with _ -> ()
    in
    let settle_after_failure () =
      (try F.wgpuBufferUnmap t with _ -> ());
      let rec drain n = if !cell = None && n > 0 then (raw_poll (); drain (n - 1)) in
      drain 8;
      if !cell = None then Wgpu_callback.Userdata.abandon token
      else Wgpu_callback.Userdata.release token
    in
    let status, message =
      match
        let (_ : Future.t) = F.wgpuBufferMapAsync t MapMode.read (sz offset) (sz size) info in
        let rec pump n =
          match !cell with
          | Some r -> r
          | None ->
              if n = 0 then error "buffer mapping did not complete after %d polls" max_polls
              else begin
                ignore (Device.poll ~wait:true device);
                pump (n - 1)
              end
        in
        pump max_polls
      with
      | r ->
          Wgpu_callback.Userdata.release token;
          r
      | exception e ->
          let bt = Printexc.get_raw_backtrace () in
          settle_after_failure ();
          (* Keep the caller's exception: any callback failure recorded in the
             meantime is appended rather than substituted. *)
          (match Wgpu_callback.take_failures () with
          | [] -> Printexc.raise_with_backtrace e bt
          | l ->
              error "%s; callback failure(s): %s" (Printexc.to_string e)
                (String.concat " | " (List.map Wgpu_callback.string_of_failure l)))
    in
    (* The buffer may be mapped now.  Anything raised from here on would leave
       it mapped with the caller holding no reason to unmap it, so unwind the
       mapping first and let the original exception through. *)
    let mapped = status = MapAsyncStatus.success in
    let unwind e bt =
      if mapped then (try F.wgpuBufferUnmap t with _ -> ());
      Printexc.raise_with_backtrace e bt
    in
    (match check_callback_failures () with
    | () -> ()
    | exception e -> unwind e (Printexc.get_raw_backtrace ()));
    if not mapped then begin
      (* A rejected mapping is reported twice by wgpu-native: through the
         callback (wgpu-core guarantees it runs - "op.callback is guaranteed to
         be called", `Global::buffer_map_async`) and through the device error
         sink.  Both describe *this* call, so they are raised together; leaving
         the sink filled would make it fire under a later, unrelated
         operation. *)
      let sink =
        List.map
          (fun (ty, m) -> Printf.sprintf "%s: %s" (ErrorType.to_string ty) m)
          (Device_errors.take device)
      in
      match sink with
      | [] -> error "wgpuBufferMapAsync: %s (%s)" (MapAsyncStatus.to_string status) message
      | l ->
          error "wgpuBufferMapAsync: %s (%s); %s" (MapAsyncStatus.to_string status) message
            (String.concat "; " l)
    end

  (** Copy of the mapped range; the buffer must be mapped for reading. *)
  let mapped_bytes (t : t) ~offset ~size =
    let p = F.wgpuBufferGetConstMappedRange t (sz offset) (sz size) in
    if Ctypes.is_null p then error "wgpuBufferGetConstMappedRange returned NULL";
    let c = Ctypes.from_voidp Ctypes.char p in
    Bytes.of_string (Ctypes.string_from_ptr c ~length:size)

  (** Map, copy out, unmap.  The buffer is unmapped even if the copy fails, so
      a failed read leaves the buffer usable. *)
  let read_sync ~device (t : t) ~offset ~size =
    map_read_sync ~device t ~offset ~size;
    Fun.protect
      ~finally:(fun () -> try unmap t with _ -> ())
      (fun () -> mapped_bytes t ~offset ~size)
end

(* ------------------------------------------------------------------ *)
(* Command encoding                                                    *)
(* ------------------------------------------------------------------ *)

module Command_encoder = struct
  type t = CommandEncoder.t

  let release (t : t) = F.wgpuCommandEncoderRelease t

  let begin_compute_pass ?label (t : t) =
    let a = Arena.create () in
    let d = ComputePassDescriptor.init () in
    Ctypes.setf d ComputePassDescriptor.label (Arena.opt_string_view a label);
    let p = F.wgpuCommandEncoderBeginComputePass t (Arena.addr a d) in
    Arena.finish a;
    check_handle "wgpuCommandEncoderBeginComputePass" p

  type color_attachment = {
    view : TextureView.t;
    load : LoadOp.t;
    store : StoreOp.t;
    clear : float * float * float * float;
  }

  let begin_render_pass ?label ~color_attachments (t : t) =
    let a = Arena.create () in
    let mk (ca : color_attachment) =
      let c = RenderPassColorAttachment.init () in
      Ctypes.setf c RenderPassColorAttachment.view ca.view;
      Ctypes.setf c RenderPassColorAttachment.loadOp ca.load;
      Ctypes.setf c RenderPassColorAttachment.storeOp ca.store;
      let r, g, b, al = ca.clear in
      let col = Color.init () in
      Ctypes.setf col Color.r r;
      Ctypes.setf col Color.g g;
      Ctypes.setf col Color.b b;
      Ctypes.setf col Color.a al;
      Ctypes.setf c RenderPassColorAttachment.clearValue col;
      c
    in
    let p, n = Arena.array a RenderPassColorAttachment.t (List.map mk color_attachments) in
    let d = RenderPassDescriptor.init () in
    Ctypes.setf d RenderPassDescriptor.label (Arena.opt_string_view a label);
    Ctypes.setf d RenderPassDescriptor.colorAttachmentCount (sz n);
    Ctypes.setf d RenderPassDescriptor.colorAttachments p;
    let e = F.wgpuCommandEncoderBeginRenderPass t (Arena.addr a d) in
    Arena.finish a;
    check_handle "wgpuCommandEncoderBeginRenderPass" e

  let copy_buffer_to_buffer (t : t) ~src ~src_offset ~dst ~dst_offset ~size =
    F.wgpuCommandEncoderCopyBufferToBuffer t src (u64 src_offset) dst (u64 dst_offset) (u64 size)

  (** Copy a whole 2D mip level into [buffer]; [bytes_per_row] must be a
      multiple of 256 (WebGPU's [COPY_BYTES_PER_ROW_ALIGNMENT]). *)
  let copy_texture_to_buffer (t : t) ~texture ?(mip_level = 0) ~buffer ?(buffer_offset = 0)
      ~bytes_per_row ~rows_per_image ~width ~height () =
    let a = Arena.create () in
    let src = TexelCopyTextureInfo.init () in
    Ctypes.setf src TexelCopyTextureInfo.texture texture;
    Ctypes.setf src TexelCopyTextureInfo.mipLevel (u32 mip_level);
    let dst = TexelCopyBufferInfo.init () in
    Ctypes.setf dst TexelCopyBufferInfo.buffer buffer;
    let layout = TexelCopyBufferLayout.init () in
    Ctypes.setf layout TexelCopyBufferLayout.offset (u64 buffer_offset);
    Ctypes.setf layout TexelCopyBufferLayout.bytesPerRow (u32 bytes_per_row);
    Ctypes.setf layout TexelCopyBufferLayout.rowsPerImage (u32 rows_per_image);
    Ctypes.setf dst TexelCopyBufferInfo.layout layout;
    let ext = Extent3D.init () in
    Ctypes.setf ext Extent3D.width (u32 width);
    Ctypes.setf ext Extent3D.height (u32 height);
    Ctypes.setf ext Extent3D.depthOrArrayLayers (u32 1);
    F.wgpuCommandEncoderCopyTextureToBuffer t (Arena.addr a src) (Arena.addr a dst)
      (Arena.addr a ext);
    Arena.finish a

  let finish ?label (t : t) =
    let a = Arena.create () in
    let d = CommandBufferDescriptor.init () in
    Ctypes.setf d CommandBufferDescriptor.label (Arena.opt_string_view a label);
    let cb = F.wgpuCommandEncoderFinish t (Arena.addr a d) in
    Arena.finish a;
    check_handle "wgpuCommandEncoderFinish" cb
end

module Compute_pass = struct
  type t = ComputePassEncoder.t

  let set_pipeline (t : t) p = F.wgpuComputePassEncoderSetPipeline t p

  let set_bind_group ?(index = 0) (t : t) g =
    F.wgpuComputePassEncoderSetBindGroup t (u32 index) g (sz 0)
      (Arena.null_ptr Ctypes.uint32_t)

  let dispatch_workgroups ?(y = 1) ?(z = 1) (t : t) x =
    F.wgpuComputePassEncoderDispatchWorkgroups t (u32 x) (u32 y) (u32 z)

  let finish (t : t) = F.wgpuComputePassEncoderEnd t
  let release (t : t) = F.wgpuComputePassEncoderRelease t
end

module Render_pass = struct
  type t = RenderPassEncoder.t

  let set_pipeline (t : t) p = F.wgpuRenderPassEncoderSetPipeline t p

  let set_bind_group ?(index = 0) (t : t) g =
    F.wgpuRenderPassEncoderSetBindGroup t (u32 index) g (sz 0) (Arena.null_ptr Ctypes.uint32_t)

  let draw ?(instance_count = 1) ?(first_vertex = 0) ?(first_instance = 0) (t : t) ~vertex_count =
    F.wgpuRenderPassEncoderDraw t (u32 vertex_count) (u32 instance_count) (u32 first_vertex)
      (u32 first_instance)

  let finish (t : t) = F.wgpuRenderPassEncoderEnd t
  let release (t : t) = F.wgpuRenderPassEncoderRelease t
end

module Texture = struct
  type t = Texture.t

  let release (t : t) = F.wgpuTextureRelease t
  let destroy (t : t) = F.wgpuTextureDestroy t

  let create_view ?label (t : t) =
    let a = Arena.create () in
    let d = TextureViewDescriptor.init () in
    Ctypes.setf d TextureViewDescriptor.label (Arena.opt_string_view a label);
    let v = F.wgpuTextureCreateView t (Arena.addr a d) in
    Arena.finish a;
    check_handle "wgpuTextureCreateView" v

  let release_view (v : TextureView.t) = F.wgpuTextureViewRelease v
end

module Shader_module = struct
  type t = ShaderModule.t

  let release (t : t) = F.wgpuShaderModuleRelease t
end

module Compute_pipeline = struct
  type t = ComputePipeline.t

  let release (t : t) = F.wgpuComputePipelineRelease t

  let bind_group_layout ?(index = 0) (t : t) =
    check_handle "wgpuComputePipelineGetBindGroupLayout"
      (F.wgpuComputePipelineGetBindGroupLayout t (u32 index))
end

module Render_pipeline = struct
  type t = RenderPipeline.t

  let release (t : t) = F.wgpuRenderPipelineRelease t

  let bind_group_layout ?(index = 0) (t : t) =
    check_handle "wgpuRenderPipelineGetBindGroupLayout"
      (F.wgpuRenderPipelineGetBindGroupLayout t (u32 index))
end

module Bind_group = struct
  type t = BindGroup.t

  let release (t : t) = F.wgpuBindGroupRelease t
  let release_layout (l : BindGroupLayout.t) = F.wgpuBindGroupLayoutRelease l
end

module Command_buffer = struct
  type t = CommandBuffer.t

  let release (t : t) = F.wgpuCommandBufferRelease t
end

(** Version of the loaded [libwgpu_native], e.g. ["29.0.1.1"]. *)
let runtime_version = Wgpu_loader.runtime_version

(** Version these bindings were generated for. *)
let pinned_version = Wgpu_pin.version
