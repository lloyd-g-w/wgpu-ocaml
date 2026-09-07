(* An offscreen render pass with exact pixel assertions, built from raw
   descriptors. *)

module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils
module Check = Gpu_check

let width = 16
let height = 16
let bytes_per_row = 256 (* 16 * 4 rounded up to the 256-byte copy alignment *)

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

let () =
  let ((_, _, device, queue) as ctx) = Check.setup ~label:"render-test" () in
  let format = T.TextureFormat.rgba8_unorm in

  let extent = T.Extent3D.init () in
  Ctypes.setf extent T.Extent3D.width (Check.u32 width);
  Ctypes.setf extent T.Extent3D.height (Check.u32 height);
  Ctypes.setf extent T.Extent3D.depthOrArrayLayers (Check.u32 1);
  let texture_desc = T.TextureDescriptor.init () in
  Ctypes.setf texture_desc T.TextureDescriptor.label (Check.sv "target");
  Ctypes.setf texture_desc T.TextureDescriptor.usage
    T.TextureUsage.(combine [ render_attachment; copy_src ]);
  Ctypes.setf texture_desc T.TextureDescriptor.dimension T.TextureDimension.v2_d;
  Ctypes.setf texture_desc T.TextureDescriptor.format format;
  Ctypes.setf texture_desc T.TextureDescriptor.size extent;
  Ctypes.setf texture_desc T.TextureDescriptor.mipLevelCount (Check.u32 1);
  Ctypes.setf texture_desc T.TextureDescriptor.sampleCount (Check.u32 1);
  let texture = F.wgpuDeviceCreateTexture device (Ctypes.addr texture_desc) in
  let view_desc = T.TextureViewDescriptor.init () in
  let view = F.wgpuTextureCreateView texture (Ctypes.addr view_desc) in

  let module_ = Check.create_shader_module device ~label:"triangle" shader in
  let target = T.ColorTargetState.init () in
  Ctypes.setf target T.ColorTargetState.format format;
  Ctypes.setf target T.ColorTargetState.writeMask T.ColorWriteMask.all;
  let fragment = T.FragmentState.init () in
  Ctypes.setf fragment T.FragmentState.module_ module_;
  Ctypes.setf fragment T.FragmentState.entryPoint (Check.sv "fs_main");
  Ctypes.setf fragment T.FragmentState.targetCount (Check.sz 1);
  Ctypes.setf fragment T.FragmentState.targets (Ctypes.addr target);
  let vertex = T.VertexState.init () in
  Ctypes.setf vertex T.VertexState.module_ module_;
  Ctypes.setf vertex T.VertexState.entryPoint (Check.sv "vs_main");
  let primitive = T.PrimitiveState.init () in
  Ctypes.setf primitive T.PrimitiveState.topology T.PrimitiveTopology.triangle_list;
  let multisample = T.MultisampleState.init () in
  Ctypes.setf multisample T.MultisampleState.count (Check.u32 1);
  let pipeline_desc = T.RenderPipelineDescriptor.init () in
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.label (Check.sv "triangle");
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.vertex vertex;
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.primitive primitive;
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.multisample multisample;
  Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.fragment (Ctypes.addr fragment);
  let pipeline = F.wgpuDeviceCreateRenderPipeline device (Ctypes.addr pipeline_desc) in
  ignore (Sys.opaque_identity (fragment, target));
  Check.is_true "the pipeline was created" (not (T.RenderPipeline.is_null pipeline));

  let size = bytes_per_row * height in
  let readback =
    Check.create_buffer device ~label:"readback" ~size
      ~usage:T.BufferUsage.(combine [ map_read; copy_dst ])
  in

  let encoder_desc = T.CommandEncoderDescriptor.init () in
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
  Ctypes.setf pass_desc T.RenderPassDescriptor.label (Check.sv "triangle");
  Ctypes.setf pass_desc T.RenderPassDescriptor.colorAttachmentCount (Check.sz 1);
  Ctypes.setf pass_desc T.RenderPassDescriptor.colorAttachments (Ctypes.addr attachment);
  let pass = F.wgpuCommandEncoderBeginRenderPass encoder (Ctypes.addr pass_desc) in
  ignore (Sys.opaque_identity attachment);
  F.wgpuRenderPassEncoderSetPipeline pass pipeline;
  F.wgpuRenderPassEncoderDraw pass (Check.u32 3) (Check.u32 1) (Check.u32 0) (Check.u32 0);
  F.wgpuRenderPassEncoderEnd pass;
  F.wgpuRenderPassEncoderRelease pass;

  let copy_src = T.TexelCopyTextureInfo.init () in
  Ctypes.setf copy_src T.TexelCopyTextureInfo.texture texture;
  let layout = T.TexelCopyBufferLayout.init () in
  Ctypes.setf layout T.TexelCopyBufferLayout.bytesPerRow (Check.u32 bytes_per_row);
  Ctypes.setf layout T.TexelCopyBufferLayout.rowsPerImage (Check.u32 height);
  let copy_dst = T.TexelCopyBufferInfo.init () in
  Ctypes.setf copy_dst T.TexelCopyBufferInfo.buffer readback;
  Ctypes.setf copy_dst T.TexelCopyBufferInfo.layout layout;
  F.wgpuCommandEncoderCopyTextureToBuffer encoder (Ctypes.addr copy_src) (Ctypes.addr copy_dst)
    (Ctypes.addr extent);
  let commands_desc = T.CommandBufferDescriptor.init () in
  let commands = F.wgpuCommandEncoderFinish encoder (Ctypes.addr commands_desc) in
  Check.submit queue commands;

  let pixels =
    match U.Buffer.read_bytes device readback ~offset:0 ~size with
    | Ok b -> b
    | Error (s, m) ->
        Check.is_true
          (Printf.sprintf "readback failed: %s (%s)" (T.MapAsyncStatus.to_string s) m)
          false;
        Bytes.make size '\000'
  in
  Check.equal_int "readback size" ~expected:size ~got:(Bytes.length pixels);
  let pixel x y =
    let o = (y * bytes_per_row) + (x * 4) in
    let c i = Char.code (Bytes.get pixels (o + i)) in
    (c 0, c 1, c 2, c 3)
  in
  (* The triangle covers the lower-left half; the rest keeps the clear colour. *)
  let r, g, b, a = pixel 0 (height - 1) in
  Check.equal_int "bottom-left red" ~expected:255 ~got:r;
  Check.equal_int "bottom-left green" ~expected:0 ~got:g;
  Check.equal_int "bottom-left blue" ~expected:0 ~got:b;
  Check.equal_int "bottom-left alpha" ~expected:255 ~got:a;
  let r, g, b, a = pixel (width - 1) 0 in
  Check.equal_int "top-right red" ~expected:0 ~got:r;
  Check.equal_int "top-right green" ~expected:0 ~got:g;
  Check.equal_int "top-right blue" ~expected:255 ~got:b;
  Check.equal_int "top-right alpha" ~expected:255 ~got:a;
  (* Count the covered pixels: the diagonal splits the square in half. *)
  let covered = ref 0 in
  for y = 0 to height - 1 do
    for x = 0 to width - 1 do
      let r, _, _, _ = pixel x y in
      if r > 127 then incr covered
    done
  done;
  Check.is_true
    (Printf.sprintf "about half the pixels are covered (%d of %d)" !covered (width * height))
    (!covered > width * height / 3 && !covered < width * height * 2 / 3);
  Check.equal_int "the device reported no errors" ~expected:0
    ~got:(List.length (Check.take_errors ()));

  F.wgpuCommandBufferRelease commands;
  F.wgpuCommandEncoderRelease encoder;
  F.wgpuBufferRelease readback;
  F.wgpuRenderPipelineRelease pipeline;
  F.wgpuShaderModuleRelease module_;
  F.wgpuTextureViewRelease view;
  F.wgpuTextureRelease texture;
  Check.teardown ctx;
  Check.finish "render"
