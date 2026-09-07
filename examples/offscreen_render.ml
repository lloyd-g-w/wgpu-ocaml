(* Offscreen render: draw a triangle into an RGBA8 texture, copy it back and
   print an ASCII view of the result.  No window, no surface, no swapchain.

   Run with:  dune exec examples/offscreen_render.exe *)

open Wgpu

let width = 32
let height = 32

(* One row of a texture-to-buffer copy must be a multiple of 256 bytes. *)
let bytes_per_row = ((width * 4) + 255) / 256 * 256

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
  Log.to_stderr ~level:Types.LogLevel.error ();
  let instance = Instance.create () in
  let adapter = Instance.request_adapter instance in
  Printf.printf "adapter: %s\n%!" (Adapter.string_of_info (Adapter.info adapter));
  let device = Adapter.request_device ~label:"offscreen-render" adapter in
  let queue = Device.queue device in

  let format = Types.TextureFormat.rgba8_unorm in
  let texture =
    Device.create_texture device ~label:"target" ~format ~width ~height
      ~usage:Types.TextureUsage.(combine [ render_attachment; copy_src ])
  in
  let view = Texture.create_view texture ~label:"target-view" in

  let module_ = Device.create_shader_module_wgsl device ~label:"triangle" shader in
  let pipeline =
    Device.create_render_pipeline device ~label:"triangle" ~shader_module:module_
      ~targets:[ { Device.format; write_mask = Types.ColorWriteMask.all } ]
  in

  let size = bytes_per_row * height in
  let readback =
    Device.create_buffer device ~label:"readback" ~size
      ~usage:Types.BufferUsage.(combine [ map_read; copy_dst ])
  in

  let encoder = Device.create_command_encoder device ~label:"render" in
  let pass =
    Command_encoder.begin_render_pass encoder ~label:"triangle"
      ~color_attachments:
        [ { Command_encoder.view;
            load = Types.LoadOp.clear;
            store = Types.StoreOp.store;
            clear = (0.0, 0.0, 1.0, 1.0) } ]
  in
  Render_pass.set_pipeline pass pipeline;
  Render_pass.draw pass ~vertex_count:3;
  Render_pass.finish pass;
  Render_pass.release pass;
  Command_encoder.copy_texture_to_buffer encoder ~texture ~buffer:readback ~bytes_per_row
    ~rows_per_image:height ~width ~height ();
  let commands = Command_encoder.finish encoder ~label:"render" in
  Queue.submit queue [ commands ];
  Device.check device;

  let pixels = Buffer.read_sync ~device readback ~offset:0 ~size in
  let pixel x y =
    let o = (y * bytes_per_row) + (x * 4) in
    (Char.code (Bytes.get pixels o), Char.code (Bytes.get pixels (o + 1)),
     Char.code (Bytes.get pixels (o + 2)), Char.code (Bytes.get pixels (o + 3)))
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

  Command_buffer.release commands;
  Command_encoder.release encoder;
  Buffer.release readback;
  Render_pipeline.release pipeline;
  Shader_module.release module_;
  Texture.release_view view;
  Texture.release texture;
  Queue.release queue;
  Device.release device;
  Adapter.release adapter;
  Instance.release instance
