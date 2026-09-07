(* A real compute dispatch with an exact numerical result, built from raw
   descriptors. *)

module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils
module Check = Gpu_check

let shader =
  {|
@group(0) @binding(0) var<storage, read_write> data: array<u32>;

@compute @workgroup_size(4)
fn main(@builtin(global_invocation_id) id: vec3<u32>) {
  data[id.x] = data[id.x] * data[id.x] + 7u;
}
|}

let () =
  let ((_, _, device, queue) as ctx) = Check.setup ~label:"compute-test" () in
  let input = [ 0; 1; 2; 3; 4; 5; 6; 7 ] in
  let expected = List.map (fun v -> (v * v) + 7) input in
  let size = 4 * List.length input in

  let storage =
    Check.create_buffer device ~label:"storage" ~size
      ~usage:T.BufferUsage.(combine [ storage; copy_dst; copy_src ])
  in
  let staging =
    Check.create_buffer device ~label:"staging" ~size
      ~usage:T.BufferUsage.(combine [ map_read; copy_dst ])
  in
  Check.equal_int "buffer size" ~expected:size
    ~got:(Unsigned.UInt64.to_int (F.wgpuBufferGetSize storage));

  let module_ = Check.create_shader_module device ~label:"square" shader in
  let pipeline =
    Check.create_compute_pipeline device ~label:"square" ~module_ ~entry_point:"main"
  in
  Check.is_true "the pipeline was created" (not (T.ComputePipeline.is_null pipeline));
  let layout = F.wgpuComputePipelineGetBindGroupLayout pipeline (Check.u32 0) in
  let bind_group = Check.create_storage_bind_group device ~layout ~buffer:storage ~size in

  Check.write_buffer queue storage (Check.bytes_of_u32 input);
  let encoder_desc = T.CommandEncoderDescriptor.init () in
  let encoder = F.wgpuDeviceCreateCommandEncoder device (Ctypes.addr encoder_desc) in
  let pass_desc = T.ComputePassDescriptor.init () in
  let pass = F.wgpuCommandEncoderBeginComputePass encoder (Ctypes.addr pass_desc) in
  F.wgpuComputePassEncoderSetPipeline pass pipeline;
  F.wgpuComputePassEncoderSetBindGroup pass (Check.u32 0) bind_group (Check.sz 0)
    (Check.nullp Ctypes.uint32_t);
  (* workgroup_size(4) x 2 workgroups = the 8 elements *)
  F.wgpuComputePassEncoderDispatchWorkgroups pass (Check.u32 2) (Check.u32 1) (Check.u32 1);
  F.wgpuComputePassEncoderEnd pass;
  F.wgpuComputePassEncoderRelease pass;
  F.wgpuCommandEncoderCopyBufferToBuffer encoder storage (Check.u64 0) staging (Check.u64 0)
    (Check.u64 size);
  let commands_desc = T.CommandBufferDescriptor.init () in
  let commands = F.wgpuCommandEncoderFinish encoder (Ctypes.addr commands_desc) in
  Check.submit queue commands;

  (match U.Buffer.read_bytes device staging ~offset:0 ~size with
  | Ok bytes -> Check.equal_int_list "compute result" ~expected ~got:(Check.u32_of_bytes bytes)
  | Error (s, m) ->
      Check.is_true
        (Printf.sprintf "readback failed: %s (%s)" (T.MapAsyncStatus.to_string s) m)
        false);

  Check.equal_int "the device reported no errors" ~expected:0
    ~got:(List.length (Check.take_errors ()));
  (* Mapping tokens must not leak. *)
  Check.equal_int "no live callback tokens" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());

  F.wgpuCommandBufferRelease commands;
  F.wgpuCommandEncoderRelease encoder;
  F.wgpuBindGroupRelease bind_group;
  F.wgpuBindGroupLayoutRelease layout;
  F.wgpuComputePipelineRelease pipeline;
  F.wgpuShaderModuleRelease module_;
  F.wgpuBufferRelease staging;
  F.wgpuBufferRelease storage;
  Check.teardown ctx;
  Check.finish "compute"
