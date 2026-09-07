(* Lifetime tests.

   The dangerous combination in these bindings is: OCaml owns the memory a C
   descriptor points at, and OCaml closures are reachable from C function
   pointers.  These tests run the GC aggressively around - and inside - such
   calls. *)

open Ctypes
module T = Wgpu.Types
module F = Wgpu.Fn

let shader =
  {|
@group(0) @binding(0) var<storage, read_write> data: array<u32>;
@compute @workgroup_size(1)
fn main(@builtin(global_invocation_id) id: vec3<u32>) { data[id.x] = data[id.x] + 100u; }
|}

(* Builds descriptors from strings that become unreachable immediately, with a
   major collection between every step. *)
let churn device =
  for i = 1 to 20 do
    Gc.full_major ();
    let label = Printf.sprintf "buffer-%d-%s" i (String.make (i mod 17) 'x') in
    let b =
      Wgpu.Device.create_buffer device ~label ~size:(64 * i)
        ~usage:T.BufferUsage.(combine [ copy_dst; copy_src ])
    in
    Gc.full_major ();
    Wgpu.Buffer.release b
  done

let () =
  let ((instance, adapter, device, queue) as ctx) = Gpu_check.setup ~label:"gc-test" () in

  (* The permanent trampolines must survive compaction: this request goes
     through the same closure as the one in [setup]. *)
  Gc.compact ();
  let adapter2 = Wgpu.Instance.request_adapter instance in
  Gpu_check.is_true "adapter request after Gc.compact" (not (T.Adapter.is_null adapter2));
  Wgpu.Adapter.release adapter2;
  ignore adapter;

  churn device;
  Gpu_check.is_true "device survived the churn" (Wgpu.Device.poll device);

  (* A compute round trip driven through the raw layer, with a callback that
     runs a full major collection while the C stack is live. *)
  let size = 16 in
  let storage =
    Wgpu.Device.create_buffer device ~label:"gc-storage" ~size
      ~usage:T.BufferUsage.(combine [ storage; copy_dst; copy_src ])
  in
  let staging =
    Wgpu.Device.create_buffer device ~label:"gc-staging" ~size
      ~usage:T.BufferUsage.(combine [ map_read; copy_dst ])
  in
  let module_ = Wgpu.Device.create_shader_module_wgsl device ~label:"add" shader in
  let pipeline = Wgpu.Device.create_compute_pipeline device ~shader_module:module_ in
  let layout = Wgpu.Compute_pipeline.bind_group_layout pipeline in
  let bind_group =
    Wgpu.Device.create_bind_group device ~layout
      ~entries:[ Wgpu.Device.Buffer_binding { binding = 0; buffer = storage; offset = 0; size } ]
  in
  Wgpu.Queue.write_buffer queue storage (Gpu_check.bytes_of_u32 [ 1; 2; 3; 4 ]);
  let encoder = Wgpu.Device.create_command_encoder device in
  let pass = Wgpu.Command_encoder.begin_compute_pass encoder in
  Wgpu.Compute_pass.set_pipeline pass pipeline;
  Wgpu.Compute_pass.set_bind_group pass bind_group;
  Wgpu.Compute_pass.dispatch_workgroups pass 4;
  Wgpu.Compute_pass.finish pass;
  Wgpu.Compute_pass.release pass;
  Wgpu.Command_encoder.copy_buffer_to_buffer encoder ~src:storage ~src_offset:0 ~dst:staging
    ~dst_offset:0 ~size;
  let commands = Wgpu.Command_encoder.finish encoder in
  Wgpu.Queue.submit queue [ commands ];

  (* Raw-layer mapping with our own closure: the callback collects while
     wgpu-native is on the stack, then records the status. *)
  let collected = ref false in
  let status = ref None in
  let trampoline =
    Wgpu.Callback.permanent T.BufferMapCallback.fn (fun s _message _u1 _u2 ->
        Gc.full_major ();
        collected := true;
        status := Some s)
  in
  let info = T.BufferMapCallbackInfo.init () in
  setf info T.BufferMapCallbackInfo.mode T.CallbackMode.allow_process_events;
  setf info T.BufferMapCallbackInfo.callback trampoline;
  let (_ : T.Future.t) =
    F.wgpuBufferMapAsync staging T.MapMode.read (Unsigned.Size_t.of_int 0)
      (Unsigned.Size_t.of_int size) info
  in
  ignore (Wgpu.Device.poll device);
  Gpu_check.is_true "the map callback ran" !collected;
  Gpu_check.is_true "the map callback succeeded" (!status = Some T.MapAsyncStatus.success);
  let got = Gpu_check.u32_of_bytes (Wgpu.Buffer.mapped_bytes staging ~offset:0 ~size) in
  Gpu_check.equal_int_list "result after GC inside the callback" ~expected:[ 101; 102; 103; 104 ]
    ~got;
  Wgpu.Buffer.unmap staging;

  Gc.compact ();
  Gpu_check.is_true "retained closures are still rooted" (Wgpu.Callback.retained_count () > 0);
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
  Gpu_check.finish "gc lifetime"
