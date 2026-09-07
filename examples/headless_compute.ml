(* Headless compute: multiply a storage buffer by two on the GPU and read the
   result back.  Needs no window and no display server.

   Run with:  dune exec examples/headless_compute.exe *)

open Wgpu

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

let () =
  Log.to_stderr ~level:Types.LogLevel.warn ();
  Printf.printf "wgpu-native %s (bindings pinned at %s)\n%!" (runtime_version ()) pinned_version;

  let instance = Instance.create () in
  let adapter = Instance.request_adapter instance in
  Printf.printf "adapter: %s\n%!" (Adapter.string_of_info (Adapter.info adapter));
  let device = Adapter.request_device ~label:"headless-compute" adapter in
  let queue = Device.queue device in

  let input = [ 1; 2; 3; 4; 5; 6; 7; 8 ] in
  let size = 4 * List.length input in

  let storage =
    Device.create_buffer device ~label:"storage" ~size
      ~usage:
        Types.BufferUsage.(combine [ storage; copy_dst; copy_src ])
  in
  let staging =
    Device.create_buffer device ~label:"staging" ~size
      ~usage:Types.BufferUsage.(combine [ map_read; copy_dst ])
  in

  let module_ = Device.create_shader_module_wgsl device ~label:"double" shader in
  let pipeline =
    Device.create_compute_pipeline device ~label:"double" ~shader_module:module_
      ~entry_point:"main"
  in
  let layout = Compute_pipeline.bind_group_layout pipeline in
  let bind_group =
    Device.create_bind_group device ~label:"data" ~layout
      ~entries:[ Device.Buffer_binding { binding = 0; buffer = storage; offset = 0; size } ]
  in

  Queue.write_buffer queue storage (bytes_of_u32_list input);

  let encoder = Device.create_command_encoder device ~label:"compute" in
  let pass = Command_encoder.begin_compute_pass encoder ~label:"double" in
  Compute_pass.set_pipeline pass pipeline;
  Compute_pass.set_bind_group pass bind_group;
  Compute_pass.dispatch_workgroups pass (List.length input);
  Compute_pass.finish pass;
  Compute_pass.release pass;
  Command_encoder.copy_buffer_to_buffer encoder ~src:storage ~src_offset:0 ~dst:staging
    ~dst_offset:0 ~size;
  let commands = Command_encoder.finish encoder ~label:"compute" in
  Queue.submit queue [ commands ];
  Device.check device;

  let result = Buffer.read_sync ~device staging ~offset:0 ~size in
  Printf.printf "in : %s\n" (String.concat " " (List.map string_of_int input));
  Printf.printf "out: %s\n%!"
    (String.concat " " (List.map string_of_int (u32_list_of_bytes result)));

  (* Explicit teardown, in reverse creation order. *)
  Command_buffer.release commands;
  Command_encoder.release encoder;
  Bind_group.release bind_group;
  Bind_group.release_layout layout;
  Compute_pipeline.release pipeline;
  Shader_module.release module_;
  Buffer.release staging;
  Buffer.release storage;
  Queue.release queue;
  Device.release device;
  Adapter.release adapter;
  Instance.release instance
