# wgpu-ocaml

[![CI](https://github.com/lloyd-g-w/wgpu-ocaml/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/lloyd-g-w/wgpu-ocaml/actions/workflows/ci.yml)
[![Docs](https://github.com/lloyd-g-w/wgpu-ocaml/actions/workflows/docs.yml/badge.svg?branch=main)](https://github.com/lloyd-g-w/wgpu-ocaml/actions/workflows/docs.yml)

**Raw** OCaml bindings to **WebGPU** through
[wgpu-native](https://github.com/gfx-rs/wgpu-native), generated from the
vendored upstream headers and bound with `ctypes-foreign`.
`libwgpu_native` is loaded dynamically at run time: no C stubs are compiled,
no headers are needed at build time, and there is nothing to link.

The `wgpu` library mirrors the headers and adds nothing to them, like the other
wgpu-native bindings (WebGPU-C++, `wgpu_native_zig`, `wgpu-odin`, Silk.NET). A
separate, deliberately tiny `wgpu.utils` library holds the three helpers no
program can avoid writing.

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
| generated OCaml | ~15,500 lines |

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
**libffi**, **SDL2** (for the optional tsdl example), a C compiler, opam, make,
curl and unzip. On Linux
it also supplies the Vulkan loader and diagnostic tools, plus `xvfb-run`, an X
server and ImageMagick for running and inspecting that example headlessly; your
hardware driver still comes from the host. Use `nix develop .#software` to select Nix-provided
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

## The bindings

`Wgpu.Types` and `Wgpu.Fn` mirror `webgpu.h` and `wgpu.h` one for one — same
entry point names, same struct field spellings, same enum values, same
defaults. You build descriptors the way the C examples do, starting from the
header's `WGPU_*_INIT` defaults:

```ocaml
module T = Wgpu.Types
module F = Wgpu.Fn

let buffer =
  let desc = T.BufferDescriptor.init () in    (* the header's INIT defaults *)
  let label, keepalive = Wgpu_utils.String_view.of_string "data" in
  Ctypes.setf desc T.BufferDescriptor.label label;
  (* copy_dst is what makes wgpuQueueWriteBuffer legal *)
  Ctypes.setf desc T.BufferDescriptor.usage
    T.BufferUsage.(combine [ storage; copy_dst; copy_src ]);
  Ctypes.setf desc T.BufferDescriptor.size (Unsigned.UInt64.of_int 1024);
  let b = F.wgpuDeviceCreateBuffer device (Ctypes.addr desc) in
  (* the label view is a bare pointer into memory [keepalive] owns *)
  ignore (Sys.opaque_identity keepalive);
  b

let () = F.wgpuBufferRelease buffer
```

There is no hand-written wrapper around any of that: nothing is renamed,
nothing is hidden, and there is no coverage list to check against, because
every entry point in the pinned headers is bound.

One exception, and it is a correctness requirement rather than sugar:
**`Wgpu.Callback`** is the only correct way to obtain the
`Ctypes.static_funptr` a WebGPU descriptor wants. ctypes frees the libffi
closure behind a `Foreign.funptr` when the OCaml value owning it is collected,
so an unrooted pointer written into a descriptor is a use-after-free; and the
thread registration those closures perform is what makes a callback arriving on
one of wgpu-native's own threads safe (see [`DESIGN.md`](DESIGN.md) §5).

## `wgpu.utils`

A separate library (`Wgpu_utils`, ~200 lines) with one admission rule: a helper
belongs there only if **nearly every program has to write it anyway** and the
other wgpu-native bindings ship it too. Today that is exactly three things:

* `Sync.request_adapter` / `Sync.request_device` — wgpu-native answers both
  requests inside the call, but the handle still comes back through a C
  callback and a `userdata` pointer;
* `Buffer.map_read_sync` / `Buffer.read_bytes` — the one genuinely asynchronous
  operation every headless program performs, driven by `wgpuDevicePoll`;
* `String_view.to_string` / `String_view.of_string` — `WGPUStringView`
  conversion, both ways.

Failures are `result` values, not exceptions. There are no descriptor
builders, no error sink, no logging wrapper and no arena.

[`examples/headless_compute.ml`](examples/headless_compute.ml) and
[`examples/offscreen_render.ml`](examples/offscreen_render.ml) are complete,
runnable programs written this way, in the shape of wgpu-native's own C
examples. [`examples/sdl_window.with_tsdl.ml`](examples/sdl_window.with_tsdl.ml)
adds a window: the same triangle, presented through a `WGPUSurface` built from
an SDL2 window with [tsdl](https://github.com/dbuenzli/tsdl). `tsdl` is not a
dependency of this package — dune's `(select)` builds `sdl_window.exe` from
that file when tsdl is installed and from a one-line stub when it is not, so
`dune build` works either way. See the guide,
[Rendering to a window with tsdl](docs/GUIDE.md#rendering-to-a-window-with-tsdl).

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
* `test/gpu` runs real compute and render passes on lavapipe — through the raw
  entry points — and asserts on the numbers and pixels that come back, plus GC
  and error-handling behaviour.
* [`DESIGN.md`](DESIGN.md) is the contract between all of those — read it
  before changing any of them.

## Documentation

* [Guide](https://lloyd-g-w.github.io/wgpu-ocaml/guide.html) — installing,
  descriptors and lifetimes, compute and render walkthroughs,
  [rendering to a window with tsdl](docs/GUIDE.md#rendering-to-a-window-with-tsdl),
  callbacks and polling, errors, the loader, limitations
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

* **Raw bindings.** There is no windowing or swapchain integration, and no
  convenience wrapper for anything: you write descriptors, you own the memory
  they point at, and you release every handle yourself. The surface entry
  points are bound like everything else, and
  `examples/sdl_window.with_tsdl.ml` shows
  them driven from an SDL2 window (X11 only so far).
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
