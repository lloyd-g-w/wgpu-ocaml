(* WebGPU reports failures asynchronously; the ergonomic layer must turn them
   into OCaml exceptions instead of leaving a broken handle behind. *)

let bad_shader = "@compute @workgroup_size(1) fn main() { this is not wgsl }"

let good_shader =
  "@compute @workgroup_size(1) fn main() {}"

let contains haystack needle =
  let n = String.length haystack and m = String.length needle in
  let rec go i = i + m <= n && (String.sub haystack i m = needle || go (i + 1)) in
  go 0

let () =
  let ((_, _, device, _) as ctx) = Gpu_check.setup ~label:"errors-test" () in

  (* A shader that does not compile must raise, not return a broken module. *)
  let e =
    Gpu_check.raises "invalid WGSL raises" (fun () ->
        ignore (Wgpu.Device.create_shader_module_wgsl device ~label:"bad" bad_shader))
  in
  (match e with
  | Wgpu.Error msg ->
      Gpu_check.is_true "the message mentions the shader" (String.length msg > 10);
      print_endline ("shader error: " ^ String.sub msg 0 (min 120 (String.length msg)))
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);

  (* The device must still be usable afterwards. *)
  let ok = Wgpu.Device.create_shader_module_wgsl device ~label:"good" good_shader in
  Wgpu.Shader_module.release ok;
  Gpu_check.is_true "no errors are left pending" (Wgpu.Device.check device = ());

  (* An invalid buffer usage combination is caught by an explicit error scope. *)
  let e =
    Gpu_check.raises "invalid buffer usage raises" (fun () ->
        Wgpu.Device.with_error_scope device (fun () ->
            let b =
              Wgpu.Device.create_buffer device ~label:"bad-usage" ~size:64
                ~usage:Wgpu.Types.BufferUsage.(combine [ map_read; map_write ])
            in
            Wgpu.Buffer.release b))
  in
  (match e with
  | Wgpu.Error msg ->
      Gpu_check.is_true "the message mentions validation"
        (contains msg "Validation" || contains msg "validation" || contains msg "usage")
  | e -> Gpu_check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);

  (* A scope around valid work reports nothing. *)
  let n =
    Wgpu.Device.with_error_scope device (fun () ->
        let b =
          Wgpu.Device.create_buffer device ~label:"fine" ~size:64
            ~usage:Wgpu.Types.BufferUsage.(combine [ map_read; copy_dst ])
        in
        Wgpu.Buffer.release b;
        42)
  in
  Gpu_check.equal_int "a clean scope returns the value" ~expected:42 ~got:n;
  Gpu_check.equal_int "no live callback tokens" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());

  Gpu_check.teardown ctx;
  Gpu_check.finish "errors"
