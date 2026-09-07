# wgpu-ocaml

[![CI](https://github.com/lloyd-g-w/wgpu-ocaml/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/lloyd-g-w/wgpu-ocaml/actions/workflows/ci.yml)
[![Docs](https://github.com/lloyd-g-w/wgpu-ocaml/actions/workflows/docs.yml/badge.svg?branch=main)](https://github.com/lloyd-g-w/wgpu-ocaml/actions/workflows/docs.yml)

OCaml bindings to **WebGPU** through
[wgpu-native](https://github.com/gfx-rs/wgpu-native), generated from the
vendored upstream headers and bound with `ctypes-foreign`.
`libwgpu_native` is loaded dynamically at run time: no C stubs are compiled,
no headers are needed at build time, and there is nothing to link.

**[Guide](https://lloyd-g-w.github.io/wgpu-ocaml/guide.html)** ·
**[API reference](https://lloyd-g-w.github.io/wgpu-ocaml/api/wgpu/index.html)** ·
**[Design contract](https://lloyd-g-w.github.io/wgpu-ocaml/design.html)**

> **This project was written entirely by AI.** Every original file in this
> repository — the code generator, the runtime, the generated bindings, the
> tests, the examples, the CI workflows, this README and this notice — was
> produced by AI agents, with no hand-written human code. The only files that
> are not AI-authored are the vendored third-party ones under `vendor/`, which
> are copied verbatim from upstream and keep their own licences
> (see [`vendor/wgpu-native/PROVENANCE.md`](vendor/wgpu-native/PROVENANCE.md)).
> Read [Authorship](#authorship) before you depend on this.

## Status

Works, tested, and **not released**: no opam release, no tagged version, no
licence chosen yet (see [Licensing](#licensing)).

Pinned to **wgpu-native v29.0.1.1** (commit `6aed5095`, `webgpu-headers`
`673658bc`), built with **OCaml 5.5.1** (minimum **5.2.0**, which CI also
tests), `ctypes` / `ctypes-foreign` 0.24.
Developed and tested on Linux x86_64 against Mesa's **lavapipe** software
rasteriser, headless. No other platform has been executed
(see [Limitations](#limitations)).

| generated surface | count |
|---|---:|
| entry points (`Wgpu.Fn`) | 228 |
| structs (incl. 1 anonymous union) | 114 |
| enums / bit sets | 70 / 8 |
| enum and bit-set constants | 643 |
| opaque handles | 23 |
| function-pointer typedefs | 214 |
| `WGPU_*_INIT` default sets | 92 |
| generated OCaml | ~15,300 lines |

That surface is checked by the test suite rather than asserted here (the line
count is just `wc -l`): `dune test` rescans the headers with an independent
scanner and requires *set equality* for entry points, structs, handles, enums
and `WGPU_*_INIT` macros, then diffs a 1914-line ABI dump produced by a C probe
compiled from the vendored headers against the same dump computed from the
OCaml bindings — struct sizes, field offsets, enum and bit-set values,
sentinels and defaults.

## Quick start

```sh
git clone https://github.com/lloyd-g-w/wgpu-ocaml
cd wgpu-ocaml

# 1. an OCaml 5.5.1 switch with the two runtime dependencies
opam switch create . ocaml-base-compiler.5.5.1 --no-install
eval $(opam env)
opam install dune ctypes ctypes-foreign        # needs libffi-dev + pkg-config

# 2. the pinned, checksummed wgpu-native shared library
dune exec scripts/fetch_wgpu_native.exe

# 3. build and test
dune build
dune test                                      # unit + ABI checks, no GPU needed
dune build @gpu                                # the tests that need an adapter
dune exec examples/headless_compute.exe
dune exec examples/offscreen_render.exe
```

On a machine with no GPU, install `mesa-vulkan-drivers` and run the GPU tests
and examples with
`VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.json`; that is exactly what
CI does. If you cannot install system packages, `scripts/no-root-deps.sh` sets
up `libffi` and `pkg-config` in a throw-away prefix.

To use the bindings from another project before there is an opam release:
`opam pin add wgpu https://github.com/lloyd-g-w/wgpu-ocaml.git` — but read
[Licensing](#licensing) first. This also works from an
[OxCaml](https://oxcaml.org) switch (`5.2.0+ox`), since the package only
requires OCaml ≥ 5.2.0; see the [guide](docs/GUIDE.md#oxcaml) for the caveats.

### Nix / NixOS

`nix develop` supplies the system dependencies: **pkgconf**, **pkg-config**,
**libffi**, a C compiler, opam, make, curl and unzip. On Linux
it also supplies the Vulkan loader and diagnostic tools; your hardware driver
still comes from the host. Use `nix develop .#software` to select Nix-provided
Mesa lavapipe instead, with no physical GPU needed.

Inside either shell, create the OCaml 5.5.1 switch as above, then run:

```sh
opam install . --deps-only --with-test --with-doc --assume-depexts
dune exec scripts/fetch_wgpu_native.exe
dune build @runtest @gpu
```

`--assume-depexts` tells opam that Nix already supplies the system libraries.
The flake does not install a different OCaml or wgpu-native version: those
remain managed by opam and our pinned downloader. See the
[Nix guide](docs/GUIDE.md#nix--nixos) for first-time setup.

## Two layers

**The raw layer** mirrors `webgpu.h` and `wgpu.h` one for one — same entry
point names, same struct field spellings, same enum values, same defaults:

```ocaml
let desc = Wgpu.Types.BufferDescriptor.init () in    (* the header's INIT defaults *)
Ctypes.setf desc Wgpu.Types.BufferDescriptor.usage
  Wgpu.Types.BufferUsage.(combine [ storage; copy_src ]);
Ctypes.setf desc Wgpu.Types.BufferDescriptor.size (Unsigned.UInt64.of_int 1024);
let buffer = Wgpu.Fn.wgpuDeviceCreateBuffer device (Ctypes.addr desc)
```

**The ergonomic layer** is small, hand written, and owns lifetimes explicitly:

```ocaml
open Wgpu

let () =
  let instance = Instance.create () in
  let adapter = Instance.request_adapter instance in
  let device = Adapter.request_device ~label:"demo" adapter in
  let queue = Device.queue device in
  let buffer =
    Device.create_buffer device ~label:"data" ~size:1024
      (* copy_dst is what makes Queue.write_buffer legal *)
      ~usage:Types.BufferUsage.(combine [ storage; copy_dst; copy_src ])
  in
  Queue.write_buffer queue buffer (Bytes.make 1024 '\000');
  (* ... *)
  Buffer.release buffer;
  Queue.release queue;
  Device.release device;
  Adapter.release adapter;
  Instance.release instance
```

Both layers share the same handle types, so you can mix them freely: anything
the ergonomic layer does not cover (surfaces, render bundles, query sets,
samplers, …) is one `Wgpu.Fn.*` call away. The
[guide](https://lloyd-g-w.github.io/wgpu-ocaml/guide.html) walks through both,
and [`DESIGN.md`](DESIGN.md) §9 lists exactly what is and is not covered.

[`examples/headless_compute.ml`](examples/headless_compute.ml) and
[`examples/offscreen_render.ml`](examples/offscreen_render.ml) are complete,
runnable versions of both.

## How it is built

* `vendor/wgpu-native/` holds the two upstream headers verbatim, their
  licences, and `pin.txt` — the single source of truth for the pinned version,
  the release checksums and the list of entry points wgpu-native leaves
  unimplemented.
* `gen/` is a deterministic generator written in OCaml (stdlib only). It has a
  strict parser for the C subset the headers use and **aborts on anything it
  does not recognise**, so a header bump can never silently drop a
  declaration. Its output is committed under `lib/generated/`;
  `dune build @gen` proves the committed files match the generator.
* Correctness is checked against the real ABI, not assumed: `test/abi`
  compiles a generated C probe against the vendored headers and diffs its
  1914-line dump of struct sizes, field offsets, enum values, sentinels and
  `WGPU_*_INIT` defaults against what `ctypes` computes from the generated
  bindings.
* `test/unit` re-scans the headers with an independent scanner and requires
  the generated surface to match it exactly.
* `test/gpu` runs real compute and render passes on lavapipe and asserts on
  the numbers and pixels that come back, plus GC and error-handling behaviour.
* [`DESIGN.md`](DESIGN.md) is the contract between all of those — read it
  before changing any of them.

## Documentation

* [Guide](https://lloyd-g-w.github.io/wgpu-ocaml/guide.html) — installing,
  the two layers, lifetimes, compute and render walkthroughs, callbacks and
  polling, errors, the loader, limitations
  ([source](docs/GUIDE.md)).
* [API reference](https://lloyd-g-w.github.io/wgpu-ocaml/api/wgpu/index.html) —
  odoc, generated from the sources.
* [Design contract](https://lloyd-g-w.github.io/wgpu-ocaml/design.html) —
  ([source](DESIGN.md)).

The site is assembled by [`doc/site/build_site.ml`](doc/site/build_site.ml)
(OCaml, stdlib only) plus `odoc`, and published by the `Docs` workflow:

```sh
dune build @doc
dune exec doc/site/build_site.exe -- --out _site
```

## Limitations

* **Ergonomic layer only.** Surfaces/swapchains and windowing, render bundles,
  query sets and timestamps, samplers, vertex buffer layouts, depth/stencil
  and blend state, explicit pipeline layouts, SPIR-V shaders, immediates,
  multi-draw, external textures and Metal interop are *not* wrapped. They are
  all bound in `Wgpu.Fn` and usable on the same handles.
* **Unusable in wgpu-native v29 regardless of these bindings**: `WGPUFuture` /
  `wgpuInstanceWaitAny` (asynchronous work is driven by polling instead),
  `wgpuGetProcAddress`, and the 35 entry points listed as `unimplemented` in
  `pin.txt`, which abort the process when called. They are bound so callers
  can see them, and `Wgpu.Pin.unimplemented` lists them at run time.
* **One pin.** These bindings target wgpu-native v29.0.1.1 only; the loader's
  version gate refuses another version unless
  `WGPU_OCAML_ALLOW_VERSION_MISMATCH=1`.
* **Platforms.** Only Linux x86_64 with lavapipe has been executed. The pin
  carries checksums for linux-aarch64, macos-x86_64, macos-aarch64 and
  windows-x86_64, and the loader knows their file names, but none of them has
  been run. 64-bit only.
* **Concurrency.** Callbacks may arrive on threads wgpu-native owns (its log
  sink is process-global and `webgpu.h` documents the uncaptured-error
  callback as "any thread"), and the bindings support that: entry points
  release the OCaml domain lock, closures register the calling thread and take
  the lock, and shared state is behind a mutex. What is *not* supported is
  driving wgpu from several **domains** — registered foreign threads attach to
  domain 0. See [`DESIGN.md`](DESIGN.md) §5.1.
* **Test gap.** The ABI diff proves layout, enum values, sentinels and
  defaults; it does not prove type-level equality or entry-point signatures
  (`DESIGN.md` §7.1).

## Authorship

Every original file here was written by AI agents. That means:

* No human wrote or reviewed line-by-line the generator, the runtime, the
  generated bindings, the tests, the examples, the CI workflows or the
  documentation.
* The claims in this README, in the guide and in `DESIGN.md` were checked by
  running the commands they describe on Linux x86_64 with lavapipe, and the
  counts come from the test suite; they have not been checked on any other
  platform.
* Bugs of the kind AI code review is bad at catching (subtle lifetime,
  aliasing or threading mistakes across the FFI boundary) are the most likely
  residual risk. `DESIGN.md` §5 records the reasoning behind the callback and
  threading model in full so that a human can audit the decision rather than
  the diff.

## Licensing

**No licence has been chosen for the original code in this repository yet.**
Until the owner picks one, treat this repository as all-rights-reserved: there
is deliberately no `LICENSE` file and no `license:` field in `wgpu.opam`.

The vendored third-party material is a separate matter and is already
licensed: `vendor/wgpu-native/include/webgpu/webgpu.h` is BSD-3-Clause,
`vendor/wgpu-native/include/webgpu/wgpu.h` is MIT OR Apache-2.0, and the
`unimplemented` list in `pin.txt` is derived from MIT OR Apache-2.0 sources.
Their notices are in `vendor/wgpu-native/licenses/` and must be preserved
whatever licence is chosen for the rest.
