(* Loading, the version gate, and the adapter/device queries. *)

let () =
  let ((instance, adapter, device, _) as ctx) = Gpu_check.setup ~label:"device-test" () in
  Gpu_check.equal_string "runtime version matches the pin" ~expected:Wgpu.Pin.version
    ~got:(Wgpu.runtime_version ());
  Gpu_check.is_true "a library path was recorded" (Wgpu.Loader.loaded_path () <> None);

  let info = Wgpu.Adapter.info adapter in
  Gpu_check.is_true "adapter has a device name" (String.length info.Wgpu.Adapter.device > 0);
  Gpu_check.is_true "adapter backend is known"
    (info.Wgpu.Adapter.backend_type <> Wgpu.Types.BackendType.undefined);
  print_endline ("adapter: " ^ Wgpu.Adapter.string_of_info info);

  let limits = Wgpu.Adapter.limits adapter in
  let max_1d =
    Unsigned.UInt32.to_int (Ctypes.getf limits Wgpu.Types.Limits.maxTextureDimension1D)
  in
  Gpu_check.is_true "maxTextureDimension1D is a real limit" (max_1d >= 2048 && max_1d < 0xFFFFFFFF);

  let features = Wgpu.Adapter.features adapter in
  Gpu_check.is_true "adapter reports features" (List.length features > 0);
  Gpu_check.is_true "feature list matches has_feature"
    (List.for_all (fun f -> Wgpu.Adapter.has_feature adapter f) features);

  let dev_limits = Wgpu.Device.limits device in
  Gpu_check.is_true "device limits are populated"
    (Unsigned.UInt32.to_int (Ctypes.getf dev_limits Wgpu.Types.Limits.maxBindGroups) > 0);
  Gpu_check.is_true "device is not lost" (Wgpu.Device.lost device = None);
  Gpu_check.is_true "queue is idle after poll" (Wgpu.Device.poll device);

  (* The wgpu-native adapter enumeration extension. *)
  let all = Wgpu.Instance.enumerate_adapters instance in
  Gpu_check.is_true "enumerate_adapters finds at least one adapter" (List.length all >= 1);
  List.iter
    (fun a ->
      Gpu_check.is_true "enumerated adapter is non-null" (not (Wgpu.Types.Adapter.is_null a));
      Wgpu.Adapter.release a)
    all;

  Gpu_check.teardown ctx;
  Gpu_check.finish "device"
