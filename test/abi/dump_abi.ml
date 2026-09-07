(* Prints the ABI that ctypes derives from the generated bindings.  test/abi
   diffs this against the same dump produced by the C compiler from the
   vendored headers. *)

let () = Wgpu.Abi.dump ()
