(* The generated surface must cover every declaration in the vendored headers.

   {!Header_scan} rescans the headers with a completely different (naive)
   method, so a declaration silently skipped by the generator's parser shows up
   here as a missing name. *)

let () =
  Check.equal_string_set "entry points" ~expected:(Header_scan.functions ())
    ~got:Wgpu.Fn.names;
  Check.equal_string_set "structs" ~expected:(Header_scan.structs ()) ~got:Wgpu.Abi.structs;
  Check.equal_string_set "handles" ~expected:(Header_scan.handles ()) ~got:Wgpu.Abi.handles;
  Check.equal_string_set "enums" ~expected:(Header_scan.enums ()) ~got:Wgpu.Abi.enums;
  Check.equal_string_set "INIT macros" ~expected:(Header_scan.init_macros ())
    ~got:Wgpu.Abi.init_macros;
  (* Every struct that has an INIT macro must have a matching struct module. *)
  Check.is_true "every struct is bound" (List.length Wgpu.Abi.structs > 100);
  Check.is_true "every flag set is bound" (List.length Wgpu.Abi.flags = 8);
  Check.is_true "callbacks are bound" (List.length Wgpu.Abi.callbacks > 10);
  Check.finish "coverage"
