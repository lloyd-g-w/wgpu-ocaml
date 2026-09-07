(** @canonical Wgpu.Pin *)

(* The pinned wgpu-native release.

   GENERATED FILE -- DO NOT EDIT.  Produced by [gen/gen.ml] from
   [vendor/wgpu-native/pin.txt]; see [vendor/wgpu-native/PROVENANCE.md]. *)

(** Upstream release tag. *)
let tag = "v29.0.1.1"

(** Upstream release version. *)
let version = "29.0.1.1"

(** Upstream wgpu-native commit. *)
let commit = "6aed50955d934ac36049ba8d002034841633ae02"

(** Upstream webgpu-headers commit. *)
let webgpu_headers_commit = "673658bc2bd70ec39fc55ebe6bb0173cf6d0a603"

(** Base URL of the release assets. *)
let release_url_prefix = "https://github.com/gfx-rs/wgpu-native/releases/download/v29.0.1.1/"

(** Release archives: platform, asset name, SHA-256, path of the shared
    library inside the archive. *)
let archives : (string * string * string * string) list =
  [
    ("linux-x86_64", "wgpu-linux-x86_64-release.zip", "95a4d90c071005a98d03eab348beaa6b07e16eb00d1dcdb9f8348f75eb97ec5a", "lib/libwgpu_native.so");
    ("linux-aarch64", "wgpu-linux-aarch64-release.zip", "015fcdf1dbae82e614a783cc38017e5399ae0927a889fe9b69c9b664bc61b47a", "lib/libwgpu_native.so");
    ("macos-aarch64", "wgpu-macos-aarch64-release.zip", "a5797a37b1adf720bcd5dcffb291edbbd5b7b14be0a3874c28e6393a655a7a3e", "lib/libwgpu_native.dylib");
    ("macos-x86_64", "wgpu-macos-x86_64-release.zip", "8e2f7378548ddd0e2cf21e7d864dda46e953f0af724855a33778b85ead206d41", "lib/libwgpu_native.dylib");
    ("windows-x86_64", "wgpu-windows-x86_64-msvc-release.zip", "7e67d7445c42aeb85e30f88930fd8d7d83ee769e3390aeb1ada75ebf3cf78132", "lib/wgpu_native.dll");
  ]

(** SHA-256 of the vendored headers. *)
let header_sha256 : (string * string) list =
  [
    ("webgpu.h", "a483031c3fed05ea5dd1c74082a71676c46c5b2b820ccca10da515c033efc997");
    ("wgpu.h", "7bd23656d394f620a804b1f174444ea17082b6d330a2fca0c0e6b1121ec4b284");
  ]

(** Entry points that this wgpu-native release declares but does not
    implement: calling one aborts the process.  See
    [vendor/wgpu-native/PROVENANCE.md]. *)
let unimplemented : string list =
  [
    "wgpuBindGroupLayoutSetLabel";
    "wgpuBindGroupSetLabel";
    "wgpuBufferGetMapState";
    "wgpuBufferSetLabel";
    "wgpuCommandBufferSetLabel";
    "wgpuCommandEncoderSetLabel";
    "wgpuComputePassEncoderSetLabel";
    "wgpuComputePipelineSetLabel";
    "wgpuDeviceCreateComputePipelineAsync";
    "wgpuDeviceCreateRenderPipelineAsync";
    "wgpuDeviceGetAdapterInfo";
    "wgpuDeviceGetLostFuture";
    "wgpuDeviceSetLabel";
    "wgpuExternalTextureAddRef";
    "wgpuExternalTextureRelease";
    "wgpuExternalTextureSetLabel";
    "wgpuGetProcAddress";
    "wgpuInstanceGetWGSLLanguageFeatures";
    "wgpuInstanceHasWGSLLanguageFeature";
    "wgpuInstanceWaitAny";
    "wgpuPipelineLayoutSetLabel";
    "wgpuQuerySetSetLabel";
    "wgpuQueueSetLabel";
    "wgpuRenderBundleEncoderSetLabel";
    "wgpuRenderBundleSetLabel";
    "wgpuRenderPassEncoderSetLabel";
    "wgpuRenderPipelineSetLabel";
    "wgpuSamplerSetLabel";
    "wgpuShaderModuleGetCompilationInfo";
    "wgpuShaderModuleSetLabel";
    "wgpuSupportedWGSLLanguageFeaturesFreeMembers";
    "wgpuSurfaceSetLabel";
    "wgpuTextureGetTextureBindingViewDimension";
    "wgpuTextureSetLabel";
    "wgpuTextureViewSetLabel";
  ]

(** The version encoding returned by [wgpuGetVersion]: one byte each for
    major, minor, patch and build. *)
let version_u32 =
  match String.split_on_char '.' version with
  | [ a; b; c; d ] ->
      let i = int_of_string in
      Int32.of_int (((i a land 0xff) lsl 24) lor ((i b land 0xff) lsl 16) lor ((i c land 0xff) lsl 8) lor (i d land 0xff))
  | _ -> failwith "unexpected version format"

let string_of_version_u32 (v : int32) =
  let byte n = Int32.to_int (Int32.logand (Int32.shift_right_logical v n) 0xffl) in
  Printf.sprintf "%d.%d.%d.%d" (byte 24) (byte 16) (byte 8) (byte 0)
