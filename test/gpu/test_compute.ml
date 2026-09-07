(* A real compute dispatch with an exact numerical result. *)

let shader =
  {|
@group(0) @binding(0) var<storage, read_write> data: array<u32>;

@compute @workgroup_size(4)
fn main(@builtin(global_invocation_id) id: vec3<u32>) {
  data[id.x] = data[id.x] * data[id.x] + 7u;
}
|}

let () =
  let ((_, _, device, queue) as ctx) = Gpu_check.setup ~label:"compute-test" () in
  let input = [ 0; 1; 2; 3; 4; 5; 6; 7 ] in
  let expected = List.map (fun v -> (v * v) + 7) input in
  let size = 4 * List.length input in

  let storage =
    Wgpu.Device.create_buffer device ~label:"storage" ~size
      ~usage:Wgpu.Types.BufferUsage.(combine [ storage; copy_dst; copy_src ])
  in
  let staging =
    Wgpu.Device.create_buffer device ~label:"staging" ~size
      ~usage:Wgpu.Types.BufferUsage.(combine [ map_read; copy_dst ])
  in
  Gpu_check.equal_int "buffer size" ~expected:size ~got:(Wgpu.Buffer.size storage);

  let module_ = Wgpu.Device.create_shader_module_wgsl device ~label:"square" shader in
  let pipeline =
    Wgpu.Device.create_compute_pipeline device ~label:"square" ~shader_module:module_
  in
  let layout = Wgpu.Compute_pipeline.bind_group_layout pipeline in
  let bind_group =
    Wgpu.Device.create_bind_group device ~layout
      ~entries:[ Wgpu.Device.Buffer_binding { binding = 0; buffer = storage; offset = 0; size } ]
  in

  Wgpu.Queue.write_buffer queue storage (Gpu_check.bytes_of_u32 input);
  let encoder = Wgpu.Device.create_command_encoder device in
  let pass = Wgpu.Command_encoder.begin_compute_pass encoder in
  Wgpu.Compute_pass.set_pipeline pass pipeline;
  Wgpu.Compute_pass.set_bind_group pass bind_group;
  (* workgroup_size(4) x 2 workgroups = the 8 elements *)
  Wgpu.Compute_pass.dispatch_workgroups pass 2;
  Wgpu.Compute_pass.finish pass;
  Wgpu.Compute_pass.release pass;
  Wgpu.Command_encoder.copy_buffer_to_buffer encoder ~src:storage ~src_offset:0 ~dst:staging
    ~dst_offset:0 ~size;
  let commands = Wgpu.Command_encoder.finish encoder in
  Wgpu.Queue.submit queue [ commands ];
  Wgpu.Device.check device;

  let got = Gpu_check.u32_of_bytes (Wgpu.Buffer.read_sync ~device staging ~offset:0 ~size) in
  Gpu_check.equal_int_list "compute result" ~expected ~got;

  (* Mapping tokens must not leak. *)
  Gpu_check.equal_int "no live callback tokens" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());

  Wgpu.Command_buffer.release commands;
  Wgpu.Command_encoder.release encoder;
  Wgpu.Bind_group.release bind_group;
  Wgpu.Bind_group.release_layout layout;
  Wgpu.Compute_pipeline.release pipeline;
  Wgpu.Shader_module.release module_;
  Wgpu.Buffer.release staging;
  Wgpu.Buffer.release storage;
  Gpu_check.teardown ctx;
  Gpu_check.finish "compute"
