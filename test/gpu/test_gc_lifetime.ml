(* Lifetime tests.

   The dangerous combination in these bindings is: OCaml owns the memory a C
   descriptor points at, and OCaml closures are reachable from C function
   pointers.  These tests run the GC aggressively around - and inside - such
   calls. *)

open Ctypes
module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils
module Check = Gpu_check

let shader =
  {|
@group(0) @binding(0) var<storage, read_write> data: array<u32>;
@compute @workgroup_size(1)
fn main(@builtin(global_invocation_id) id: vec3<u32>) { data[id.x] = data[id.x] + 100u; }
|}

(* Builds descriptors from strings that become unreachable immediately, with a
   major collection between every step.  The label view points into memory that
   only [keepalive] holds, which is exactly the invariant a raw-layer caller
   owns. *)
let churn device =
  for i = 1 to 20 do
    Gc.full_major ();
    let label = Printf.sprintf "buffer-%d-%s" i (String.make (i mod 17) 'x') in
    let view, keepalive = U.String_view.of_string label in
    let d = T.BufferDescriptor.init () in
    setf d T.BufferDescriptor.label view;
    setf d T.BufferDescriptor.usage T.BufferUsage.(combine [ copy_dst; copy_src ]);
    setf d T.BufferDescriptor.size (Check.u64 (64 * i));
    let b = F.wgpuDeviceCreateBuffer device (addr d) in
    ignore (Sys.opaque_identity keepalive);
    Gc.full_major ();
    F.wgpuBufferRelease b
  done

let () =
  let ((instance, adapter, device, queue) as ctx) = Check.setup ~label:"gc-test" () in

  (* The permanent trampolines must survive compaction: this request goes
     through the same closure as the one in [setup]. *)
  Gc.compact ();
  (match U.Sync.request_adapter instance with
  | Ok a ->
      Check.is_true "adapter request after Gc.compact" (not (T.Adapter.is_null a));
      F.wgpuAdapterRelease a
  | Error (s, m) ->
      Check.is_true
        (Printf.sprintf "adapter request after Gc.compact: %s (%s)"
           (T.RequestAdapterStatus.to_string s) m)
        false);
  ignore adapter;

  churn device;
  Check.is_true "device survived the churn" (Check.poll device);
  Check.equal_int "the churn reported no errors" ~expected:0
    ~got:(List.length (Check.take_errors ()));

  (* A compute round trip whose mapping callback runs a full major collection
     while wgpu-native is on the stack. *)
  let size = 16 in
  let storage =
    Check.create_buffer device ~label:"gc-storage" ~size
      ~usage:T.BufferUsage.(combine [ storage; copy_dst; copy_src ])
  in
  let staging =
    Check.create_buffer device ~label:"gc-staging" ~size
      ~usage:T.BufferUsage.(combine [ map_read; copy_dst ])
  in
  let module_ = Check.create_shader_module device ~label:"add" shader in
  let pipeline = Check.create_compute_pipeline device ~label:"add" ~module_ ~entry_point:"main" in
  let layout = F.wgpuComputePipelineGetBindGroupLayout pipeline (Check.u32 0) in
  let bind_group = Check.create_storage_bind_group device ~layout ~buffer:storage ~size in
  Check.write_buffer queue storage (Check.bytes_of_u32 [ 1; 2; 3; 4 ]);
  let encoder_desc = T.CommandEncoderDescriptor.init () in
  let encoder = F.wgpuDeviceCreateCommandEncoder device (addr encoder_desc) in
  let pass_desc = T.ComputePassDescriptor.init () in
  let pass = F.wgpuCommandEncoderBeginComputePass encoder (addr pass_desc) in
  F.wgpuComputePassEncoderSetPipeline pass pipeline;
  F.wgpuComputePassEncoderSetBindGroup pass (Check.u32 0) bind_group (Check.sz 0)
    (Check.nullp Ctypes.uint32_t);
  F.wgpuComputePassEncoderDispatchWorkgroups pass (Check.u32 4) (Check.u32 1) (Check.u32 1);
  F.wgpuComputePassEncoderEnd pass;
  F.wgpuComputePassEncoderRelease pass;
  F.wgpuCommandEncoderCopyBufferToBuffer encoder storage (Check.u64 0) staging (Check.u64 0)
    (Check.u64 size);
  let commands_desc = T.CommandBufferDescriptor.init () in
  let commands = F.wgpuCommandEncoderFinish encoder (addr commands_desc) in
  Check.submit queue commands;

  (* Our own closure: the callback collects while wgpu-native is on the stack,
     then records the status. *)
  let collected = ref false in
  let status = ref None in
  let trampoline =
    Wgpu.Callback.permanent T.BufferMapCallback.fn (fun s _message _u1 _u2 ->
        Wgpu.Callback.protect ~where:"test gc map callback" (fun () ->
            Gc.full_major ();
            collected := true;
            status := Some s))
  in
  let info = T.BufferMapCallbackInfo.init () in
  setf info T.BufferMapCallbackInfo.mode T.CallbackMode.allow_process_events;
  setf info T.BufferMapCallbackInfo.callback trampoline;
  let (_ : T.Future.t) =
    F.wgpuBufferMapAsync staging T.MapMode.read (Check.sz 0) (Check.sz size) info
  in
  ignore (Check.poll device);
  Check.is_true "the map callback ran" !collected;
  Check.is_true "the map callback succeeded" (!status = Some T.MapAsyncStatus.success);
  let p = F.wgpuBufferGetConstMappedRange staging (Check.sz 0) (Check.sz size) in
  Check.is_true "the mapped range is not NULL" (not (is_null p));
  let got =
    Check.u32_of_bytes
      (Bytes.of_string (string_from_ptr (from_voidp char p) ~length:size))
  in
  Check.equal_int_list "result after GC inside the callback" ~expected:[ 101; 102; 103; 104 ]
    ~got;
  F.wgpuBufferUnmap staging;

  Gc.compact ();
  Check.is_true "retained closures are still rooted" (Wgpu.Callback.retained_count () > 0);
  Check.is_true "no callback raised" (Wgpu.Callback.pending_failures () = 0);
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
  Check.finish "gc lifetime"
