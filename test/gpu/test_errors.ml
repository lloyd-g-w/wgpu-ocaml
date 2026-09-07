(* WebGPU reports validation failures through the device's uncaptured-error
   callback.  The raw bindings deliver that callback and nothing more, so what
   is tested here is that it fires, that it carries the message, and that the
   device is still usable afterwards. *)

module T = Wgpu.Types
module F = Wgpu.Fn
module Check = Gpu_check

let bad_shader = "@compute @workgroup_size(1) fn main() { this is not wgsl }"
let good_shader = "@compute @workgroup_size(1) fn main() {}"

let () =
  let ((_, _, device, _) as ctx) = Check.setup ~label:"errors-test" () in
  Check.equal_int "no errors before anything ran" ~expected:0
    ~got:(List.length (Check.take_errors ()));

  (* A shader that does not compile is reported through the callback. *)
  let bad = Check.create_shader_module device ~label:"bad" bad_shader in
  (match Check.take_errors () with
  | [] -> Check.is_true "invalid WGSL is reported to the uncaptured-error callback" false
  | (ty, msg) :: _ ->
      Check.is_true "the error is a validation error" (ty = T.ErrorType.validation);
      Check.is_true "the message mentions the shader" (Check.contains msg "bad");
      print_endline ("shader error: " ^ String.sub msg 0 (min 120 (String.length msg))));
  F.wgpuShaderModuleRelease bad;

  (* The device must still be usable afterwards. *)
  let ok = Check.create_shader_module device ~label:"good" good_shader in
  Check.is_true "a valid shader still compiles" (not (T.ShaderModule.is_null ok));
  F.wgpuShaderModuleRelease ok;
  Check.equal_int "no errors are left pending" ~expected:0
    ~got:(List.length (Check.take_errors ()));

  (* An invalid buffer usage combination goes down the same path. *)
  let bad_buffer =
    Check.create_buffer device ~label:"bad-usage" ~size:64
      ~usage:T.BufferUsage.(combine [ map_read; map_write ])
  in
  (match Check.take_errors () with
  | [] -> Check.is_true "an invalid buffer usage is reported" false
  | (_, msg) :: _ ->
      Check.is_true "the message mentions validation or the usage"
        (Check.contains msg "Validation" || Check.contains msg "validation"
       || Check.contains msg "usage"));
  F.wgpuBufferRelease bad_buffer;

  (* ... and a valid buffer after it is silent. *)
  let fine =
    Check.create_buffer device ~label:"fine" ~size:64
      ~usage:T.BufferUsage.(combine [ map_read; copy_dst ])
  in
  Check.is_true "a valid buffer is created" (not (T.Buffer.is_null fine));
  Check.equal_int "a valid buffer reports nothing" ~expected:0
    ~got:(List.length (Check.take_errors ()));
  F.wgpuBufferRelease fine;

  Check.is_true "no callback raised" (Wgpu.Callback.pending_failures () = 0);
  Check.equal_int "no live callback tokens" ~expected:0
    ~got:(Wgpu.Callback.Userdata.live_count ());

  Check.teardown ctx;
  Check.finish "errors"
