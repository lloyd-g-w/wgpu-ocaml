# wgpu-ocaml guide

A practical, example-driven tour of the bindings: how to install the native
library, what the two layers look like, and how to write headless compute and
offscreen rendering with them. [`DESIGN.md`](../DESIGN.md) is the authoritative
*contract* between the generator, the runtime and the tests; this guide is the
reader-friendly walkthrough of the same material.

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
| OCaml | **5.5.1** (what the project is developed and tested with) |
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

### Using it from your own project

The package is not released to opam. Until it is, pin the repository:

```sh
opam pin add wgpu https://github.com/lloyd-g-w/wgpu-ocaml.git
```

and depend on it from your `dune-project`/`dune` as `wgpu`. Read
[Licensing](../README.md#licensing) first: no licence has been chosen for the
original code yet, so the repository is all-rights-reserved for now.

## The two layers

Everything is reachable through the single module `Wgpu`.

**The raw layer** is generated from the vendored headers and mirrors them one
for one — same entry point names, same struct field spellings, same enum
values, same defaults:

* `Wgpu.Types` — 114 structs, 70 enums, 8 bit sets, 23 opaque handles, 214
  function-pointer typedefs, 13 sentinel constants.
* `Wgpu.Fn` — 228 entry points, each under its exact C name.

**The ergonomic layer** is small, hand written, and owns lifetimes explicitly:
`Wgpu.Instance`, `Adapter`, `Device`, `Queue`, `Buffer`, `Command_encoder`,
`Compute_pass`, `Render_pass`, `Texture`, `Shader_module`, `Compute_pipeline`,
`Render_pipeline`, `Bind_group`, `Command_buffer`, `Log`.

The two layers share the same handle types — the ergonomic layer never wraps a
handle in a new type — so you can always drop down to `Wgpu.Fn` for anything it
does not cover, on the very same values. That is the whole design: a complete
raw surface, plus a thin convenience layer that never gets in the way.

## Your first program

```ocaml
open Wgpu

let () =
  Log.to_stderr ~level:Types.LogLevel.warn ();
  Printf.printf "wgpu-native %s (bindings pinned at %s)\n" (runtime_version ()) pinned_version;
  let instance = Instance.create () in
  let adapter = Instance.request_adapter instance in
  let info = Adapter.info adapter in
  print_endline (Adapter.string_of_info info);
  Adapter.release adapter;
  Instance.release instance
```

On lavapipe this prints:

```
wgpu-native 29.0.1.1 (bindings pinned at 29.0.1.1)
llvmpipe (LLVM 20.1.2, 128 bits) (llvmpipe, , backend WGPUBackendType_Vulkan, type WGPUAdapterType_CPU, vendor 0x10005 device 0x0000)
```

`Adapter.info` returns a record with `vendor`, `architecture`, `device`,
`description`, `backend_type`, `adapter_type`, `vendor_id` and `device_id`;
`Adapter.string_of_info` is the one-line rendering above.

`Instance.request_adapter` takes optional `?power_preference`,
`?force_fallback_adapter`, `?backend_type` and `?compatible_surface`
arguments, and `Instance.enumerate_adapters` (a wgpu-native extension) lists
every adapter the instance can see — the caller owns and must release each of
them.

## Lifetimes

**Every `create`/`request` has a matching `release`, and nothing releases a
handle for you.** No finalisers are installed on purpose: a GPU handle freed by
the OCaml GC at an unpredictable moment is worse than a leak, and WebGPU's
reference counting is already explicit.

```ocaml
let device = Adapter.request_device ~label:"demo" adapter in
...
Device.release device
```

For the one case where scoping is unambiguous there is a wrapper:

```ocaml
Instance.with_instance (fun instance ->
    (* ... *)
    ())
```

Handles that WebGPU also lets you *destroy* (`Device`, `Buffer`, `Texture`)
have both operations: `destroy` frees the underlying GPU resource immediately,
`release` drops your reference.

Descriptors are a different problem: a C descriptor is a tree of pointers into
memory `ctypes` owns, and the OCaml values holding the sub-allocations must
stay reachable until the foreign call returns. The ergonomic layer solves this
with an arena that roots every allocation across the call
(`Arena.finish` ends with `Sys.opaque_identity`), which is what
`test/gpu/test_gc_lifetime.ml` hammers: descriptor churn with `Gc.full_major`
around each cycle, and a full major collection *inside* a buffer-map callback
while wgpu-native is on the stack.

If you build descriptors yourself with the raw layer, you own that invariant —
see [Dropping down to the raw layer](#dropping-down-to-the-raw-layer).

## Buffers and the queue

```ocaml
let buffer =
  Device.create_buffer device ~label:"data" ~size:32
    ~usage:Types.BufferUsage.(combine [ storage; copy_dst; copy_src ])
in
Queue.write_buffer queue buffer (Bytes.make 32 '\000');
Printf.printf "%d bytes, usage %s\n" (Buffer.size buffer)
  (Types.BufferUsage.to_string (Buffer.usage buffer));
Buffer.release buffer
```

Sizes and offsets are plain OCaml `int`s in the ergonomic layer (the raw layer
uses `Unsigned.UInt64.t`, as the header does). `Queue.write_buffer` takes
`Bytes.t` and an optional `?offset`.

Reading back is a two-step dance in WebGPU — the buffer must be mapped, and
mapping completes asynchronously — so the ergonomic layer offers a blocking
helper:

```ocaml
let data = Buffer.read_sync ~device staging ~offset:0 ~size in   (* map, copy, unmap *)
```

`Buffer.map_read_sync` maps and leaves the buffer mapped (call
`Buffer.mapped_bytes`, then `Buffer.unmap` yourself) if you want the copy under
your own control. Both drive the callback by calling `Device.poll ~wait:true`
until it fires; see [Callbacks, polling and
threads](#callbacks-polling-and-threads).

A mapped-for-read buffer must have been created with
`Types.BufferUsage.map_read` and can only be filled by a copy, so the usual
pattern is a storage buffer the GPU writes plus a staging buffer you map.

## Errors

WebGPU reports validation failures asynchronously through the device's
uncaptured-error callback. In wgpu-native v29 it is invoked synchronously, on
the thread that made the failing call, so the ergonomic layer collects the
messages and turns them into exceptions:

```ocaml
match Device.create_shader_module_wgsl device ~label:"bad" "not wgsl at all" with
| module_ -> Shader_module.release module_
| exception Wgpu.Error msg -> prerr_endline msg
```

which prints (lavapipe, wgpu-native v29):

```
WGPUErrorType_Validation: Validation Error

Caused by:
  In wgpuDeviceCreateShaderModule, label = 'bad'
    ...
```

The device stays usable afterwards. Three related entry points:

* `Device.check device` — raise if anything was reported since the last check.
  Every ergonomic constructor calls it for you; call it yourself after a raw
  `Wgpu.Fn` call, or after `Queue.submit`.
* `Device.with_error_scope device (fun () -> ...)` — pushes a WebGPU error
  scope (`?filter`, default `ErrorFilter.validation`), runs the function, pops
  the scope and raises `Wgpu.Error` if it captured anything. This is how
  `test/gpu/test_errors.ml` catches an invalid buffer-usage combination.
* `Device.lost device` — `Some reason` once the device has been lost.

`Wgpu.Error` is also raised when an entry point returns a null handle, with the
name of the C function that returned it.

Set `Log.to_stderr ~level:Types.LogLevel.warn ()` early to see wgpu-native's
own log (or `Log.set ~level f` to route it somewhere else); the levels are
`off`, `error`, `warn`, `info`, `debug`, `trace`.

## A compute pass end to end

This is [`examples/headless_compute.ml`](../examples/headless_compute.ml)
condensed. It runs `data[i] = data[i] * 2 + 1` over eight `u32`s and reads the
result back.

```ocaml
open Wgpu

let shader = {|
@group(0) @binding(0) var<storage, read_write> data: array<u32>;

@compute @workgroup_size(1)
fn main(@builtin(global_invocation_id) id: vec3<u32>) {
  data[id.x] = data[id.x] * 2u + 1u;
}
|}

let () =
  let instance = Instance.create () in
  let adapter = Instance.request_adapter instance in
  let device = Adapter.request_device ~label:"compute" adapter in
  let queue = Device.queue device in

  let size = 32 in
  let storage =
    Device.create_buffer device ~label:"storage" ~size
      ~usage:Types.BufferUsage.(combine [ storage; copy_dst; copy_src ])
  in
  let staging =
    Device.create_buffer device ~label:"staging" ~size
      ~usage:Types.BufferUsage.(combine [ map_read; copy_dst ])
  in

  let module_ = Device.create_shader_module_wgsl device ~label:"double" shader in
  let pipeline =
    Device.create_compute_pipeline device ~label:"double" ~shader_module:module_
      ~entry_point:"main"
  in
  let layout = Compute_pipeline.bind_group_layout pipeline in
  let bind_group =
    Device.create_bind_group device ~label:"data" ~layout
      ~entries:[ Device.Buffer_binding { binding = 0; buffer = storage; offset = 0; size } ]
  in

  Queue.write_buffer queue storage (Bytes.make size '\001');

  let encoder = Device.create_command_encoder device ~label:"compute" in
  let pass = Command_encoder.begin_compute_pass encoder ~label:"double" in
  Compute_pass.set_pipeline pass pipeline;
  Compute_pass.set_bind_group pass bind_group;
  Compute_pass.dispatch_workgroups pass 8;
  Compute_pass.finish pass;
  Compute_pass.release pass;
  Command_encoder.copy_buffer_to_buffer encoder ~src:storage ~src_offset:0 ~dst:staging
    ~dst_offset:0 ~size;
  let commands = Command_encoder.finish encoder ~label:"compute" in
  Queue.submit queue [ commands ];
  Device.check device;

  let result = Buffer.read_sync ~device staging ~offset:0 ~size in
  Printf.printf "%d bytes back\n" (Bytes.length result);

  Command_buffer.release commands;
  Command_encoder.release encoder;
  Bind_group.release bind_group;
  Bind_group.release_layout layout;
  Compute_pipeline.release pipeline;
  Shader_module.release module_;
  Buffer.release staging;
  Buffer.release storage;
  Queue.release queue;
  Device.release device;
  Adapter.release adapter;
  Instance.release instance
```

Points worth noting:

* `Device.create_compute_pipeline` takes `~shader_module` and an
  `?entry_point` (default `"main"`) and, with no `?layout`, lets wgpu derive
  the bind group layout from the shader — which you then read back with
  `Compute_pipeline.bind_group_layout` (and must release).
* Bind group entries are a variant: `Device.Buffer_binding`,
  `Device.Texture_view_binding`, `Device.Sampler_binding`.
* `Compute_pass.set_bind_group` takes an optional `?index` (default 0) and
  passes no dynamic offsets; use `Wgpu.Fn.wgpuComputePassEncoderSetBindGroup`
  directly if you need them.
* `Compute_pass.finish` is `wgpuComputePassEncoderEnd`; the pass encoder still
  has to be released.
* `Device.check` after `Queue.submit` surfaces validation errors raised during
  submission.

## An offscreen render pass

[`examples/offscreen_render.ml`](../examples/offscreen_render.ml) draws a
triangle into an RGBA8 texture, copies it into a buffer and prints an ASCII
view of the result. No window, no surface, no swapchain — the ergonomic layer
deliberately has no windowing support.

```ocaml
let texture =
  Device.create_texture device ~label:"target" ~format:Types.TextureFormat.rgba8_unorm
    ~width:32 ~height:32
    ~usage:Types.TextureUsage.(combine [ render_attachment; copy_src ])
in
let view = Texture.create_view texture ~label:"target-view" in

let pipeline =
  Device.create_render_pipeline device ~label:"triangle" ~shader_module:module_
    ~targets:[ { Device.format = Types.TextureFormat.rgba8_unorm;
                 write_mask = Types.ColorWriteMask.all } ]
in

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
Command_encoder.copy_texture_to_buffer encoder ~texture ~buffer:readback
  ~bytes_per_row ~rows_per_image:32 ~width:32 ~height:32 ()
```

`Device.create_render_pipeline` covers the state the examples need and nothing
more: `?vertex_entry_point` (default `"vs_main"`), `?fragment_entry_point`
(default `"fs_main"`), `?topology`, `?cull_mode`, `?front_face`,
`?sample_count`, `?layout`, and a list of colour targets. There are no vertex
buffer layouts, no depth/stencil state and no blend state here — build the
descriptor with `Wgpu.Types.RenderPipelineDescriptor` and call
`Wgpu.Fn.wgpuDeviceCreateRenderPipeline` when you need them.

One WebGPU rule the example encodes explicitly: a texture-to-buffer copy needs
`bytes_per_row` to be a multiple of 256, so the readback buffer is padded:

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

The ergonomic modules use these very types: `Wgpu.Buffer.t = Wgpu.Types.Buffer.t`.

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
`Wgpu.Types.StringView.init ()` is the "no string" view; the ergonomic layer
converts `string`/`string option` for you at every place it takes a `?label`.

### Sentinels

```ocaml
Wgpu.Types.Constants.strlen                  (* WGPU_STRLEN *)
Wgpu.Types.Constants.whole_size              (* WGPU_WHOLE_SIZE *)
Wgpu.Types.Constants.limit_u32_undefined     (* WGPU_LIMIT_U32_UNDEFINED *)
Wgpu.Types.Constants.depth_clear_value_undefined  (* NaN *)
```

## Dropping down to the raw layer

The ergonomic layer covers what the examples and tests need; the raw layer
covers the headers. Mixing them needs no conversion — a sampler, for
instance, is not covered ergonomically at all:

```ocaml
let sampler =
  let d = Wgpu.Types.SamplerDescriptor.init () in
  Ctypes.setf d Wgpu.Types.SamplerDescriptor.magFilter Wgpu.Types.FilterMode.linear;
  Ctypes.setf d Wgpu.Types.SamplerDescriptor.minFilter Wgpu.Types.FilterMode.linear;
  let s = Wgpu.Fn.wgpuDeviceCreateSampler device (Ctypes.addr d) in
  Wgpu.Device.check device;         (* raw calls do not check for you *)
  s
in
(* ... use it, e.g. in Device.Sampler_binding ... *)
Wgpu.Fn.wgpuSamplerRelease sampler
```

Three rules when you do this:

1. **Keep the descriptor alive** for the duration of the call. In the snippet
   above `d` is a local `Ctypes.structure` that is still in scope; when a
   descriptor points at *other* allocations (an array of entries, a string
   view, a chained struct) all of them must stay reachable until the call
   returns. That is what the ergonomic layer's arena does.
2. **Call `Device.check`** afterwards: the raw layer does not look at the
   device's error sink.
3. **Check for null.** Raw constructors return a null handle on failure;
   `Wgpu.Types.Sampler.is_null` tells you.

Chained (`nextInChain`) extension structs work the same way — set the tag,
coerce the pointer:

```ocaml
let extras = Wgpu.Types.InstanceExtras.init () in
let chain = Ctypes.getf extras Wgpu.Types.InstanceExtras.chain in
Ctypes.setf chain Wgpu.Types.ChainedStruct.sType
  Wgpu.Types.NativeSType.instance_extras;
Ctypes.setf extras Wgpu.Types.InstanceExtras.chain chain;
let desc = Wgpu.Types.InstanceDescriptor.init () in
Ctypes.setf desc Wgpu.Types.InstanceDescriptor.nextInChain
  (Ctypes.coerce (Ctypes.ptr Wgpu.Types.InstanceExtras.t)
     (Ctypes.ptr Wgpu.Types.ChainedStruct.t) (Ctypes.addr extras))
```

(`Instance.create ?backends ?flags` does exactly this for the two
`WGPUInstanceExtras` fields it exposes.)

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
    for the handful of trampolines the ergonomic layer installs once;
  * `Wgpu.Callback.Userdata` — a token table addressed by the `void *userdata1`
    WebGPU hands back, so one permanent trampoline can serve unbounded
    per-call closures. `Userdata.live_count ()` returns the number of live
    tokens and is asserted back to zero by the GPU tests.
* **Asynchronous work is driven by polling.** `Device.poll ~wait:true device`
  runs the device's submission queue (and, with `~wait:true`, blocks until
  everything submitted has completed), which is what makes buffer-mapping and
  work-done callbacks fire. `Instance.process_events instance` is the
  instance-level equivalent. `Buffer.read_sync` polls for you.
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
  exception instead; the ergonomic layer re-raises recorded failures as
  `Wgpu.Error` at its next checkpoint, and `Wgpu.Callback.take_failures ()`
  hands them to you directly.
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

Labels themselves work fine — pass them at creation time, which is what the
`?label` arguments do.

## What the tests check, and how to run them

Three tiers, deliberately separated so the cheap ones run anywhere:

```sh
dune test        # 145 checks + the 1914-line ABI diff  (C compiler, no GPU)
dune build @gen  # the committed generated code is reproducible
dune build @gpu  # 76 checks against a real adapter
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
* **`dune build @gpu`** runs `test_device`, `test_compute` (exact numerical
  readback), `test_render` (exact pixel readback), `test_errors` and
  `test_gc_lifetime`. With
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

* **Not covered by the ergonomic layer** (all reachable through `Wgpu.Fn` +
  `Wgpu.Types`): surfaces, swapchains and every windowing integration, render
  bundles, query sets and timestamps, samplers and texture sampling, vertex
  buffer layouts, depth/stencil state, blending, explicit pipeline and bind
  group layouts, SPIR-V shader modules, immediates, multi-draw, external
  textures and the Metal interop entry points.
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
