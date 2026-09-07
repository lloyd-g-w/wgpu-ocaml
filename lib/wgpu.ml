(* Entry point of the [wgpu] library.

   These are raw bindings: {!Types} and {!Fn} are generated from the vendored
   headers by [gen/gen.ml] and mirror [webgpu.h] and [wgpu.h] one for one —
   same function names, same struct fields, same enum values, same defaults.
   Nothing is hidden, nothing is invented, and there is no hand-written
   convenience layer in this library.

   {!Callback} is not convenience: ctypes frees the libffi closure behind a
   [Foreign.funptr] when the OCaml value owning it is collected, so obtaining a
   [Ctypes.static_funptr] to store in a WebGPU descriptor without rooting the
   closure is a use-after-free, and the thread registration it performs is what
   makes callbacks arriving on wgpu-native's own threads safe.  It is the only
   correct way to build one of these pointers.

   The few helpers that nearly every program needs anyway — the synchronous
   adapter/device requests, a blocking buffer read, [WGPUStringView]
   conversion — live in the separate [wgpu.utils] library ([Wgpu_utils]). *)

(** The pinned upstream release these bindings were generated from.

    @canonical Wgpu.Pin *)
module Pin = Wgpu_pin

(** Locating and opening [libwgpu_native].

    @canonical Wgpu.Loader *)
module Loader = Wgpu_loader

(** Raw types: enums, bit sets, opaque handles, structs, callback types.

    @canonical Wgpu.Types *)
module Types = Wgpu_types

(** Raw entry points, one per C function, with the C names.

    @canonical Wgpu.Fn *)
module Fn = Wgpu_fn

(** Struct layout / enum value dump used by the ABI test.

    @canonical Wgpu.Abi *)
module Abi = Wgpu_abi

(** Keeping OCaml closures alive across C calls, and the exception barrier
    every callback runs behind.

    @canonical Wgpu.Callback *)
module Callback = Wgpu_callback
