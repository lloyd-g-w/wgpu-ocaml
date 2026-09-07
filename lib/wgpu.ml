(* Entry point of the [wgpu] library.

   The library is split in two layers:

   - the *raw* layer ({!Types}, {!Fn}), generated from the vendored headers by
     [gen/gen.ml].  It mirrors [webgpu.h] and [wgpu.h] one-for-one: same
     function names, same struct fields, same enum values.  Nothing is
     hidden and nothing is invented.
   - a small *ergonomic* layer (everything else in this module), hand written
     on top of the raw layer.  It owns lifetimes explicitly (every [create]
     has a matching [release]), turns WebGPU errors into OCaml exceptions and
     converts strings, lists and options for the descriptors that examples and
     tests actually need.

   Anything the ergonomic layer does not cover is reachable through {!Fn}. *)

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

include Wgpu_api
