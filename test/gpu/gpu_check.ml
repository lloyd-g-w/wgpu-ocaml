(* Shared helpers for the tests that need a real adapter.  Kept separate from
   test/unit/check.ml so that the unit tests never link anything that touches
   libwgpu_native.

   Everything here is the raw binding plus [wgpu.utils]; there is no ergonomic
   layer to test. *)

module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils

let failures = ref 0
let checks = ref 0

let fail fmt = Printf.ksprintf (fun s -> incr failures; prerr_endline ("FAIL: " ^ s)) fmt

let is_true name b =
  incr checks;
  if not b then fail "%s" name

let equal_int name ~expected ~got =
  incr checks;
  if expected <> got then fail "%s: expected %d, got %d" name expected got

let equal_string name ~expected ~got =
  incr checks;
  if expected <> got then fail "%s: expected %S, got %S" name expected got

let equal_int_list name ~expected ~got =
  incr checks;
  if expected <> got then
    fail "%s: expected [%s], got [%s]" name
      (String.concat "; " (List.map string_of_int expected))
      (String.concat "; " (List.map string_of_int got))

let contains haystack needle =
  let n = String.length haystack and m = String.length needle in
  let rec go i = i + m <= n && (String.sub haystack i m = needle || go (i + 1)) in
  go 0

let finish name =
  if !failures > 0 then begin
    Printf.eprintf "%s: %d/%d checks failed\n" name !failures !checks;
    exit 1
  end;
  Printf.printf "ok: %s (%d checks)\n" name !checks

let u32 = Unsigned.UInt32.of_int
let u64 = Unsigned.UInt64.of_int
let sz = Unsigned.Size_t.of_int
let nullp typ = Ctypes.from_voidp typ Ctypes.null

(* Strings a descriptor points at must outlive the call that reads it. *)
let owned_strings = ref []

let sv s =
  let view, keepalive = U.String_view.of_string s in
  owned_strings := keepalive :: !owned_strings;
  view

(* The device's uncaptured-error callback.  WebGPU reports validation failures
   through it, so the tests collect them here and inspect them explicitly -
   that is what "the device reported an error" means without an error sink in
   the library. *)
let device_errors : (T.ErrorType.t * string) list ref = ref []

let uncaptured_error =
  Wgpu.Callback.permanent T.UncapturedErrorCallback.fn (fun _device ty message _u1 _u2 ->
      Wgpu.Callback.protect ~where:"uncaptured error callback" (fun () ->
          let m = U.String_view.to_string message in
          Wgpu.Callback.with_lock (fun () -> device_errors := (ty, m) :: !device_errors)))

(** Collect and clear the errors reported since the last call. *)
let take_errors () =
  Wgpu.Callback.with_lock (fun () ->
      let l = List.rev !device_errors in
      device_errors := [];
      l)

let string_of_errors l =
  String.concat "; "
    (List.map (fun (ty, m) -> Printf.sprintf "%s: %s" (T.ErrorType.to_string ty) m) l)

let poll ?(wait = true) device =
  F.wgpuDevicePoll device (u32 (if wait then 1 else 0)) (nullp Ctypes.uint64_t)
  <> Unsigned.UInt32.zero

let die fmt = Printf.ksprintf (fun s -> prerr_endline ("FAIL: " ^ s); exit 1) fmt

(* Every GPU test starts the same way. *)
let setup ?(label = "test") () =
  let instance = F.wgpuCreateInstance (nullp T.InstanceDescriptor.t) in
  if T.Instance.is_null instance then die "wgpuCreateInstance returned NULL";
  let adapter =
    match U.Sync.request_adapter instance with
    | Ok a -> a
    | Error (s, m) -> die "no adapter: %s (%s)" (T.RequestAdapterStatus.to_string s) m
  in
  let desc = T.DeviceDescriptor.init () in
  Ctypes.setf desc T.DeviceDescriptor.label (sv label);
  let uc = T.UncapturedErrorCallbackInfo.init () in
  Ctypes.setf uc T.UncapturedErrorCallbackInfo.callback uncaptured_error;
  Ctypes.setf desc T.DeviceDescriptor.uncapturedErrorCallbackInfo uc;
  let device =
    match U.Sync.request_device ~descriptor:desc adapter with
    | Ok d -> d
    | Error (s, m) -> die "no device: %s (%s)" (T.RequestDeviceStatus.to_string s) m
  in
  let queue = F.wgpuDeviceGetQueue device in
  (instance, adapter, device, queue)

let teardown (instance, adapter, device, queue) =
  F.wgpuQueueRelease queue;
  F.wgpuDeviceRelease device;
  F.wgpuAdapterRelease adapter;
  F.wgpuInstanceRelease instance;
  ignore (Sys.opaque_identity !owned_strings)

(* ------------------------------------------------------------------ *)
(* Descriptor shorthands the tests share                               *)
(* ------------------------------------------------------------------ *)

let create_buffer device ~label ~usage ~size =
  let d = T.BufferDescriptor.init () in
  Ctypes.setf d T.BufferDescriptor.label (sv label);
  Ctypes.setf d T.BufferDescriptor.usage usage;
  Ctypes.setf d T.BufferDescriptor.size (u64 size);
  F.wgpuDeviceCreateBuffer device (Ctypes.addr d)

let create_shader_module device ~label code =
  let wgsl = T.ShaderSourceWGSL.init () in
  Ctypes.setf wgsl T.ShaderSourceWGSL.code (sv code);
  let d = T.ShaderModuleDescriptor.init () in
  Ctypes.setf d T.ShaderModuleDescriptor.label (sv label);
  Ctypes.setf d T.ShaderModuleDescriptor.nextInChain
    (Ctypes.coerce (Ctypes.ptr T.ShaderSourceWGSL.t) (Ctypes.ptr T.ChainedStruct.t)
       (Ctypes.addr wgsl));
  let m = F.wgpuDeviceCreateShaderModule device (Ctypes.addr d) in
  ignore (Sys.opaque_identity wgsl);
  m

let create_compute_pipeline device ~label ~module_ ~entry_point =
  let compute = T.ComputeState.init () in
  Ctypes.setf compute T.ComputeState.module_ module_;
  Ctypes.setf compute T.ComputeState.entryPoint (sv entry_point);
  let d = T.ComputePipelineDescriptor.init () in
  Ctypes.setf d T.ComputePipelineDescriptor.label (sv label);
  Ctypes.setf d T.ComputePipelineDescriptor.compute compute;
  F.wgpuDeviceCreateComputePipeline device (Ctypes.addr d)

let create_storage_bind_group device ~layout ~buffer ~size =
  let e = T.BindGroupEntry.init () in
  Ctypes.setf e T.BindGroupEntry.binding (u32 0);
  Ctypes.setf e T.BindGroupEntry.buffer buffer;
  Ctypes.setf e T.BindGroupEntry.size (u64 size);
  let d = T.BindGroupDescriptor.init () in
  Ctypes.setf d T.BindGroupDescriptor.layout layout;
  Ctypes.setf d T.BindGroupDescriptor.entryCount (sz 1);
  Ctypes.setf d T.BindGroupDescriptor.entries (Ctypes.addr e);
  let g = F.wgpuDeviceCreateBindGroup device (Ctypes.addr d) in
  ignore (Sys.opaque_identity e);
  g

let write_buffer queue buffer (data : Bytes.t) =
  let arr = Ctypes.CArray.of_string (Bytes.unsafe_to_string data) in
  F.wgpuQueueWriteBuffer queue buffer (u64 0)
    (Ctypes.to_voidp (Ctypes.CArray.start arr))
    (sz (Bytes.length data));
  ignore (Sys.opaque_identity arr)

let submit queue commands =
  let arr = Ctypes.CArray.of_list T.CommandBuffer.t [ commands ] in
  F.wgpuQueueSubmit queue (sz 1) (Ctypes.CArray.start arr);
  ignore (Sys.opaque_identity arr)

let bytes_of_u32 l =
  let b = Bytes.create (4 * List.length l) in
  List.iteri (fun i v -> Bytes.set_int32_le b (4 * i) (Int32.of_int v)) l;
  b

let u32_of_bytes b =
  List.init (Bytes.length b / 4) (fun i -> Int32.to_int (Bytes.get_int32_le b (4 * i)))
