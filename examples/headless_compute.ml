(* Headless compute: multiply a storage buffer by two on the GPU and read the
   result back.  Needs no window and no display server.

   This is the raw binding, in the shape of wgpu-native's own C example
   (examples/compute/main.c): every descriptor starts from the header's
   [init ()] defaults and is filled with [Ctypes.setf], every handle is
   released explicitly, and the only helpers used are the three in
   [wgpu.utils].

   Run with:  dune exec examples/headless_compute.exe *)

module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils

let u32 = Unsigned.UInt32.of_int
let u64 = Unsigned.UInt64.of_int
let sz = Unsigned.Size_t.of_int
let nullp typ = Ctypes.from_voidp typ Ctypes.null

(* A [WGPUStringView] points at memory we own.  These are all the copies the
   descriptors below refer to, kept reachable until the end of [main]. *)
let owned_strings = ref []

let sv s =
  let view, keepalive = U.String_view.of_string s in
  owned_strings := keepalive :: !owned_strings;
  view

let shader =
  {|
@group(0) @binding(0) var<storage, read_write> data: array<u32>;

@compute @workgroup_size(1)
fn main(@builtin(global_invocation_id) id: vec3<u32>) {
  data[id.x] = data[id.x] * 2u + 1u;
}
|}

let bytes_of_u32_list l =
  let b = Bytes.create (4 * List.length l) in
  List.iteri (fun i v -> Bytes.set_int32_le b (4 * i) (Int32.of_int v)) l;
  b

let u32_list_of_bytes b =
  List.init (Bytes.length b / 4) (fun i -> Int32.to_int (Bytes.get_int32_le b (4 * i)))

(* webgpu.h allows this on any thread, so it runs behind the exception barrier
   and does nothing but print. *)
let uncaptured_error =
  Wgpu.Callback.permanent T.UncapturedErrorCallback.fn (fun _device ty message _u1 _u2 ->
      Wgpu.Callback.protect ~where:"uncaptured error callback" (fun () ->
          Printf.eprintf "[wgpu %s] %s\n%!" (T.ErrorType.to_string ty)
            (U.String_view.to_string message)))

let die fmt = Printf.ksprintf (fun s -> prerr_endline s; exit 1) fmt

let () =
  Printf.printf "wgpu-native %s (bindings pinned at %s)\n%!" (Wgpu.Loader.runtime_version ())
    Wgpu.Pin.version;

  let instance = F.wgpuCreateInstance (nullp T.InstanceDescriptor.t) in
  if T.Instance.is_null instance then die "wgpuCreateInstance returned NULL";

  let adapter =
    match U.Sync.request_adapter instance with
    | Ok a -> a
    | Error (status, msg) -> die "no adapter: %s (%s)" (T.RequestAdapterStatus.to_string status) msg
  in
  let info = T.AdapterInfo.init () in
  if F.wgpuAdapterGetInfo adapter (Ctypes.addr info) <> T.Status.success then
    die "wgpuAdapterGetInfo failed";
  Printf.printf "adapter: %s (%s, backend %s)\n%!"
    (U.String_view.to_string (Ctypes.getf info T.AdapterInfo.device))
    (U.String_view.to_string (Ctypes.getf info T.AdapterInfo.vendor))
    (T.BackendType.to_string (Ctypes.getf info T.AdapterInfo.backendType));
  F.wgpuAdapterInfoFreeMembers info;

  let device_desc = T.DeviceDescriptor.init () in
  Ctypes.setf device_desc T.DeviceDescriptor.label (sv "headless-compute");
  let uc = T.UncapturedErrorCallbackInfo.init () in
  Ctypes.setf uc T.UncapturedErrorCallbackInfo.callback uncaptured_error;
  Ctypes.setf device_desc T.DeviceDescriptor.uncapturedErrorCallbackInfo uc;
  let device =
    match U.Sync.request_device ~descriptor:device_desc adapter with
    | Ok d -> d
    | Error (status, msg) -> die "no device: %s (%s)" (T.RequestDeviceStatus.to_string status) msg
  in
  let queue = F.wgpuDeviceGetQueue device in

  let input = [ 1; 2; 3; 4; 5; 6; 7; 8 ] in
  let size = 4 * List.length input in

  let storage_desc = T.BufferDescriptor.init () in
  Ctypes.setf storage_desc T.BufferDescriptor.label (sv "storage");
  Ctypes.setf storage_desc T.BufferDescriptor.usage
    T.BufferUsage.(combine [ storage; copy_dst; copy_src ]);
  Ctypes.setf storage_desc T.BufferDescriptor.size (u64 size);
  let storage = F.wgpuDeviceCreateBuffer device (Ctypes.addr storage_desc) in

  let staging_desc = T.BufferDescriptor.init () in
  Ctypes.setf staging_desc T.BufferDescriptor.label (sv "staging");
  Ctypes.setf staging_desc T.BufferDescriptor.usage
    T.BufferUsage.(combine [ map_read; copy_dst ]);
  Ctypes.setf staging_desc T.BufferDescriptor.size (u64 size);
  let staging = F.wgpuDeviceCreateBuffer device (Ctypes.addr staging_desc) in

  (* WGSL source is a chained extension struct; [init ()] has already set its
     [chain.sType]. *)
  let wgsl = T.ShaderSourceWGSL.init () in
  Ctypes.setf wgsl T.ShaderSourceWGSL.code (sv shader);
  let module_desc = T.ShaderModuleDescriptor.init () in
  Ctypes.setf module_desc T.ShaderModuleDescriptor.label (sv "double");
  Ctypes.setf module_desc T.ShaderModuleDescriptor.nextInChain
    (Ctypes.coerce (Ctypes.ptr T.ShaderSourceWGSL.t) (Ctypes.ptr T.ChainedStruct.t)
       (Ctypes.addr wgsl));
  let shader_module = F.wgpuDeviceCreateShaderModule device (Ctypes.addr module_desc) in
  (* [module_desc] only holds [wgsl]'s raw address; keep the OCaml value alive
     until the call has returned. *)
  ignore (Sys.opaque_identity wgsl);

  let compute = T.ComputeState.init () in
  Ctypes.setf compute T.ComputeState.module_ shader_module;
  Ctypes.setf compute T.ComputeState.entryPoint (sv "main");
  let pipeline_desc = T.ComputePipelineDescriptor.init () in
  Ctypes.setf pipeline_desc T.ComputePipelineDescriptor.label (sv "double");
  Ctypes.setf pipeline_desc T.ComputePipelineDescriptor.compute compute;
  let pipeline = F.wgpuDeviceCreateComputePipeline device (Ctypes.addr pipeline_desc) in
  if T.ComputePipeline.is_null pipeline then die "wgpuDeviceCreateComputePipeline returned NULL";
  let layout = F.wgpuComputePipelineGetBindGroupLayout pipeline (u32 0) in

  let entry = T.BindGroupEntry.init () in
  Ctypes.setf entry T.BindGroupEntry.binding (u32 0);
  Ctypes.setf entry T.BindGroupEntry.buffer storage;
  Ctypes.setf entry T.BindGroupEntry.size (u64 size);
  let bind_group_desc = T.BindGroupDescriptor.init () in
  Ctypes.setf bind_group_desc T.BindGroupDescriptor.label (sv "data");
  Ctypes.setf bind_group_desc T.BindGroupDescriptor.layout layout;
  Ctypes.setf bind_group_desc T.BindGroupDescriptor.entryCount (sz 1);
  Ctypes.setf bind_group_desc T.BindGroupDescriptor.entries (Ctypes.addr entry);
  let bind_group = F.wgpuDeviceCreateBindGroup device (Ctypes.addr bind_group_desc) in
  ignore (Sys.opaque_identity entry);

  let data = Ctypes.CArray.of_string (Bytes.unsafe_to_string (bytes_of_u32_list input)) in
  F.wgpuQueueWriteBuffer queue storage (u64 0)
    (Ctypes.to_voidp (Ctypes.CArray.start data))
    (sz size);
  ignore (Sys.opaque_identity data);

  let encoder_desc = T.CommandEncoderDescriptor.init () in
  Ctypes.setf encoder_desc T.CommandEncoderDescriptor.label (sv "compute");
  let encoder = F.wgpuDeviceCreateCommandEncoder device (Ctypes.addr encoder_desc) in
  let pass_desc = T.ComputePassDescriptor.init () in
  Ctypes.setf pass_desc T.ComputePassDescriptor.label (sv "double");
  let pass = F.wgpuCommandEncoderBeginComputePass encoder (Ctypes.addr pass_desc) in
  F.wgpuComputePassEncoderSetPipeline pass pipeline;
  F.wgpuComputePassEncoderSetBindGroup pass (u32 0) bind_group (sz 0) (nullp Ctypes.uint32_t);
  F.wgpuComputePassEncoderDispatchWorkgroups pass (u32 (List.length input)) (u32 1) (u32 1);
  F.wgpuComputePassEncoderEnd pass;
  F.wgpuComputePassEncoderRelease pass;
  F.wgpuCommandEncoderCopyBufferToBuffer encoder storage (u64 0) staging (u64 0) (u64 size);
  let commands_desc = T.CommandBufferDescriptor.init () in
  Ctypes.setf commands_desc T.CommandBufferDescriptor.label (sv "compute");
  let commands = F.wgpuCommandEncoderFinish encoder (Ctypes.addr commands_desc) in
  let submitted = Ctypes.CArray.of_list T.CommandBuffer.t [ commands ] in
  F.wgpuQueueSubmit queue (sz 1) (Ctypes.CArray.start submitted);
  ignore (Sys.opaque_identity submitted);

  let result =
    match U.Buffer.read_bytes device staging ~offset:0 ~size with
    | Ok b -> b
    | Error (status, msg) -> die "readback failed: %s (%s)" (T.MapAsyncStatus.to_string status) msg
  in
  Printf.printf "in : %s\n" (String.concat " " (List.map string_of_int input));
  Printf.printf "out: %s\n%!"
    (String.concat " " (List.map string_of_int (u32_list_of_bytes result)));

  (* Explicit teardown, in reverse creation order. *)
  F.wgpuCommandBufferRelease commands;
  F.wgpuCommandEncoderRelease encoder;
  F.wgpuBindGroupRelease bind_group;
  F.wgpuBindGroupLayoutRelease layout;
  F.wgpuComputePipelineRelease pipeline;
  F.wgpuShaderModuleRelease shader_module;
  F.wgpuBufferRelease staging;
  F.wgpuBufferRelease storage;
  F.wgpuQueueRelease queue;
  F.wgpuDeviceRelease device;
  F.wgpuAdapterRelease adapter;
  F.wgpuInstanceRelease instance;
  ignore (Sys.opaque_identity !owned_strings)
