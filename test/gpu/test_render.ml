(* An offscreen render pass with exact pixel assertions. *)

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
  let ((_, _, device, queue) as ctx) = Gpu_check.setup ~label:"render-test" () in
  let format = Wgpu.Types.TextureFormat.rgba8_unorm in
  let texture =
    Wgpu.Device.create_texture device ~label:"target" ~format ~width ~height
      ~usage:Wgpu.Types.TextureUsage.(combine [ render_attachment; copy_src ])
  in
  let view = Wgpu.Texture.create_view texture in
  let module_ = Wgpu.Device.create_shader_module_wgsl device ~label:"triangle" shader in
  let pipeline =
    Wgpu.Device.create_render_pipeline device ~label:"triangle" ~shader_module:module_
      ~targets:[ { Wgpu.Device.format; write_mask = Wgpu.Types.ColorWriteMask.all } ]
  in
  let size = bytes_per_row * height in
  let readback =
    Wgpu.Device.create_buffer device ~label:"readback" ~size
      ~usage:Wgpu.Types.BufferUsage.(combine [ map_read; copy_dst ])
  in

  let encoder = Wgpu.Device.create_command_encoder device in
  let pass =
    Wgpu.Command_encoder.begin_render_pass encoder ~label:"triangle"
      ~color_attachments:
        [ { Wgpu.Command_encoder.view;
            load = Wgpu.Types.LoadOp.clear;
            store = Wgpu.Types.StoreOp.store;
            clear = (0.0, 0.0, 1.0, 1.0) } ]
  in
  Wgpu.Render_pass.set_pipeline pass pipeline;
  Wgpu.Render_pass.draw pass ~vertex_count:3;
  Wgpu.Render_pass.finish pass;
  Wgpu.Render_pass.release pass;
  Wgpu.Command_encoder.copy_texture_to_buffer encoder ~texture ~buffer:readback ~bytes_per_row
    ~rows_per_image:height ~width ~height ();
  let commands = Wgpu.Command_encoder.finish encoder in
  Wgpu.Queue.submit queue [ commands ];
  Wgpu.Device.check device;

  let pixels = Wgpu.Buffer.read_sync ~device readback ~offset:0 ~size in
  Gpu_check.equal_int "readback size" ~expected:size ~got:(Bytes.length pixels);
  let pixel x y =
    let o = (y * bytes_per_row) + (x * 4) in
    let c i = Char.code (Bytes.get pixels (o + i)) in
    (c 0, c 1, c 2, c 3)
  in
  (* The triangle covers the lower-left half; the rest keeps the clear colour. *)
  let r, g, b, a = pixel 0 (height - 1) in
  Gpu_check.equal_int "bottom-left red" ~expected:255 ~got:r;
  Gpu_check.equal_int "bottom-left green" ~expected:0 ~got:g;
  Gpu_check.equal_int "bottom-left blue" ~expected:0 ~got:b;
  Gpu_check.equal_int "bottom-left alpha" ~expected:255 ~got:a;
  let r, g, b, a = pixel (width - 1) 0 in
  Gpu_check.equal_int "top-right red" ~expected:0 ~got:r;
  Gpu_check.equal_int "top-right green" ~expected:0 ~got:g;
  Gpu_check.equal_int "top-right blue" ~expected:255 ~got:b;
  Gpu_check.equal_int "top-right alpha" ~expected:255 ~got:a;
  (* Count the covered pixels: the diagonal splits the square in half. *)
  let covered = ref 0 in
  for y = 0 to height - 1 do
    for x = 0 to width - 1 do
      let r, _, _, _ = pixel x y in
      if r > 127 then incr covered
    done
  done;
  Gpu_check.is_true
    (Printf.sprintf "about half the pixels are covered (%d of %d)" !covered (width * height))
    (!covered > width * height / 3 && !covered < width * height * 2 / 3);

  Wgpu.Command_buffer.release commands;
  Wgpu.Command_encoder.release encoder;
  Wgpu.Buffer.release readback;
  Wgpu.Render_pipeline.release pipeline;
  Wgpu.Shader_module.release module_;
  Wgpu.Texture.release_view view;
  Wgpu.Texture.release texture;
  Gpu_check.teardown ctx;
  Gpu_check.finish "render"
