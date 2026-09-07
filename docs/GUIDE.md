# wgpu-ocaml guide

A practical, example-driven tour of the bindings: how to install the native
library, what the raw surface looks like, and how to write headless compute and
offscreen rendering with it. [`DESIGN.md`](../DESIGN.md) is the authoritative
*contract* between the generator, the runtime and the tests; this guide is the
reader-friendly walkthrough of the same material.

These are **raw bindings**. `Wgpu.Types` and `Wgpu.Fn` mirror `webgpu.h` and
`wgpu.h` and add nothing to them; the three helpers no program can avoid
writing live in a separate `wgpu.utils` library. There is no ergonomic
wrapper, so there is also no coverage list to check your idea against.

> **Note:** this guide, like every other original file in this repository, was
> written by AI agents — see
> [Authorship in the README](../README.md#authorship). Every snippet below was
> compiled against the library in this repository as it was written, and every
> claim about the generated surface was read out of `lib/generated/`; but no
> human reviewed it line by line.

Runnable versions of the two big examples are
[`examples/headless_compute.ml`](../examples/headless_compute.ml) and
[`examples/offscreen_render.ml`](../examples/offscreen_render.ml). The API
reference is at
<https://lloyd-g-w.github.io/wgpu-ocaml/api/wgpu/index.html>.

## What you need

| what | which |
|---|---|
| OCaml | **5.5.1** (what the project is developed and tested with); **5.2.0** is the minimum, and CI builds and tests it too |
| opam packages | `dune` (≥ 3.20), `ctypes` and `ctypes-foreign` (≥ 0.23; 0.24 is what is used here) |
| system packages | `libffi-dev` and `pkg-config` — for building `ctypes-foreign`, not for these bindings |
| at run time | `libwgpu_native` **v29.0.1.1**, and a Vulkan / Metal / DX12 adapter |
| for `dune test` | a C compiler (the ABI probe); no GPU, no `libwgpu_native` |

There is no C code to compile in this project, no header to find at build time
and nothing to link: `libwgpu_native` is opened with `dlopen` the first time
you call an entry point.

## Installing

```sh
git clone https://github.com/lloyd-g-w/wgpu-ocaml
cd wgpu-ocaml

# 1. a switch with the runtime dependencies
opam switch create . ocaml-base-compiler.5.5.1 --no-install
eval $(opam env)
opam install dune ctypes ctypes-foreign

# 2. the pinned, checksummed native library
dune exec scripts/fetch_wgpu_native.exe

# 3. build and test
dune build
dune test            # unit checks + the ABI diff; no GPU needed
dune build @gpu      # the tests that need an adapter
```

`scripts/fetch_wgpu_native.exe` reads the pin in
[`vendor/wgpu-native/pin.txt`](../vendor/wgpu-native/pin.txt), downloads the
official release archive for your platform with `curl`, checks its SHA-256
against the pin, refuses to install on a mismatch, and unpacks it into
`~/.cache/wgpu-ocaml/wgpu-native-29.0.1.1/lib/` — which is exactly where the
loader looks. It prints what it did:

```
sha256 ok: 95a4d90c071005a98d03eab348beaa6b07e16eb00d1dcdb9f8348f75eb97ec5a
installed /home/you/.cache/wgpu-ocaml/wgpu-native-29.0.1.1/lib/libwgpu_native.so
```

`--platform linux-aarch64` (or `macos-aarch64`, `macos-x86_64`,
`windows-x86_64`) overrides the auto-detected platform, and `--force`
re-downloads. Only platforms listed in the pin can be installed.

If you already have a build of wgpu-native, point the loader at it instead:

```sh
export WGPU_NATIVE_LIB=/path/to/libwgpu_native.so      # a file, authoritative
export WGPU_NATIVE_LIB_DIR=/path/to/lib                # a directory, authoritative
```

On a machine without a GPU, install Mesa's software rasteriser
(`mesa-vulkan-drivers` on Debian/Ubuntu) and select it explicitly:

```sh
export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.json
```

That is how everything in this repository is tested. If you cannot install
system packages at all, `scripts/no-root-deps.sh` sets up `libffi` and
`pkg-config` in a throw-away prefix under `/tmp`.

### Nix / NixOS

The repository's `flake.nix` and committed `flake.lock` provide a reproducible
**system-dependency shell**, not a Nix build of the OCaml package. It includes
both `pkgconf` and `pkg-config`, `libffi` and its development headers, a C
compiler, make, opam, git, curl and unzip. OCaml and its packages
are deliberately left to opam so the compiler stays at **5.5.1** regardless of
which OCaml version nixpkgs carries. The pinned downloader still installs
wgpu-native; nixpkgs' potentially incompatible version is not used.

From the cloned repository:

```sh
nix develop                 # host GPU drivers; Linux or macOS
# Or, on Linux, use Mesa lavapipe with no GPU or host graphics driver:
# nix develop .#software

# On first use of opam only:
opam init --bare --no-setup

# Create the switch INSIDE the Nix shell, not with a different system compiler:
opam switch create . ocaml-base-compiler.5.5.1 --no-install
eval "$(opam env)"
opam install . --deps-only --with-test --with-doc --assume-depexts

dune exec scripts/fetch_wgpu_native.exe
dune build @runtest @gpu
dune exec examples/headless_compute.exe
```

If you already created the switch inside this shell, skip `opam init` and
`opam switch create` on subsequent visits; enter `nix develop` and run
`eval "$(opam env)"` again. `--assume-depexts` avoids asking opam to install
system packages outside Nix. You can verify the critical dependency with
`pkg-config --modversion libffi`.

On Linux the default shell exposes the Nix Vulkan loader through
`LD_LIBRARY_PATH` and includes `/run/opengl-driver/lib` for NixOS host drivers.
It does **not** install or select your hardware driver; on NixOS that is a
system configuration concern (`hardware.graphics.enable` and the appropriate
driver). The `software` shell instead selects the Nix Mesa lavapipe ICD using
both `VK_DRIVER_FILES` and `VK_ICD_FILENAMES`, avoiding hard-coded `/usr/share`
paths. macOS uses the system Metal backend; there is no `software` shell there.
Flake outputs cover x86_64/aarch64 Linux and macOS, but only Linux x86_64 is
runtime-tested by this project.

If flakes are not enabled in your Nix configuration, use
`nix --extra-experimental-features 'nix-command flakes' develop` (and append
`.#software` when desired).

### Using it from your own project

The package is not released to opam. Until it is, pin the repository:

```sh
opam pin add wgpu https://github.com/lloyd-g-w/wgpu-ocaml.git
```

and depend on it from your `dune-project`/`dune` as `wgpu`. Read
[Licensing](../README.md#licensing) first: no licence has been chosen for the
original code yet, so the repository is all-rights-reserved for now.

### OxCaml

[OxCaml](https://oxcaml.org) switches (`5.2.0+ox`) report `ocaml` as 5.2.0,
and the package's constraint is `ocaml >= 5.2.0` precisely so that the same
`opam pin add wgpu …` works there. The bindings use no language feature newer
than 5.2, and the full suite (unit, ABI and GPU) passes on a plain 5.2.0
switch.

What has **not** been done is running the suite under OxCaml itself. Two
things to know:

* `ctypes`, `ctypes-foreign` and `integers` must install in your ox switch.
  They come from the default opam repository, which the OxCaml switch also
  uses; if OxCaml's repository carries a patched `ctypes`, that one is used
  instead. Either way, `opam install ctypes-foreign` needs `libffi` and
  `pkg-config` on the system (or `nix develop` from this repository).
* The threading model (DESIGN.md §5) relies on the OCaml 5 runtime's
  `caml_c_thread_register` semantics for foreign-thread callbacks; OxCaml uses
  the OCaml 5 runtime, so this should hold, but it is inferred rather than
  tested.

If you try it, `dune build @runtest` (no GPU needed) is the quickest way to
find out; please report the result.

## The library

Everything is reachable through the single module `Wgpu`.

* `Wgpu.Types` — 114 structs, 70 enums, 8 bit sets, 23 opaque handles, 214
  function-pointer typedefs, 13 sentinel constants.
* `Wgpu.Fn` — 228 entry points, each under its exact C name.
* `Wgpu.Loader`, `Wgpu.Pin`, `Wgpu.Abi` — the loader, the pin metadata and the
  layout dump the ABI test uses.
* `Wgpu.Callback` — the only correct way to obtain the C function pointer a
  WebGPU descriptor wants. See
  [Callbacks, polling and threads](#callbacks-polling-and-threads); it is a
  correctness requirement, not a convenience, because `ctypes` frees the libffi
  closure behind a `Foreign.funptr` as soon as the OCaml value owning it is
  collected.

That is the whole library: no wrappers, no renaming, nothing hidden. The names
you read in `webgpu.h` are the names you type in OCaml, so the headers stay
greppable — and there is no coverage list to check an idea against, because
every entry point of the pinned headers is bound.

## `wgpu.utils`

A **separate** library, so a program that does not want it never links it, with
one admission rule: a helper belongs there only if nearly every program has to
write it anyway *and* the other wgpu-native bindings ship it too. Today that is
exactly three things, in about 200 lines:

| module | what it is | why it qualifies |
|---|---|---|
| `Wgpu_utils.Sync` | `request_adapter`, `request_device` | nothing can happen before them, and the handle only comes back through a C callback plus a `userdata` pointer |
| `Wgpu_utils.Buffer` | `map_read_sync`, `read_bytes` | the one genuinely asynchronous operation of every headless program; it settles only from `wgpuDevicePoll` |
| `Wgpu_utils.String_view` | `to_string`, `of_string` | every program reads a `WGPUStringView` and writes one |

Everything fallible returns a `result`, never an exception, and the handles are
the raw handle types. There are no descriptor builders, no error sink, no
logging wrapper and no arena. Depend on it from your `dune` with

```
(libraries wgpu wgpu.utils)
```

## Your first program

```ocaml
module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils

let () =
  Printf.printf "wgpu-native %s (bindings pinned at %s)\n"
    (Wgpu.Loader.runtime_version ()) Wgpu.Pin.version;
  let instance = F.wgpuCreateInstance (Ctypes.from_voidp T.InstanceDescriptor.t Ctypes.null) in
  match U.Sync.request_adapter instance with
  | Error (status, msg) ->
      Printf.eprintf "no adapter: %s (%s)\n" (T.RequestAdapterStatus.to_string status) msg
  | Ok adapter ->
      let info = T.AdapterInfo.init () in
      if F.wgpuAdapterGetInfo adapter (Ctypes.addr info) = T.Status.success then
        Printf.printf "%s (%s, backend %s)\n"
          (U.String_view.to_string (Ctypes.getf info T.AdapterInfo.device))
          (U.String_view.to_string (Ctypes.getf info T.AdapterInfo.vendor))
          (T.BackendType.to_string (Ctypes.getf info T.AdapterInfo.backendType));
      F.wgpuAdapterInfoFreeMembers info;      (* the strings are owned by wgpu *)
      F.wgpuAdapterRelease adapter;
      F.wgpuInstanceRelease instance
```

On lavapipe this prints:

```
wgpu-native 29.0.1.1 (bindings pinned at 29.0.1.1)
llvmpipe (LLVM 20.1.2, 128 bits) (llvmpipe, backend WGPUBackendType_Vulkan)
```

`Sync.request_adapter` takes an optional `?options:RequestAdapterOptions.t`
(build it with `init ()` and `Ctypes.setf` to ask for a power preference, a
backend or a compatible surface). `wgpuInstanceEnumerateAdapters`, the
wgpu-native extension that lists every adapter, is a plain `Wgpu.Fn` call with
a two-call protocol; `test/gpu/test_device.ml` shows it written out.

## Lifetimes

**Every `create`/`request` has a matching `release`, and nothing releases a
handle for you.** No finalisers are installed on purpose: a GPU handle freed by
the OCaml GC at an unpredictable moment is worse than a leak, and WebGPU's
reference counting is already explicit.

```ocaml
let device = Result.get_ok (Wgpu_utils.Sync.request_device adapter) in
...
Wgpu.Fn.wgpuDeviceRelease device
```

Handles that WebGPU also lets you *destroy* (`wgpuDeviceDestroy`,
`wgpuBufferDestroy`, `wgpuTextureDestroy`) have both operations: destroy frees
the underlying GPU resource immediately, release drops your reference.

Descriptors are the other half of the problem: a C descriptor is a tree of
pointers into memory `ctypes` owns, and the OCaml values holding the
sub-allocations must stay reachable until the foreign call returns. You own
that invariant — see
[Descriptors and chained structs](#descriptors-and-chained-structs). It is what
`test/gpu/test_gc_lifetime.ml` hammers: descriptor churn with `Gc.full_major`
around each cycle, and a full major collection *inside* a buffer-map callback
while wgpu-native is on the stack.

## Buffers and the queue

```ocaml
let buffer =
  let d = T.BufferDescriptor.init () in
  Ctypes.setf d T.BufferDescriptor.usage
    T.BufferUsage.(combine [ storage; copy_dst; copy_src ]);
  Ctypes.setf d T.BufferDescriptor.size (Unsigned.UInt64.of_int 32);
  F.wgpuDeviceCreateBuffer device (Ctypes.addr d)
in
let data = Ctypes.CArray.of_string (String.make 32 '\000') in
F.wgpuQueueWriteBuffer queue buffer (Unsigned.UInt64.of_int 0)
  (Ctypes.to_voidp (Ctypes.CArray.start data)) (Unsigned.Size_t.of_int 32);
ignore (Sys.opaque_identity data);          (* wgpu read it during the call *)
Printf.printf "%d bytes, usage %s\n"
  (Unsigned.UInt64.to_int (F.wgpuBufferGetSize buffer))
  (T.BufferUsage.to_string (F.wgpuBufferGetUsage buffer));
F.wgpuBufferRelease buffer
```

Sizes and offsets are `Unsigned.UInt64.t` / `Unsigned.Size_t.t`, exactly as the
header declares them.

Reading back is a two-step dance in WebGPU — the buffer must be mapped, and
mapping completes asynchronously — which is why `wgpu.utils` has a blocking
helper:

```ocaml
match Wgpu_utils.Buffer.read_bytes device staging ~offset:0 ~size with
| Ok bytes -> ...                                  (* map, copy, unmap *)
| Error (status, message) -> ...
```

`Buffer.map_read_sync` maps and leaves the buffer mapped (call
`wgpuBufferGetConstMappedRange`, then `wgpuBufferUnmap` yourself) if you want
the copy under your own control. Both drive the callback with
`wgpuDevicePoll ~wait:true`, at most `?max_polls` times; see
[Callbacks, polling and threads](#callbacks-polling-and-threads).

A mapped-for-read buffer must have been created with
`Types.BufferUsage.map_read` and can only be filled by a copy, so the usual
pattern is a storage buffer the GPU writes plus a staging buffer you map.

## Errors

WebGPU reports validation failures asynchronously through the device's
uncaptured-error callback. In wgpu-native v29 it is invoked synchronously, on
the thread that made the failing call — but nothing in these bindings collects
those messages for you, so install the callback when you request the device:

```ocaml
let uncaptured =
  Wgpu.Callback.permanent T.UncapturedErrorCallback.fn (fun _device ty message _u1 _u2 ->
      Wgpu.Callback.protect ~where:"uncaptured error callback" (fun () ->
          Printf.eprintf "[wgpu %s] %s\n%!" (T.ErrorType.to_string ty)
            (Wgpu_utils.String_view.to_string message)))

let device =
  let d = T.DeviceDescriptor.init () in
  let uc = T.UncapturedErrorCallbackInfo.init () in
  Ctypes.setf uc T.UncapturedErrorCallbackInfo.callback uncaptured;
  Ctypes.setf d T.DeviceDescriptor.uncapturedErrorCallbackInfo uc;
  Result.get_ok (Wgpu_utils.Sync.request_device ~descriptor:d adapter)
```

Compiling `"not wgsl at all"` then prints (lavapipe, wgpu-native v29):

```
[wgpu WGPUErrorType_Validation] Validation Error

Caused by:
  In wgpuDeviceCreateShaderModule, label = 'bad'
    ...
```

The device stays usable afterwards. Three things worth knowing:

* A raw constructor tells you nothing but a possibly-null handle: check it with
  `Wgpu.Types.ShaderModule.is_null` (and so on) and read the real reason off
  the callback.
* `wgpuDevicePushErrorScope` / `wgpuDevicePopErrorScope` are bound if you want
  scoped capture instead of a global handler; the pop callback answers
  synchronously in wgpu-native, so drive it exactly like
  `Wgpu_utils.Sync.request_adapter` does.
* `wgpuSetLogCallback` installs wgpu-native's own log sink (a *process-global*
  Rust `log` sink). Install it the same way, with
  `Wgpu.Callback.permanent T.LogCallback.fn`, and keep the handler cheap.


## A compute pass end to end

This is [`examples/headless_compute.ml`](../examples/headless_compute.ml)
condensed. It runs `data[i] = data[i] * 2 + 1` over eight `u32`s and reads the
result back. Read it next to wgpu-native's own `examples/compute/main.c`: it is
the same program, statement for statement.

```ocaml
module T = Wgpu.Types
module F = Wgpu.Fn
module U = Wgpu_utils

let shader = {|
@group(0) @binding(0) var<storage, read_write> data: array<u32>;

@compute @workgroup_size(1)
fn main(@builtin(global_invocation_id) id: vec3<u32>) {
  data[id.x] = data[id.x] * 2u + 1u;
}
|}

let u32 = Unsigned.UInt32.of_int
let u64 = Unsigned.UInt64.of_int
let sz = Unsigned.Size_t.of_int

(* A WGPUStringView points at memory we own, so every copy is kept here until
   the end of the program. *)
let owned = ref []

let sv s =
  let view, keepalive = U.String_view.of_string s in
  owned := keepalive :: !owned;
  view

let () =
  let instance = F.wgpuCreateInstance (Ctypes.from_voidp T.InstanceDescriptor.t Ctypes.null) in
  let adapter = Result.get_ok (U.Sync.request_adapter instance) in
  let device = Result.get_ok (U.Sync.request_device adapter) in
  let queue = F.wgpuDeviceGetQueue device in
  let size = 32 in

  let storage =
    let d = T.BufferDescriptor.init () in
    Ctypes.setf d T.BufferDescriptor.label (sv "storage");
    Ctypes.setf d T.BufferDescriptor.usage
      T.BufferUsage.(combine [ storage; copy_dst; copy_src ]);
    Ctypes.setf d T.BufferDescriptor.size (u64 size);
    F.wgpuDeviceCreateBuffer device (Ctypes.addr d)
  in
  let staging =
    let d = T.BufferDescriptor.init () in
    Ctypes.setf d T.BufferDescriptor.label (sv "staging");
    Ctypes.setf d T.BufferDescriptor.usage T.BufferUsage.(combine [ map_read; copy_dst ]);
    Ctypes.setf d T.BufferDescriptor.size (u64 size);
    F.wgpuDeviceCreateBuffer device (Ctypes.addr d)
  in

  (* WGSL source is a chained extension struct; init () has already set its
     chain.sType. *)
  let wgsl = T.ShaderSourceWGSL.init () in
  Ctypes.setf wgsl T.ShaderSourceWGSL.code (sv shader);
  let module_desc = T.ShaderModuleDescriptor.init () in
  Ctypes.setf module_desc T.ShaderModuleDescriptor.nextInChain
    (Ctypes.coerce (Ctypes.ptr T.ShaderSourceWGSL.t) (Ctypes.ptr T.ChainedStruct.t)
       (Ctypes.addr wgsl));
  let module_ = F.wgpuDeviceCreateShaderModule device (Ctypes.addr module_desc) in

  let compute = T.ComputeState.init () in
  Ctypes.setf compute T.ComputeState.module_ module_;
  Ctypes.setf compute T.ComputeState.entryPoint (sv "main");
  let pipeline_desc = T.ComputePipelineDescriptor.init () in
  Ctypes.setf pipeline_desc T.ComputePipelineDescriptor.compute compute;
  (* no .layout: wgpu derives the bind group layout from the shader *)
  let pipeline = F.wgpuDeviceCreateComputePipeline device (Ctypes.addr pipeline_desc) in
  let layout = F.wgpuComputePipelineGetBindGroupLayout pipeline (u32 0) in

  let entry = T.BindGroupEntry.init () in
  Ctypes.setf entry T.BindGroupEntry.binding (u32 0);
  Ctypes.setf entry T.BindGroupEntry.buffer storage;
  Ctypes.setf entry T.BindGroupEntry.size (u64 size);
  let bind_group_desc = T.BindGroupDescriptor.init () in
  Ctypes.setf bind_group_desc T.BindGroupDescriptor.layout layout;
  Ctypes.setf bind_group_desc T.BindGroupDescriptor.entryCount (sz 1);
  Ctypes.setf bind_group_desc T.BindGroupDescriptor.entries (Ctypes.addr entry);
  let bind_group = F.wgpuDeviceCreateBindGroup device (Ctypes.addr bind_group_desc) in

  let data = Ctypes.CArray.of_string (String.make size '\001') in
  F.wgpuQueueWriteBuffer queue storage (u64 0)
    (Ctypes.to_voidp (Ctypes.CArray.start data)) (sz size);
  ignore (Sys.opaque_identity data);

  let encoder_desc = T.CommandEncoderDescriptor.init () in
  let encoder = F.wgpuDeviceCreateCommandEncoder device (Ctypes.addr encoder_desc) in
  let pass_desc = T.ComputePassDescriptor.init () in
  let pass = F.wgpuCommandEncoderBeginComputePass encoder (Ctypes.addr pass_desc) in
  F.wgpuComputePassEncoderSetPipeline pass pipeline;
  F.wgpuComputePassEncoderSetBindGroup pass (u32 0) bind_group (sz 0)
    (Ctypes.from_voidp Ctypes.uint32_t Ctypes.null);
  F.wgpuComputePassEncoderDispatchWorkgroups pass (u32 8) (u32 1) (u32 1);
  F.wgpuComputePassEncoderEnd pass;
  F.wgpuComputePassEncoderRelease pass;
  F.wgpuCommandEncoderCopyBufferToBuffer encoder storage (u64 0) staging (u64 0) (u64 size);
  let commands_desc = T.CommandBufferDescriptor.init () in
  let commands = F.wgpuCommandEncoderFinish encoder (Ctypes.addr commands_desc) in
  let submitted = Ctypes.CArray.of_list T.CommandBuffer.t [ commands ] in
  F.wgpuQueueSubmit queue (sz 1) (Ctypes.CArray.start submitted);
  ignore (Sys.opaque_identity submitted);

  (match U.Buffer.read_bytes device staging ~offset:0 ~size with
  | Ok result -> Printf.printf "%d bytes back\n" (Bytes.length result)
  | Error (status, msg) ->
      Printf.eprintf "readback failed: %s (%s)\n" (T.MapAsyncStatus.to_string status) msg);

  F.wgpuCommandBufferRelease commands;
  F.wgpuCommandEncoderRelease encoder;
  F.wgpuBindGroupRelease bind_group;
  F.wgpuBindGroupLayoutRelease layout;
  F.wgpuComputePipelineRelease pipeline;
  F.wgpuShaderModuleRelease module_;
  F.wgpuBufferRelease staging;
  F.wgpuBufferRelease storage;
  F.wgpuQueueRelease queue;
  F.wgpuDeviceRelease device;
  F.wgpuAdapterRelease adapter;
  F.wgpuInstanceRelease instance;
  ignore (Sys.opaque_identity !owned)
```

Points worth noting:

* Leaving `ComputePipelineDescriptor.layout` at its `init ()` default (NULL)
  makes wgpu derive the bind group layout from the shader; you then read it
  back with `wgpuComputePipelineGetBindGroupLayout` and must release it.
* Every array a descriptor points at — the bind group entries, the submitted
  command buffers — is a pointer plus a count, and the OCaml value behind the
  pointer has to outlive the call.
* `wgpuComputePassEncoderEnd` ends the pass; the pass encoder still has to be
  released.
* Nothing here checks for errors: install the uncaptured-error callback shown
  in [Errors](#errors), and check the handles for null.

## An offscreen render pass

[`examples/offscreen_render.ml`](../examples/offscreen_render.ml) draws a
triangle into an RGBA8 texture, copies it into a buffer and prints an ASCII
view of the result. No window, no surface, no swapchain — it is
wgpu-native's `examples/triangle/main.c` with the GLFW half removed.

```ocaml
let extent = T.Extent3D.init () in
Ctypes.setf extent T.Extent3D.width (u32 32);
Ctypes.setf extent T.Extent3D.height (u32 32);
Ctypes.setf extent T.Extent3D.depthOrArrayLayers (u32 1);
let texture_desc = T.TextureDescriptor.init () in
Ctypes.setf texture_desc T.TextureDescriptor.usage
  T.TextureUsage.(combine [ render_attachment; copy_src ]);
Ctypes.setf texture_desc T.TextureDescriptor.dimension T.TextureDimension.v2_d;
Ctypes.setf texture_desc T.TextureDescriptor.format T.TextureFormat.rgba8_unorm;
Ctypes.setf texture_desc T.TextureDescriptor.size extent;
Ctypes.setf texture_desc T.TextureDescriptor.mipLevelCount (u32 1);
Ctypes.setf texture_desc T.TextureDescriptor.sampleCount (u32 1);
let texture = F.wgpuDeviceCreateTexture device (Ctypes.addr texture_desc) in
let view_desc = T.TextureViewDescriptor.init () in
let view = F.wgpuTextureCreateView texture (Ctypes.addr view_desc) in

(* The fragment state is reached through a pointer, so [fragment] and
   [target] must stay alive until the create call returns. *)
let target = T.ColorTargetState.init () in
Ctypes.setf target T.ColorTargetState.format T.TextureFormat.rgba8_unorm;
Ctypes.setf target T.ColorTargetState.writeMask T.ColorWriteMask.all;
let fragment = T.FragmentState.init () in
Ctypes.setf fragment T.FragmentState.module_ module_;
Ctypes.setf fragment T.FragmentState.entryPoint (sv "fs_main");
Ctypes.setf fragment T.FragmentState.targetCount (sz 1);
Ctypes.setf fragment T.FragmentState.targets (Ctypes.addr target);
let vertex = T.VertexState.init () in
Ctypes.setf vertex T.VertexState.module_ module_;
Ctypes.setf vertex T.VertexState.entryPoint (sv "vs_main");
let pipeline_desc = T.RenderPipelineDescriptor.init () in
Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.vertex vertex;
Ctypes.setf pipeline_desc T.RenderPipelineDescriptor.fragment (Ctypes.addr fragment);
(* .primitive and .multisample also need filling in; see the example *)
let pipeline = F.wgpuDeviceCreateRenderPipeline device (Ctypes.addr pipeline_desc) in

let attachment = T.RenderPassColorAttachment.init () in
Ctypes.setf attachment T.RenderPassColorAttachment.view view;
Ctypes.setf attachment T.RenderPassColorAttachment.loadOp T.LoadOp.clear;
Ctypes.setf attachment T.RenderPassColorAttachment.storeOp T.StoreOp.store;
Ctypes.setf attachment T.RenderPassColorAttachment.clearValue clear;
let pass_desc = T.RenderPassDescriptor.init () in
Ctypes.setf pass_desc T.RenderPassDescriptor.colorAttachmentCount (sz 1);
Ctypes.setf pass_desc T.RenderPassDescriptor.colorAttachments (Ctypes.addr attachment);
let pass = F.wgpuCommandEncoderBeginRenderPass encoder (Ctypes.addr pass_desc) in
ignore (Sys.opaque_identity attachment);
F.wgpuRenderPassEncoderSetPipeline pass pipeline;
F.wgpuRenderPassEncoderDraw pass (u32 3) (u32 1) (u32 0) (u32 0);
F.wgpuRenderPassEncoderEnd pass;
F.wgpuRenderPassEncoderRelease pass
```

Vertex buffer layouts, depth/stencil state, blending and explicit pipeline
layouts are more fields of the same descriptors — there is no wrapper deciding
which of them you are allowed to reach.

`RenderPassColorAttachment.init ()` already sets `depthSlice` to
`WGPU_DEPTH_SLICE_UNDEFINED`, which is exactly why you must never start a
descriptor from `Ctypes.make`.

One WebGPU rule the example encodes explicitly: a texture-to-buffer copy needs
`bytesPerRow` to be a multiple of 256, so the readback buffer is padded:

```ocaml
let bytes_per_row = ((width * 4) + 255) / 256 * 256
```


## Handles, enums, bit sets and structs

Everything below is generated, so it is exactly what the headers say.

### Handles

`WGPUBuffer` becomes `Wgpu.Types.Buffer`, a pointer to an incomplete struct:

```ocaml
Wgpu.Types.Buffer.t          (* the ctypes type *)
Wgpu.Types.Buffer.null       (* the null handle *)
Wgpu.Types.Buffer.is_null h
Wgpu.Types.Buffer.c_name     (* "WGPUBuffer" *)
```

`wgpu.utils` uses these very types, so nothing ever has to be converted.

### Enums

An enum is an OCaml `int` behind a `ctypes` view over `uint32_t`, with one
value per enumerant and the C spelling recoverable at run time:

```ocaml
Wgpu.Types.TextureFormat.rgba8_unorm
Wgpu.Types.LoadOp.clear
Wgpu.Types.TextureDimension.v2_d                 (* WGPUTextureDimension_2D *)
Wgpu.Types.BackendType.to_string Wgpu.Types.BackendType.vulkan
(* "WGPUBackendType_Vulkan" *)
Wgpu.Types.LoadOp.values                         (* (string * t) list, header order *)
```

Naming rules: the type loses the `WGPU` prefix and keeps its CamelCase; a
constant is the `snake_case` of the part after the `_`, with a leading `v` when
it would otherwise start with a digit. Acronym runs break correctly
(`RGBA8Unorm` → `rgba8_unorm`).

### Bit sets

The eight `WGPUFlags` typedefs (`BufferUsage`, `TextureUsage`, `MapMode`,
`ColorWriteMask`, `ShaderStage`, `InstanceBackend`, `InstanceFlag`,
`ShaderRuntimeChecks`) get the same treatment plus set operations:

```ocaml
let usage = Wgpu.Types.BufferUsage.(combine [ storage; copy_src ])
let usage = Wgpu.Types.BufferUsage.(storage + copy_src)          (* same thing *)
Wgpu.Types.BufferUsage.mem ~bit:Wgpu.Types.BufferUsage.storage usage    (* true *)
Wgpu.Types.BufferUsage.to_string usage
(* "WGPUBufferUsage_CopySrc|WGPUBufferUsage_Storage" *)
```

They are `int`s over `uint64_t`, which is why these bindings are 64-bit only;
the generator refuses a constant that would not fit in an OCaml `int`.

### Structs and `init ()`

Every struct module has the ctypes fields under their **exact C spelling** and
an `init ()` that returns zeroed memory with the header's `WGPU_*_INIT`
defaults applied:

```ocaml
let d = Wgpu.Types.BufferDescriptor.init () in
Ctypes.setf d Wgpu.Types.BufferDescriptor.usage Wgpu.Types.BufferUsage.storage;
Ctypes.setf d Wgpu.Types.BufferDescriptor.size (Unsigned.UInt64.of_int 1024);
Wgpu.Types.BufferDescriptor.field_names
(* [ "nextInChain"; "label"; "usage"; "size"; "mappedAtCreation" ] *)
```

**Always start from `init ()`, never from `Ctypes.make`.** Zero is not a valid
default in WebGPU: `WGPULimits` is all `WGPU_LIMIT_U32_UNDEFINED`
(`0xFFFFFFFF`), `RenderPassDepthStencilAttachment.depthClearValue` is `NaN`,
`SamplerDescriptor.lodMaxClamp` is `32.0` and `maxAnisotropy` is `1`, an
extension struct's `chain.sType` must carry its own tag, and so on. The 92
`WGPU_*_INIT` macros are parsed from the header and every one of the 543
resulting field values is checked against the C compiler's view of the same
macro by `dune test`.

An OCaml keyword gets a trailing underscore, and only then:
`WGPUComputeState.module` is `Wgpu.Types.ComputeState.module_`.

### Strings

WebGPU passes `WGPUStringView` (a pointer and a length) by value, and
distinguishes "no string" (`NULL`, length `WGPU_STRLEN`) from the empty string.
`Wgpu.Types.StringView.init ()` is the "no string" view.
`Wgpu_utils.String_view` converts both ways; `of_string` returns the view
*and* the value owning the bytes it points at, which you must keep alive
across the call.

### Sentinels

```ocaml
Wgpu.Types.Constants.strlen                  (* WGPU_STRLEN *)
Wgpu.Types.Constants.whole_size              (* WGPU_WHOLE_SIZE *)
Wgpu.Types.Constants.limit_u32_undefined     (* WGPU_LIMIT_U32_UNDEFINED *)
Wgpu.Types.Constants.depth_clear_value_undefined  (* NaN *)
```

## Descriptors and chained structs

A descriptor is a `Ctypes.structure` you fill in and hand to a `Wgpu.Fn` call
by address. Nothing else is involved — a sampler, which no helper covers, is
no different from a buffer:

```ocaml
let sampler =
  let d = Wgpu.Types.SamplerDescriptor.init () in
  Ctypes.setf d Wgpu.Types.SamplerDescriptor.magFilter Wgpu.Types.FilterMode.linear;
  Ctypes.setf d Wgpu.Types.SamplerDescriptor.minFilter Wgpu.Types.FilterMode.linear;
  Wgpu.Fn.wgpuDeviceCreateSampler device (Ctypes.addr d)
in
(* ... use it, e.g. as a WGPUBindGroupEntry.sampler ... *)
Wgpu.Fn.wgpuSamplerRelease sampler
```

Three rules, and they are yours to keep:

1. **Keep alive everything the descriptor points at**, for the duration of the
   call. In the snippet above `d` is a local `Ctypes.structure` that is still
   in scope; when a descriptor points at *other* allocations — an array of
   entries, a `WGPUStringView`, a chained struct — every OCaml value behind
   those pointers must stay reachable until the call returns. Ending the
   sequence with `ignore (Sys.opaque_identity keepalive)` is how you say so to
   the compiler.
2. **Check for null.** A constructor returns a null handle on failure;
   `Wgpu.Types.Sampler.is_null` tells you, and the uncaptured-error callback
   tells you why (see [Errors](#errors)).
3. **Release what you created**, in reverse order.

Chained (`nextInChain`) extension structs are the same idea — set the tag,
coerce the pointer, keep the extension struct alive:

```ocaml
let extras = Wgpu.Types.InstanceExtras.init () in
let chain = Ctypes.getf extras Wgpu.Types.InstanceExtras.chain in
Ctypes.setf chain Wgpu.Types.ChainedStruct.sType
  Wgpu.Types.NativeSType.instance_extras;
Ctypes.setf extras Wgpu.Types.InstanceExtras.chain chain;
Ctypes.setf extras Wgpu.Types.InstanceExtras.backends Wgpu.Types.InstanceBackend.vulkan;
let desc = Wgpu.Types.InstanceDescriptor.init () in
Ctypes.setf desc Wgpu.Types.InstanceDescriptor.nextInChain
  (Ctypes.coerce (Ctypes.ptr Wgpu.Types.InstanceExtras.t)
     (Ctypes.ptr Wgpu.Types.ChainedStruct.t) (Ctypes.addr extras));
let instance = Wgpu.Fn.wgpuCreateInstance (Ctypes.addr desc) in
ignore (Sys.opaque_identity extras)
```

(`WGPUShaderSourceWGSL` in the compute example is the same pattern, except
that `init ()` has already set its `chain.sType` for you.)

`Wgpu.Fn.names` is the list of every bound entry point in header order, which
is handy for checking whether something exists at all:

```ocaml
List.mem "wgpuDeviceCreateQuerySet" Wgpu.Fn.names          (* true *)
```

## Callbacks, polling and threads

This is the part of the design worth reading before you build anything large;
`DESIGN.md` §5 records the reasoning in full.

* Callbacks are C function pointers that WebGPU stores in a struct. `ctypes`
  frees the libffi closure behind a `Foreign.funptr` when the *OCaml* value
  owning it is collected, and a raw `static_funptr` written into a C struct
  does not keep it alive. The generated layer therefore uses plain
  `Ctypes.static_funptr` and `Wgpu.Callback` provides the only two safe ways to
  obtain one:
  * `Wgpu.Callback.permanent fn f` — retained for the life of the process; used
    for trampolines installed once, such as the uncaptured-error handler and
    the three inside `wgpu.utils`;
  * `Wgpu.Callback.Userdata` — a token table addressed by the `void *userdata1`
    WebGPU hands back, so one permanent trampoline can serve unbounded
    per-call closures. `Userdata.live_count ()` returns the number of live
    tokens and is asserted back to zero by the GPU tests.
* **Asynchronous work is driven by polling.**
  `wgpuDevicePoll device true NULL` runs the device's submission queue and
  blocks until everything submitted has completed, which is what makes
  buffer-mapping and work-done callbacks fire. `wgpuInstanceProcessEvents` is
  the instance-level equivalent. `Wgpu_utils.Buffer.read_bytes` polls for
  you.
* `WGPUFuture` and `wgpuInstanceWaitAny` are **not implemented in wgpu-native
  v29** (`wgpuBufferMapAsync` returns a null future); the future-returning
  entry points are bound, but ignore what they return and poll instead.
* **Callbacks can arrive on any thread, and that is supported.** wgpu-native's
  log sink is a process-global Rust `log` sink and `webgpu.h` documents the
  uncaptured-error callback as callable "from any thread". So every entry
  point is bound with `~release_runtime_lock:true` and every closure with
  `~runtime_lock:true ~thread_registration:true`: ctypes registers the calling
  thread with the OCaml runtime and takes the domain lock for the duration of
  the callback, and the state the bindings share with callbacks is behind a
  mutex. `test/thread/` proves the mechanism with a C fixture that calls back
  from a real pthread.
* **One domain, though.** Registered foreign threads attach to domain 0;
  nothing here is multi-domain safe.
* **Do not call back into wgpu from a callback**, and keep log handlers cheap:
  upstream documents re-entering the API from the uncaptured-error callback as
  unsafe.
* **A callback must not let an exception escape**, because it would unwind
  through Rust frames. Wrap the body in
  `Wgpu.Callback.protect ~where:"..." (fun () -> ...)`, which records the
  exception instead. Nothing re-raises those failures for you:
  `Wgpu.Callback.take_failures ()` hands them over and
  `Wgpu.Callback.pending_failures ()` counts them, so collect them wherever
  your program checks for trouble.
* Running the OCaml GC inside a wgpu callback is tested, not assumed
  (`test/gpu/test_gc_lifetime.ml`), and so is the whole foreign-thread path
  (`test/thread/test_foreign_thread_callbacks.ml`).

## Loading, the version gate and diagnostics

`Wgpu.Loader` looks for the shared library in this order, first match wins:

1. `$WGPU_NATIVE_LIB` — a full path, **authoritative**: if it is set and does
   not load, loading fails instead of silently finding another copy.
2. `$WGPU_NATIVE_LIB_DIR` — a directory, same rule.
3. `$WGPU_OCAML_CACHE_DIR` / `$XDG_CACHE_HOME/wgpu-ocaml` /
   `~/.cache/wgpu-ocaml`, under `wgpu-native-<pinned version>/lib/` — where the
   fetch script installs.
4. The system search path (`libwgpu_native.so`, `libwgpu_native.dylib`,
   `wgpu_native.dll`).

Nothing is opened until the first entry point is actually called, so linking
against `wgpu` costs nothing and the unit tests run with no library present.

On success the loader calls `wgpuGetVersion` and compares it with the pin
(`29.0.1.1`, `0x1d000101`). A mismatch raises `Wgpu.Loader.Version_mismatch`;
`WGPU_OCAML_ALLOW_VERSION_MISMATCH=1` downgrades that to a warning on stderr.
Use it only to experiment: the bindings encode struct layouts and enum values
from the pinned headers, and a different wgpu-native may not match them.

When nothing is found, `Wgpu.Loader.Not_found_` carries a diagnostic listing
every path that was tried, why each failed, and the command that fixes it:

```
wgpu-ocaml could not load the wgpu-native shared library (libwgpu_native.so, pinned release v29.0.1.1).
Tried, in order:
  - fetch cache: /home/you/.cache/wgpu-ocaml/wgpu-native-29.0.1.1/lib/libwgpu_native.so (no such file)
  - fetch cache: /home/you/.cache/wgpu-ocaml/wgpu-native-29.0.1.1/lib/libwgpu_native.dylib (no such file)
  - system search path: libwgpu_native.so (libwgpu_native.so: cannot open shared object file: No such file or directory)
  - system search path: libwgpu_native.dylib (libwgpu_native.dylib: cannot open shared object file: No such file or directory)

Install the pinned release with:
  dune exec scripts/fetch_wgpu_native.exe
or point the bindings at an existing build:
  export WGPU_NATIVE_LIB=/path/to/libwgpu_native.so
  export WGPU_NATIVE_LIB_DIR=/path/to/lib
```

Two more useful values: `Wgpu.Loader.loaded_path ()` (the file that was
actually opened, or `None`), and `Wgpu.runtime_version ()` versus
`Wgpu.pinned_version`.

## Entry points that abort the process

wgpu-native v29 declares the full `webgpu.h` surface but leaves 35 entry points
as `unimplemented!()` stubs that **abort the process** when called. They are
bound anyway — hiding them would make the raw layer lie about the header — and
listed in the pin:

```ocaml
Wgpu.Pin.unimplemented                          (* string list, 35 entries *)
List.mem "wgpuBufferGetMapState" Wgpu.Pin.unimplemented   (* true *)
```

The list includes every `SetLabel` entry point, `wgpuGetProcAddress`,
`wgpuInstanceWaitAny`, `wgpuDeviceCreateComputePipelineAsync`,
`wgpuDeviceCreateRenderPipelineAsync`, `wgpuShaderModuleGetCompilationInfo` and
`wgpuDeviceGetAdapterInfo`. `test/unit/test_pin.ml` checks that every name on
the list is really bound, so the list cannot drift from the bindings.

Labels themselves work fine — set the `label` field of the descriptor at
creation time.

## What the tests check, and how to run them

Three tiers, deliberately separated so the cheap ones run anywhere:

```sh
dune test        # 145 checks + the 1914-line ABI diff  (C compiler, no GPU)
dune build @gen  # the committed generated code is reproducible
dune build @gpu  # 71 checks against a real adapter
```

* **`dune test`** runs `test/unit` (the pin and version encoding, the naming
  and representation rules, `init ()` defaults, a rescan of the headers with an
  independent scanner that must produce *exactly* the generated inventories,
  the SHA-256 of the vendored headers, and the loader diagnostic) and
  `test/abi`. The ABI test compiles a generated C probe against the vendored
  headers, dumps every struct size and alignment, every field offset, every
  enum and bit-set value, every sentinel and every `WGPU_*_INIT` field value,
  dumps the same from `ctypes` and the generated bindings, and diffs the two.
  1914 identical lines, 543 of them default-value assertions.
* **`dune build @gen`** regenerates the four generated modules from the
  vendored headers and diffs them against the committed copies (`dune promote`
  accepts a new output).
* **`dune build @gpu`** runs `test_device` (16 checks), `test_compute` (5,
  exact numerical readback), `test_render` (12, exact pixel readback),
  `test_errors` (10), `test_gc_lifetime` (10) and `test_callback_safety` (18),
  all of them against the raw entry points. With
  `VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.json` it runs entirely on
  lavapipe, no GPU required — which is how CI runs it.

## Regenerating for a new wgpu-native

```sh
# replace vendor/wgpu-native/include/webgpu/{webgpu,wgpu}.h
# update every field of vendor/wgpu-native/pin.txt, including the
# unimplemented list (extracted from upstream src/unimplemented.rs)
dune build @gen        # fails: the committed output is stale
dune promote           # accept the regenerated modules
dune test
dune build @gpu
```

The generator is written in OCaml with the stdlib only, has a strict parser for
the C subset the headers use, and **aborts on anything it does not
recognise** — so a header that grows a new C construct fails loudly at
generation time instead of silently producing a wrong binding. Its output is
byte-for-byte reproducible.

## Limitations to plan around

* **Raw bindings.** There is no windowing, surface or swapchain integration
  and no convenience wrapper for anything: you fill in descriptors, you keep
  the memory they point at alive, you check for null handles and you release
  every handle yourself. What you get in exchange is that nothing is missing.
* **Not usable in wgpu-native v29 at all**: futures, `wgpuGetProcAddress`, and
  the 35 unimplemented entry points above.
* **One pin.** These bindings target wgpu-native v29.0.1.1 only; the loader
  refuses another version by default.
* **64-bit only**, and one OCaml domain at a time.
* **Platforms**: developed and tested on Linux x86_64 against lavapipe. The pin
  carries checksums for linux-aarch64, macos-x86_64, macos-aarch64 and
  windows-x86_64 and the loader knows their file names, but none of them has
  been executed.
* **Licensing is deliberately unset** — see
  [Licensing](../README.md#licensing).
