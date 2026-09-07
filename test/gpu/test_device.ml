(* Loading, the version gate, and the adapter/device queries, straight through
   the raw entry points. *)

module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils
module Check = Gpu_check

let () =
  let ((instance, adapter, device, _) as ctx) = Check.setup ~label:"device-test" () in
  Check.equal_string "runtime version matches the pin" ~expected:Wgpu.Pin.version
    ~got:(Wgpu.Loader.runtime_version ());
  Check.is_true "a library path was recorded" (Wgpu.Loader.loaded_path () <> None);

  let info = T.AdapterInfo.init () in
  Check.is_true "wgpuAdapterGetInfo succeeds"
    (F.wgpuAdapterGetInfo adapter (Ctypes.addr info) = T.Status.success);
  let name = U.String_view.to_string (Ctypes.getf info T.AdapterInfo.device) in
  let backend = Ctypes.getf info T.AdapterInfo.backendType in
  Check.is_true "adapter has a device name" (String.length name > 0);
  Check.is_true "adapter backend is known" (backend <> T.BackendType.undefined);
  print_endline
    (Printf.sprintf "adapter: %s (%s)" name (T.BackendType.to_string backend));
  F.wgpuAdapterInfoFreeMembers info;

  let limits = T.Limits.init () in
  Check.is_true "wgpuAdapterGetLimits succeeds"
    (F.wgpuAdapterGetLimits adapter (Ctypes.addr limits) = T.Status.success);
  let max_1d = Unsigned.UInt32.to_int (Ctypes.getf limits T.Limits.maxTextureDimension1D) in
  Check.is_true "maxTextureDimension1D is a real limit" (max_1d >= 2048 && max_1d < 0xFFFFFFFF);

  let supported = T.SupportedFeatures.init () in
  F.wgpuAdapterGetFeatures adapter (Ctypes.addr supported);
  let n = Unsigned.Size_t.to_int (Ctypes.getf supported T.SupportedFeatures.featureCount) in
  let p = Ctypes.getf supported T.SupportedFeatures.features in
  let features = List.init n (fun i -> Ctypes.(!@(p +@ i))) in
  Check.is_true "adapter reports features" (n > 0);
  Check.is_true "feature list matches wgpuAdapterHasFeature"
    (List.for_all
       (fun f -> F.wgpuAdapterHasFeature adapter f <> Unsigned.UInt32.zero)
       features);
  F.wgpuSupportedFeaturesFreeMembers supported;

  let dev_limits = T.Limits.init () in
  Check.is_true "wgpuDeviceGetLimits succeeds"
    (F.wgpuDeviceGetLimits device (Ctypes.addr dev_limits) = T.Status.success);
  Check.is_true "device limits are populated"
    (Unsigned.UInt32.to_int (Ctypes.getf dev_limits T.Limits.maxBindGroups) > 0);
  Check.is_true "queue is idle after poll" (Check.poll device);

  (* The wgpu-native adapter enumeration extension, with the two-call protocol
     the entry point requires (no capacity argument; see DESIGN.md §9). *)
  let opts = T.InstanceEnumerateAdapterOptions.init () in
  Ctypes.setf opts T.InstanceEnumerateAdapterOptions.backends T.InstanceBackend.all;
  let popts = Ctypes.addr opts in
  let count =
    Unsigned.Size_t.to_int
      (F.wgpuInstanceEnumerateAdapters instance popts (Check.nullp T.Adapter.t))
  in
  Check.is_true "enumerate_adapters finds at least one adapter" (count >= 1);
  let arr = Ctypes.CArray.make T.Adapter.t (max count 1) in
  let count =
    Unsigned.Size_t.to_int
      (F.wgpuInstanceEnumerateAdapters instance popts (Ctypes.CArray.start arr))
  in
  List.iter
    (fun a ->
      Check.is_true "enumerated adapter is non-null" (not (T.Adapter.is_null a));
      F.wgpuAdapterRelease a)
    (List.init count (Ctypes.CArray.get arr));

  Check.equal_int "no live callback tokens" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());
  Check.teardown ctx;
  Check.finish "device"
