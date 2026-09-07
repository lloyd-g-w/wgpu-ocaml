(* Offscreen render: draw a triangle into an RGBA8 texture, copy it back and
   print an ASCII view of the result.  No window, no surface, no swapchain.

   This is the raw binding, in the shape of wgpu-native's own C example
   (examples/triangle/main.c) minus the windowing: every descriptor starts from
   the header's [init ()] defaults and is filled with [Ctypes.setf], every
   handle is released explicitly, and the only helpers used are the three in
   [wgpu.utils].

   Run with:  dune exec examples/offscreen_render.exe *)

module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils

let u32 = Unsigned.UInt32.of_int
let u64 = Unsigned.UInt64.of_int
let sz = Unsigned.Size_t.of_int
let nullp typ = Ctypes.from_voidp typ Ctypes.null
let width = 32
let height = 32

(* One row of a texture-to-buffer copy must be a multiple of 256 bytes. *)
let bytes_per_row = ((width * 4) + 255) / 256 * 256

(* A [WGPUStringView] points at memory we own. *)
let owned_strings = ref []

let sv s =
  let view, keepalive = U.String_view.of_string s in
  owned_strings := keepalive :: !owned_strings;
  view

let shader =
  {|
@vertex
fn vs_main(@builtin(vertex_index) i: u32) -> @builtin(position) vec4<f32> {
  var p = array<vec2<f32>, 3>(vec2<f32>(-1.0, -1.0), vec2<f32>(1.0, -1.0), vec2<f32>(-1.0, 1.0));
  return vec4<f32>(p[i], 0.0, 1.0);
}

@fragment
fn fs_main() -> @location(0) vec4<f32> {
  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
}
|}

let uncaptured_error =
  Wgpu.Callback.permanent T.UncapturedErrorCallback.fn (fun _device ty message _u1 _u2 ->
      Wgpu.Callback.protect ~where:"uncaptured error callback" (fun () ->
          Printf.eprintf "[wgpu %s] %s\n%!" (T.ErrorType.to_string ty)
            (U.String_view.to_string message)))

let die fmt = Printf.ksprintf (fun s -> prerr_endline s; exit 1) fmt

let () =
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
  Ctypes.setf device_desc T.DeviceDescriptor.label (sv "offscreen-render");
  let uc = T.UncapturedErrorCallbackInfo.init () in
  Ctypes.setf uc T.UncapturedErrorCallbackInfo.callback uncaptured_error;
  Ctypes.setf device_desc T.DeviceDescriptor.uncapturedErrorCallbackInfo uc;
  let device =
    match U.Sync.request_device ~descriptor:device_desc adapter with
    | Ok d -> d
    | Error (status, msg) -> die "no device: %s (%s)" (T.RequestDeviceStatus.to_string status) msg
  in
  let queue = F.wgpuDeviceGetQueue device in
  let format = T.TextureFormat.rgba8_unorm in

  let extent = T.Extent3D.init () in
  Ctypes.setf extent T.Extent3D.width (u32 width);
  Ctypes.setf extent T.Extent3D.height (u32 height);
  Ctypes.setf extent T.Extent3D.depthOrArrayLayers (u32 1);
  let texture_desc = T.TextureDescriptor.init () in
  Ctypes.setf texture_desc T.TextureDescriptor.label (sv "target");
  Ctypes.setf texture_desc T.TextureDescriptor.usage
    T.TextureUsage.(combine [ render_attachment; copy_src ]);
  Ctypes.setf texture_desc T.TextureDescriptor.dimension T.TextureDimension.v2_d;
  Ctypes.setf texture_desc T.TextureDescriptor.format format;
  Ctypes.setf texture_desc T.TextureDescriptor.size extent;
  Ctypes.setf texture_desc T.TextureDescriptor.mipLevelCount (u32 1);
  Ctypes.setf texture_desc T.TextureDescriptor.sampleCount (u32 1);
  let texture = F.wgpuDeviceCreateTexture device (Ctypes.addr texture_desc) in
  let view_desc = T.TextureViewDescriptor.init () in
  Ctypes.setf view_desc T.TextureViewDescriptor.label (sv "target-view");
  let view = F.wgpuTextureCreateView texture (Ctypes.addr view_desc) in

  let wgsl = T.ShaderSourceWGSL.init () in
  Ctypes.setf wgsl T.ShaderSourceWGSL.code (sv shader);
  let module_desc = T.ShaderModuleDescriptor.init () in
  Ctypes.setf module_desc T.ShaderModuleDescriptor.label (sv "triangle");
  Ctypes.setf module_desc T.ShaderModuleDescriptor.nextInChain
    (Ctypes.coerce (Ctypes.ptr T.ShaderSourceWGSL.t) (Ctypes.ptr T.ChainedStruct.t)
       (Ctypes.addr wgsl));
  let shader_module = F.wgpuDeviceCreateShaderModule device (Ctypes.addr module_desc) in
  (* [module_desc] only holds [wgsl]'s raw address; keep the OCaml value alive
     until the call has returned. *)
  ignore (Sys.opaque_identity wgsl);

  let target = T.ColorTargetState.init () in
  Ctypes.setf target T.ColorTargetState.format format;
  Ctypes.setf target T.ColorTargetState.writeMask T.ColorWriteMask.all;
  let fragment = T.FragmentState.init () in
  Ctypes.setf fragment T.FragmentState.module_ shader_module;
  Ctypes.setf fragment T.FragmentState.entryPoint (sv "fs_main");
  Ctypes.setf fragment T.FragmentState.targetCount (sz 1);
  Ctypes.setf fragment T.FragmentState.targets (Ctypes.addr target);
  let pipeline_desc = T.RenderPipelineDescriptor.init () in
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.label (sv "triangle");
  let vertex = T.VertexState.init () in
  Ctypes.setf vertex T.VertexState.module_ shader_module;
  Ctypes.setf vertex T.VertexState.entryPoint (sv "vs_main");
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.vertex vertex;
  let primitive = T.PrimitiveState.init () in
  Ctypes.setf primitive T.PrimitiveState.topology T.PrimitiveTopology.triangle_list;
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.primitive primitive;
  let multisample = T.MultisampleState.init () in
  Ctypes.setf multisample T.MultisampleState.count (u32 1);
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.multisample multisample;
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.fragment (Ctypes.addr fragment);
  let pipeline = F.wgpuDeviceCreateRenderPipeline device (Ctypes.addr pipeline_desc) in
  ignore (Sys.opaque_identity (fragment, target));
  if T.RenderPipeline.is_null pipeline then die "wgpuDeviceCreateRenderPipeline returned NULL";

  let size = bytes_per_row * height in
  let readback_desc = T.BufferDescriptor.init () in
  Ctypes.setf readback_desc T.BufferDescriptor.label (sv "readback");
  Ctypes.setf readback_desc T.BufferDescriptor.usage
    T.BufferUsage.(combine [ map_read; copy_dst ]);
  Ctypes.setf readback_desc T.BufferDescriptor.size (u64 size);
  let readback = F.wgpuDeviceCreateBuffer device (Ctypes.addr readback_desc) in

  let encoder_desc = T.CommandEncoderDescriptor.init () in
  Ctypes.setf encoder_desc T.CommandEncoderDescriptor.label (sv "render");
  let encoder = F.wgpuDeviceCreateCommandEncoder device (Ctypes.addr encoder_desc) in

  let clear = T.Color.init () in
  Ctypes.setf clear T.Color.r 0.0;
  Ctypes.setf clear T.Color.g 0.0;
  Ctypes.setf clear T.Color.b 1.0;
  Ctypes.setf clear T.Color.a 1.0;
  let attachment = T.RenderPassColorAttachment.init () in
  Ctypes.setf attachment T.RenderPassColorAttachment.view view;
  Ctypes.setf attachment T.RenderPassColorAttachment.loadOp T.LoadOp.clear;
  Ctypes.setf attachment T.RenderPassColorAttachment.storeOp T.StoreOp.store;
  Ctypes.setf attachment T.RenderPassColorAttachment.clearValue clear;
  let pass_desc = T.RenderPassDescriptor.init () in
  Ctypes.setf pass_desc T.RenderPassDescriptor.label (sv "triangle");
  Ctypes.setf pass_desc T.RenderPassDescriptor.colorAttachmentCount (sz 1);
  Ctypes.setf pass_desc T.RenderPassDescriptor.colorAttachments (Ctypes.addr attachment);
  let pass = F.wgpuCommandEncoderBeginRenderPass encoder (Ctypes.addr pass_desc) in
  ignore (Sys.opaque_identity attachment);
  F.wgpuRenderPassEncoderSetPipeline pass pipeline;
  F.wgpuRenderPassEncoderDraw pass (u32 3) (u32 1) (u32 0) (u32 0);
  F.wgpuRenderPassEncoderEnd pass;
  F.wgpuRenderPassEncoderRelease pass;

  let copy_src = T.TexelCopyTextureInfo.init () in
  Ctypes.setf copy_src T.TexelCopyTextureInfo.texture texture;
  let layout = T.TexelCopyBufferLayout.init () in
  Ctypes.setf layout T.TexelCopyBufferLayout.bytesPerRow (u32 bytes_per_row);
  Ctypes.setf layout T.TexelCopyBufferLayout.rowsPerImage (u32 height);
  let copy_dst = T.TexelCopyBufferInfo.init () in
  Ctypes.setf copy_dst T.TexelCopyBufferInfo.buffer readback;
  Ctypes.setf copy_dst T.TexelCopyBufferInfo.layout layout;
  F.wgpuCommandEncoderCopyTextureToBuffer encoder (Ctypes.addr copy_src) (Ctypes.addr copy_dst)
    (Ctypes.addr extent);

  let commands_desc = T.CommandBufferDescriptor.init () in
  Ctypes.setf commands_desc T.CommandBufferDescriptor.label (sv "render");
  let commands = F.wgpuCommandEncoderFinish encoder (Ctypes.addr commands_desc) in
  let submitted = Ctypes.CArray.of_list T.CommandBuffer.t [ commands ] in
  F.wgpuQueueSubmit queue (sz 1) (Ctypes.CArray.start submitted);
  ignore (Sys.opaque_identity submitted);

  let pixels =
    match U.Buffer.read_bytes device readback ~offset:0 ~size with
    | Ok b -> b
    | Error (status, msg) -> die "readback failed: %s (%s)" (T.MapAsyncStatus.to_string status) msg
  in
  let pixel x y =
    let o = (y * bytes_per_row) + (x * 4) in
    ( Char.code (Bytes.get pixels o),
      Char.code (Bytes.get pixels (o + 1)),
      Char.code (Bytes.get pixels (o + 2)),
      Char.code (Bytes.get pixels (o + 3)) )
  in
  for y = 0 to height - 1 do
    for x = 0 to width - 1 do
      let r, _, b, _ = pixel x y in
      print_char (if r > 128 then '#' else if b > 128 then '.' else '?')
    done;
    print_newline ()
  done;
  let r, g, b, a = pixel 1 (height - 2) in
  Printf.printf "bottom-left pixel: r=%d g=%d b=%d a=%d\n" r g b a;
  let r, g, b, a = pixel (width - 2) 1 in
  Printf.printf "top-right pixel:   r=%d g=%d b=%d a=%d\n%!" r g b a;

  F.wgpuCommandBufferRelease commands;
  F.wgpuCommandEncoderRelease encoder;
  F.wgpuBufferRelease readback;
  F.wgpuRenderPipelineRelease pipeline;
  F.wgpuShaderModuleRelease shader_module;
  F.wgpuTextureViewRelease view;
  F.wgpuTextureRelease texture;
  F.wgpuQueueRelease queue;
  F.wgpuDeviceRelease device;
  F.wgpuAdapterRelease adapter;
  F.wgpuInstanceRelease instance;
  ignore (Sys.opaque_identity !owned_strings)
