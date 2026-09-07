(** @canonical Wgpu.Fn *)

(* Raw WebGPU / wgpu-native entry points.

   GENERATED FILE -- DO NOT EDIT.

   Produced by [gen/gen.ml] from the vendored headers
   [vendor/wgpu-native/include/webgpu/{webgpu,wgpu}.h], pinned at
   wgpu-native 29.0.1.1 (commit 6aed50955d934ac36049ba8d002034841633ae02, webgpu-headers 673658bc2bd70ec39fc55ebe6bb0173cf6d0a603).

   Run [dune build @gen] to regenerate and [dune promote] to accept. *)

(* One OCaml function per C entry point, keeping the exact C name.  Symbols
   are resolved lazily on first call through {!Wgpu_loader}, so simply
   referring to this module does not load libwgpu_native. *)

open Wgpu_types

(** [wgpuCreateInstance] (from webgpu.h)

    [(* descriptor *) InstanceDescriptor.t Ctypes.ptr -> Instance.t] *)
let wgpuCreateInstance =
  let s = lazy (Wgpu_loader.foreign "wgpuCreateInstance" Ctypes.((Ctypes.ptr InstanceDescriptor.t) @-> Ctypes.returning Instance.t)) in
  fun descriptor -> (Lazy.force s) descriptor

(** [wgpuGetInstanceFeatures] (from webgpu.h)

    [(* features *) SupportedInstanceFeatures.t Ctypes.ptr -> unit] *)
let wgpuGetInstanceFeatures =
  let s = lazy (Wgpu_loader.foreign "wgpuGetInstanceFeatures" Ctypes.((Ctypes.ptr SupportedInstanceFeatures.t) @-> Ctypes.returning Ctypes.void)) in
  fun features -> (Lazy.force s) features

(** [wgpuGetInstanceLimits] (from webgpu.h)

    [(* limits *) InstanceLimits.t Ctypes.ptr -> Status.t] *)
let wgpuGetInstanceLimits =
  let s = lazy (Wgpu_loader.foreign "wgpuGetInstanceLimits" Ctypes.((Ctypes.ptr InstanceLimits.t) @-> Ctypes.returning Status.t)) in
  fun limits -> (Lazy.force s) limits

(** [wgpuHasInstanceFeature] (from webgpu.h)

    [(* feature *) InstanceFeatureName.t -> Unsigned.UInt32.t] *)
let wgpuHasInstanceFeature =
  let s = lazy (Wgpu_loader.foreign "wgpuHasInstanceFeature" Ctypes.(InstanceFeatureName.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun feature -> (Lazy.force s) feature

(** [wgpuGetProcAddress] (from webgpu.h)

    [(* procName *) StringView.t -> Proc.t] *)
let wgpuGetProcAddress =
  let s = lazy (Wgpu_loader.foreign "wgpuGetProcAddress" Ctypes.(StringView.t @-> Ctypes.returning Proc.t)) in
  fun procName -> (Lazy.force s) procName

(** [wgpuAdapterGetFeatures] (from webgpu.h)

    [(* adapter *) Adapter.t -> (* features *) SupportedFeatures.t Ctypes.ptr -> unit] *)
let wgpuAdapterGetFeatures =
  let s = lazy (Wgpu_loader.foreign "wgpuAdapterGetFeatures" Ctypes.(Adapter.t @-> (Ctypes.ptr SupportedFeatures.t) @-> Ctypes.returning Ctypes.void)) in
  fun adapter features -> (Lazy.force s) adapter features

(** [wgpuAdapterGetInfo] (from webgpu.h)

    [(* adapter *) Adapter.t -> (* info *) AdapterInfo.t Ctypes.ptr -> Status.t] *)
let wgpuAdapterGetInfo =
  let s = lazy (Wgpu_loader.foreign "wgpuAdapterGetInfo" Ctypes.(Adapter.t @-> (Ctypes.ptr AdapterInfo.t) @-> Ctypes.returning Status.t)) in
  fun adapter info -> (Lazy.force s) adapter info

(** [wgpuAdapterGetLimits] (from webgpu.h)

    [(* adapter *) Adapter.t -> (* limits *) Limits.t Ctypes.ptr -> Status.t] *)
let wgpuAdapterGetLimits =
  let s = lazy (Wgpu_loader.foreign "wgpuAdapterGetLimits" Ctypes.(Adapter.t @-> (Ctypes.ptr Limits.t) @-> Ctypes.returning Status.t)) in
  fun adapter limits -> (Lazy.force s) adapter limits

(** [wgpuAdapterHasFeature] (from webgpu.h)

    [(* adapter *) Adapter.t -> (* feature *) FeatureName.t -> Unsigned.UInt32.t] *)
let wgpuAdapterHasFeature =
  let s = lazy (Wgpu_loader.foreign "wgpuAdapterHasFeature" Ctypes.(Adapter.t @-> FeatureName.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun adapter feature -> (Lazy.force s) adapter feature

(** [wgpuAdapterRequestDevice] (from webgpu.h)

    [(* adapter *) Adapter.t -> (* descriptor *) DeviceDescriptor.t Ctypes.ptr -> (* callbackInfo *) RequestDeviceCallbackInfo.t -> Future.t] *)
let wgpuAdapterRequestDevice =
  let s = lazy (Wgpu_loader.foreign "wgpuAdapterRequestDevice" Ctypes.(Adapter.t @-> (Ctypes.ptr DeviceDescriptor.t) @-> RequestDeviceCallbackInfo.t @-> Ctypes.returning Future.t)) in
  fun adapter descriptor callbackInfo -> (Lazy.force s) adapter descriptor callbackInfo

(** [wgpuAdapterAddRef] (from webgpu.h)

    [(* adapter *) Adapter.t -> unit] *)
let wgpuAdapterAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuAdapterAddRef" Ctypes.(Adapter.t @-> Ctypes.returning Ctypes.void)) in
  fun adapter -> (Lazy.force s) adapter

(** [wgpuAdapterRelease] (from webgpu.h)

    [(* adapter *) Adapter.t -> unit] *)
let wgpuAdapterRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuAdapterRelease" Ctypes.(Adapter.t @-> Ctypes.returning Ctypes.void)) in
  fun adapter -> (Lazy.force s) adapter

(** [wgpuAdapterInfoFreeMembers] (from webgpu.h)

    [(* adapterInfo *) AdapterInfo.t -> unit] *)
let wgpuAdapterInfoFreeMembers =
  let s = lazy (Wgpu_loader.foreign "wgpuAdapterInfoFreeMembers" Ctypes.(AdapterInfo.t @-> Ctypes.returning Ctypes.void)) in
  fun adapterInfo -> (Lazy.force s) adapterInfo

(** [wgpuBindGroupSetLabel] (from webgpu.h)

    [(* bindGroup *) BindGroup.t -> (* label *) StringView.t -> unit] *)
let wgpuBindGroupSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuBindGroupSetLabel" Ctypes.(BindGroup.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun bindGroup label -> (Lazy.force s) bindGroup label

(** [wgpuBindGroupAddRef] (from webgpu.h)

    [(* bindGroup *) BindGroup.t -> unit] *)
let wgpuBindGroupAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuBindGroupAddRef" Ctypes.(BindGroup.t @-> Ctypes.returning Ctypes.void)) in
  fun bindGroup -> (Lazy.force s) bindGroup

(** [wgpuBindGroupRelease] (from webgpu.h)

    [(* bindGroup *) BindGroup.t -> unit] *)
let wgpuBindGroupRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuBindGroupRelease" Ctypes.(BindGroup.t @-> Ctypes.returning Ctypes.void)) in
  fun bindGroup -> (Lazy.force s) bindGroup

(** [wgpuBindGroupLayoutSetLabel] (from webgpu.h)

    [(* bindGroupLayout *) BindGroupLayout.t -> (* label *) StringView.t -> unit] *)
let wgpuBindGroupLayoutSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuBindGroupLayoutSetLabel" Ctypes.(BindGroupLayout.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun bindGroupLayout label -> (Lazy.force s) bindGroupLayout label

(** [wgpuBindGroupLayoutAddRef] (from webgpu.h)

    [(* bindGroupLayout *) BindGroupLayout.t -> unit] *)
let wgpuBindGroupLayoutAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuBindGroupLayoutAddRef" Ctypes.(BindGroupLayout.t @-> Ctypes.returning Ctypes.void)) in
  fun bindGroupLayout -> (Lazy.force s) bindGroupLayout

(** [wgpuBindGroupLayoutRelease] (from webgpu.h)

    [(* bindGroupLayout *) BindGroupLayout.t -> unit] *)
let wgpuBindGroupLayoutRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuBindGroupLayoutRelease" Ctypes.(BindGroupLayout.t @-> Ctypes.returning Ctypes.void)) in
  fun bindGroupLayout -> (Lazy.force s) bindGroupLayout

(** [wgpuBufferDestroy] (from webgpu.h)

    [(* buffer *) Buffer.t -> unit] *)
let wgpuBufferDestroy =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferDestroy" Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.void)) in
  fun buffer -> (Lazy.force s) buffer

(** [wgpuBufferGetConstMappedRange] (from webgpu.h)

    [(* buffer *) Buffer.t -> (* offset *) Unsigned.Size_t.t -> (* size *) Unsigned.Size_t.t -> unit Ctypes.ptr] *)
let wgpuBufferGetConstMappedRange =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferGetConstMappedRange" Ctypes.(Buffer.t @-> Ctypes.size_t @-> Ctypes.size_t @-> Ctypes.returning (Ctypes.ptr Ctypes.void))) in
  fun buffer offset size -> (Lazy.force s) buffer offset size

(** [wgpuBufferGetMappedRange] (from webgpu.h)

    [(* buffer *) Buffer.t -> (* offset *) Unsigned.Size_t.t -> (* size *) Unsigned.Size_t.t -> unit Ctypes.ptr] *)
let wgpuBufferGetMappedRange =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferGetMappedRange" Ctypes.(Buffer.t @-> Ctypes.size_t @-> Ctypes.size_t @-> Ctypes.returning (Ctypes.ptr Ctypes.void))) in
  fun buffer offset size -> (Lazy.force s) buffer offset size

(** [wgpuBufferGetMapState] (from webgpu.h)

    [(* buffer *) Buffer.t -> BufferMapState.t] *)
let wgpuBufferGetMapState =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferGetMapState" Ctypes.(Buffer.t @-> Ctypes.returning BufferMapState.t)) in
  fun buffer -> (Lazy.force s) buffer

(** [wgpuBufferGetSize] (from webgpu.h)

    [(* buffer *) Buffer.t -> Unsigned.UInt64.t] *)
let wgpuBufferGetSize =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferGetSize" Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.uint64_t)) in
  fun buffer -> (Lazy.force s) buffer

(** [wgpuBufferGetUsage] (from webgpu.h)

    [(* buffer *) Buffer.t -> BufferUsage.t] *)
let wgpuBufferGetUsage =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferGetUsage" Ctypes.(Buffer.t @-> Ctypes.returning BufferUsage.t)) in
  fun buffer -> (Lazy.force s) buffer

(** [wgpuBufferMapAsync] (from webgpu.h)

    [(* buffer *) Buffer.t -> (* mode *) MapMode.t -> (* offset *) Unsigned.Size_t.t -> (* size *) Unsigned.Size_t.t -> (* callbackInfo *) BufferMapCallbackInfo.t -> Future.t] *)
let wgpuBufferMapAsync =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferMapAsync" Ctypes.(Buffer.t @-> MapMode.t @-> Ctypes.size_t @-> Ctypes.size_t @-> BufferMapCallbackInfo.t @-> Ctypes.returning Future.t)) in
  fun buffer mode offset size callbackInfo -> (Lazy.force s) buffer mode offset size callbackInfo

(** [wgpuBufferReadMappedRange] (from webgpu.h)

    [(* buffer *) Buffer.t -> (* offset *) Unsigned.Size_t.t -> (* data *) unit Ctypes.ptr -> (* size *) Unsigned.Size_t.t -> Status.t] *)
let wgpuBufferReadMappedRange =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferReadMappedRange" Ctypes.(Buffer.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Status.t)) in
  fun buffer offset data size -> (Lazy.force s) buffer offset data size

(** [wgpuBufferSetLabel] (from webgpu.h)

    [(* buffer *) Buffer.t -> (* label *) StringView.t -> unit] *)
let wgpuBufferSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferSetLabel" Ctypes.(Buffer.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun buffer label -> (Lazy.force s) buffer label

(** [wgpuBufferUnmap] (from webgpu.h)

    [(* buffer *) Buffer.t -> unit] *)
let wgpuBufferUnmap =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferUnmap" Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.void)) in
  fun buffer -> (Lazy.force s) buffer

(** [wgpuBufferWriteMappedRange] (from webgpu.h)

    [(* buffer *) Buffer.t -> (* offset *) Unsigned.Size_t.t -> (* data *) unit Ctypes.ptr -> (* size *) Unsigned.Size_t.t -> Status.t] *)
let wgpuBufferWriteMappedRange =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferWriteMappedRange" Ctypes.(Buffer.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Status.t)) in
  fun buffer offset data size -> (Lazy.force s) buffer offset data size

(** [wgpuBufferAddRef] (from webgpu.h)

    [(* buffer *) Buffer.t -> unit] *)
let wgpuBufferAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferAddRef" Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.void)) in
  fun buffer -> (Lazy.force s) buffer

(** [wgpuBufferRelease] (from webgpu.h)

    [(* buffer *) Buffer.t -> unit] *)
let wgpuBufferRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuBufferRelease" Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.void)) in
  fun buffer -> (Lazy.force s) buffer

(** [wgpuCommandBufferSetLabel] (from webgpu.h)

    [(* commandBuffer *) CommandBuffer.t -> (* label *) StringView.t -> unit] *)
let wgpuCommandBufferSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandBufferSetLabel" Ctypes.(CommandBuffer.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun commandBuffer label -> (Lazy.force s) commandBuffer label

(** [wgpuCommandBufferAddRef] (from webgpu.h)

    [(* commandBuffer *) CommandBuffer.t -> unit] *)
let wgpuCommandBufferAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandBufferAddRef" Ctypes.(CommandBuffer.t @-> Ctypes.returning Ctypes.void)) in
  fun commandBuffer -> (Lazy.force s) commandBuffer

(** [wgpuCommandBufferRelease] (from webgpu.h)

    [(* commandBuffer *) CommandBuffer.t -> unit] *)
let wgpuCommandBufferRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandBufferRelease" Ctypes.(CommandBuffer.t @-> Ctypes.returning Ctypes.void)) in
  fun commandBuffer -> (Lazy.force s) commandBuffer

(** [wgpuCommandEncoderBeginComputePass] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* descriptor *) ComputePassDescriptor.t Ctypes.ptr -> ComputePassEncoder.t] *)
let wgpuCommandEncoderBeginComputePass =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderBeginComputePass" Ctypes.(CommandEncoder.t @-> (Ctypes.ptr ComputePassDescriptor.t) @-> Ctypes.returning ComputePassEncoder.t)) in
  fun commandEncoder descriptor -> (Lazy.force s) commandEncoder descriptor

(** [wgpuCommandEncoderBeginRenderPass] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* descriptor *) RenderPassDescriptor.t Ctypes.ptr -> RenderPassEncoder.t] *)
let wgpuCommandEncoderBeginRenderPass =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderBeginRenderPass" Ctypes.(CommandEncoder.t @-> (Ctypes.ptr RenderPassDescriptor.t) @-> Ctypes.returning RenderPassEncoder.t)) in
  fun commandEncoder descriptor -> (Lazy.force s) commandEncoder descriptor

(** [wgpuCommandEncoderClearBuffer] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* buffer *) Buffer.t -> (* offset *) Unsigned.UInt64.t -> (* size *) Unsigned.UInt64.t -> unit] *)
let wgpuCommandEncoderClearBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderClearBuffer" Ctypes.(CommandEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder buffer offset size -> (Lazy.force s) commandEncoder buffer offset size

(** [wgpuCommandEncoderCopyBufferToBuffer] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* source *) Buffer.t -> (* sourceOffset *) Unsigned.UInt64.t -> (* destination *) Buffer.t -> (* destinationOffset *) Unsigned.UInt64.t -> (* size *) Unsigned.UInt64.t -> unit] *)
let wgpuCommandEncoderCopyBufferToBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderCopyBufferToBuffer" Ctypes.(CommandEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder source sourceOffset destination destinationOffset size -> (Lazy.force s) commandEncoder source sourceOffset destination destinationOffset size

(** [wgpuCommandEncoderCopyBufferToTexture] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* source *) TexelCopyBufferInfo.t Ctypes.ptr -> (* destination *) TexelCopyTextureInfo.t Ctypes.ptr -> (* copySize *) Extent3D.t Ctypes.ptr -> unit] *)
let wgpuCommandEncoderCopyBufferToTexture =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderCopyBufferToTexture" Ctypes.(CommandEncoder.t @-> (Ctypes.ptr TexelCopyBufferInfo.t) @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr Extent3D.t) @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder source destination copySize -> (Lazy.force s) commandEncoder source destination copySize

(** [wgpuCommandEncoderCopyTextureToBuffer] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* source *) TexelCopyTextureInfo.t Ctypes.ptr -> (* destination *) TexelCopyBufferInfo.t Ctypes.ptr -> (* copySize *) Extent3D.t Ctypes.ptr -> unit] *)
let wgpuCommandEncoderCopyTextureToBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderCopyTextureToBuffer" Ctypes.(CommandEncoder.t @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr TexelCopyBufferInfo.t) @-> (Ctypes.ptr Extent3D.t) @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder source destination copySize -> (Lazy.force s) commandEncoder source destination copySize

(** [wgpuCommandEncoderCopyTextureToTexture] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* source *) TexelCopyTextureInfo.t Ctypes.ptr -> (* destination *) TexelCopyTextureInfo.t Ctypes.ptr -> (* copySize *) Extent3D.t Ctypes.ptr -> unit] *)
let wgpuCommandEncoderCopyTextureToTexture =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderCopyTextureToTexture" Ctypes.(CommandEncoder.t @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr Extent3D.t) @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder source destination copySize -> (Lazy.force s) commandEncoder source destination copySize

(** [wgpuCommandEncoderFinish] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* descriptor *) CommandBufferDescriptor.t Ctypes.ptr -> CommandBuffer.t] *)
let wgpuCommandEncoderFinish =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderFinish" Ctypes.(CommandEncoder.t @-> (Ctypes.ptr CommandBufferDescriptor.t) @-> Ctypes.returning CommandBuffer.t)) in
  fun commandEncoder descriptor -> (Lazy.force s) commandEncoder descriptor

(** [wgpuCommandEncoderInsertDebugMarker] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* markerLabel *) StringView.t -> unit] *)
let wgpuCommandEncoderInsertDebugMarker =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderInsertDebugMarker" Ctypes.(CommandEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder markerLabel -> (Lazy.force s) commandEncoder markerLabel

(** [wgpuCommandEncoderPopDebugGroup] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> unit] *)
let wgpuCommandEncoderPopDebugGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderPopDebugGroup" Ctypes.(CommandEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder -> (Lazy.force s) commandEncoder

(** [wgpuCommandEncoderPushDebugGroup] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* groupLabel *) StringView.t -> unit] *)
let wgpuCommandEncoderPushDebugGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderPushDebugGroup" Ctypes.(CommandEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder groupLabel -> (Lazy.force s) commandEncoder groupLabel

(** [wgpuCommandEncoderResolveQuerySet] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* querySet *) QuerySet.t -> (* firstQuery *) Unsigned.UInt32.t -> (* queryCount *) Unsigned.UInt32.t -> (* destination *) Buffer.t -> (* destinationOffset *) Unsigned.UInt64.t -> unit] *)
let wgpuCommandEncoderResolveQuerySet =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderResolveQuerySet" Ctypes.(CommandEncoder.t @-> QuerySet.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder querySet firstQuery queryCount destination destinationOffset -> (Lazy.force s) commandEncoder querySet firstQuery queryCount destination destinationOffset

(** [wgpuCommandEncoderSetLabel] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* label *) StringView.t -> unit] *)
let wgpuCommandEncoderSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderSetLabel" Ctypes.(CommandEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder label -> (Lazy.force s) commandEncoder label

(** [wgpuCommandEncoderWriteTimestamp] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* querySet *) QuerySet.t -> (* queryIndex *) Unsigned.UInt32.t -> unit] *)
let wgpuCommandEncoderWriteTimestamp =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderWriteTimestamp" Ctypes.(CommandEncoder.t @-> QuerySet.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder querySet queryIndex -> (Lazy.force s) commandEncoder querySet queryIndex

(** [wgpuCommandEncoderAddRef] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> unit] *)
let wgpuCommandEncoderAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderAddRef" Ctypes.(CommandEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder -> (Lazy.force s) commandEncoder

(** [wgpuCommandEncoderRelease] (from webgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> unit] *)
let wgpuCommandEncoderRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderRelease" Ctypes.(CommandEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder -> (Lazy.force s) commandEncoder

(** [wgpuComputePassEncoderDispatchWorkgroups] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* workgroupCountX *) Unsigned.UInt32.t -> (* workgroupCountY *) Unsigned.UInt32.t -> (* workgroupCountZ *) Unsigned.UInt32.t -> unit] *)
let wgpuComputePassEncoderDispatchWorkgroups =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderDispatchWorkgroups" Ctypes.(ComputePassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder workgroupCountX workgroupCountY workgroupCountZ -> (Lazy.force s) computePassEncoder workgroupCountX workgroupCountY workgroupCountZ

(** [wgpuComputePassEncoderDispatchWorkgroupsIndirect] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* indirectBuffer *) Buffer.t -> (* indirectOffset *) Unsigned.UInt64.t -> unit] *)
let wgpuComputePassEncoderDispatchWorkgroupsIndirect =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderDispatchWorkgroupsIndirect" Ctypes.(ComputePassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder indirectBuffer indirectOffset -> (Lazy.force s) computePassEncoder indirectBuffer indirectOffset

(** [wgpuComputePassEncoderEnd] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> unit] *)
let wgpuComputePassEncoderEnd =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderEnd" Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder -> (Lazy.force s) computePassEncoder

(** [wgpuComputePassEncoderInsertDebugMarker] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* markerLabel *) StringView.t -> unit] *)
let wgpuComputePassEncoderInsertDebugMarker =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderInsertDebugMarker" Ctypes.(ComputePassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder markerLabel -> (Lazy.force s) computePassEncoder markerLabel

(** [wgpuComputePassEncoderPopDebugGroup] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> unit] *)
let wgpuComputePassEncoderPopDebugGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderPopDebugGroup" Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder -> (Lazy.force s) computePassEncoder

(** [wgpuComputePassEncoderPushDebugGroup] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* groupLabel *) StringView.t -> unit] *)
let wgpuComputePassEncoderPushDebugGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderPushDebugGroup" Ctypes.(ComputePassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder groupLabel -> (Lazy.force s) computePassEncoder groupLabel

(** [wgpuComputePassEncoderSetBindGroup] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* groupIndex *) Unsigned.UInt32.t -> (* group *) BindGroup.t -> (* dynamicOffsetCount *) Unsigned.Size_t.t -> (* dynamicOffsets *) Unsigned.UInt32.t Ctypes.ptr -> unit] *)
let wgpuComputePassEncoderSetBindGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderSetBindGroup" Ctypes.(ComputePassEncoder.t @-> Ctypes.uint32_t @-> BindGroup.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.uint32_t) @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder groupIndex group dynamicOffsetCount dynamicOffsets -> (Lazy.force s) computePassEncoder groupIndex group dynamicOffsetCount dynamicOffsets

(** [wgpuComputePassEncoderSetImmediates] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* offset *) Unsigned.UInt32.t -> (* data *) unit Ctypes.ptr -> (* size *) Unsigned.Size_t.t -> unit] *)
let wgpuComputePassEncoderSetImmediates =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderSetImmediates" Ctypes.(ComputePassEncoder.t @-> Ctypes.uint32_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder offset data size -> (Lazy.force s) computePassEncoder offset data size

(** [wgpuComputePassEncoderSetLabel] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* label *) StringView.t -> unit] *)
let wgpuComputePassEncoderSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderSetLabel" Ctypes.(ComputePassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder label -> (Lazy.force s) computePassEncoder label

(** [wgpuComputePassEncoderSetPipeline] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* pipeline *) ComputePipeline.t -> unit] *)
let wgpuComputePassEncoderSetPipeline =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderSetPipeline" Ctypes.(ComputePassEncoder.t @-> ComputePipeline.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder pipeline -> (Lazy.force s) computePassEncoder pipeline

(** [wgpuComputePassEncoderAddRef] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> unit] *)
let wgpuComputePassEncoderAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderAddRef" Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder -> (Lazy.force s) computePassEncoder

(** [wgpuComputePassEncoderRelease] (from webgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> unit] *)
let wgpuComputePassEncoderRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderRelease" Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder -> (Lazy.force s) computePassEncoder

(** [wgpuComputePipelineGetBindGroupLayout] (from webgpu.h)

    [(* computePipeline *) ComputePipeline.t -> (* groupIndex *) Unsigned.UInt32.t -> BindGroupLayout.t] *)
let wgpuComputePipelineGetBindGroupLayout =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePipelineGetBindGroupLayout" Ctypes.(ComputePipeline.t @-> Ctypes.uint32_t @-> Ctypes.returning BindGroupLayout.t)) in
  fun computePipeline groupIndex -> (Lazy.force s) computePipeline groupIndex

(** [wgpuComputePipelineSetLabel] (from webgpu.h)

    [(* computePipeline *) ComputePipeline.t -> (* label *) StringView.t -> unit] *)
let wgpuComputePipelineSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePipelineSetLabel" Ctypes.(ComputePipeline.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun computePipeline label -> (Lazy.force s) computePipeline label

(** [wgpuComputePipelineAddRef] (from webgpu.h)

    [(* computePipeline *) ComputePipeline.t -> unit] *)
let wgpuComputePipelineAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePipelineAddRef" Ctypes.(ComputePipeline.t @-> Ctypes.returning Ctypes.void)) in
  fun computePipeline -> (Lazy.force s) computePipeline

(** [wgpuComputePipelineRelease] (from webgpu.h)

    [(* computePipeline *) ComputePipeline.t -> unit] *)
let wgpuComputePipelineRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePipelineRelease" Ctypes.(ComputePipeline.t @-> Ctypes.returning Ctypes.void)) in
  fun computePipeline -> (Lazy.force s) computePipeline

(** [wgpuDeviceCreateBindGroup] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) BindGroupDescriptor.t Ctypes.ptr -> BindGroup.t] *)
let wgpuDeviceCreateBindGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateBindGroup" Ctypes.(Device.t @-> (Ctypes.ptr BindGroupDescriptor.t) @-> Ctypes.returning BindGroup.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateBindGroupLayout] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) BindGroupLayoutDescriptor.t Ctypes.ptr -> BindGroupLayout.t] *)
let wgpuDeviceCreateBindGroupLayout =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateBindGroupLayout" Ctypes.(Device.t @-> (Ctypes.ptr BindGroupLayoutDescriptor.t) @-> Ctypes.returning BindGroupLayout.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateBuffer] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) BufferDescriptor.t Ctypes.ptr -> Buffer.t] *)
let wgpuDeviceCreateBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateBuffer" Ctypes.(Device.t @-> (Ctypes.ptr BufferDescriptor.t) @-> Ctypes.returning Buffer.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateCommandEncoder] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) CommandEncoderDescriptor.t Ctypes.ptr -> CommandEncoder.t] *)
let wgpuDeviceCreateCommandEncoder =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateCommandEncoder" Ctypes.(Device.t @-> (Ctypes.ptr CommandEncoderDescriptor.t) @-> Ctypes.returning CommandEncoder.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateComputePipeline] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) ComputePipelineDescriptor.t Ctypes.ptr -> ComputePipeline.t] *)
let wgpuDeviceCreateComputePipeline =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateComputePipeline" Ctypes.(Device.t @-> (Ctypes.ptr ComputePipelineDescriptor.t) @-> Ctypes.returning ComputePipeline.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateComputePipelineAsync] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) ComputePipelineDescriptor.t Ctypes.ptr -> (* callbackInfo *) CreateComputePipelineAsyncCallbackInfo.t -> Future.t] *)
let wgpuDeviceCreateComputePipelineAsync =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateComputePipelineAsync" Ctypes.(Device.t @-> (Ctypes.ptr ComputePipelineDescriptor.t) @-> CreateComputePipelineAsyncCallbackInfo.t @-> Ctypes.returning Future.t)) in
  fun device descriptor callbackInfo -> (Lazy.force s) device descriptor callbackInfo

(** [wgpuDeviceCreatePipelineLayout] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) PipelineLayoutDescriptor.t Ctypes.ptr -> PipelineLayout.t] *)
let wgpuDeviceCreatePipelineLayout =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreatePipelineLayout" Ctypes.(Device.t @-> (Ctypes.ptr PipelineLayoutDescriptor.t) @-> Ctypes.returning PipelineLayout.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateQuerySet] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) QuerySetDescriptor.t Ctypes.ptr -> QuerySet.t] *)
let wgpuDeviceCreateQuerySet =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateQuerySet" Ctypes.(Device.t @-> (Ctypes.ptr QuerySetDescriptor.t) @-> Ctypes.returning QuerySet.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateRenderBundleEncoder] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) RenderBundleEncoderDescriptor.t Ctypes.ptr -> RenderBundleEncoder.t] *)
let wgpuDeviceCreateRenderBundleEncoder =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateRenderBundleEncoder" Ctypes.(Device.t @-> (Ctypes.ptr RenderBundleEncoderDescriptor.t) @-> Ctypes.returning RenderBundleEncoder.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateRenderPipeline] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) RenderPipelineDescriptor.t Ctypes.ptr -> RenderPipeline.t] *)
let wgpuDeviceCreateRenderPipeline =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateRenderPipeline" Ctypes.(Device.t @-> (Ctypes.ptr RenderPipelineDescriptor.t) @-> Ctypes.returning RenderPipeline.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateRenderPipelineAsync] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) RenderPipelineDescriptor.t Ctypes.ptr -> (* callbackInfo *) CreateRenderPipelineAsyncCallbackInfo.t -> Future.t] *)
let wgpuDeviceCreateRenderPipelineAsync =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateRenderPipelineAsync" Ctypes.(Device.t @-> (Ctypes.ptr RenderPipelineDescriptor.t) @-> CreateRenderPipelineAsyncCallbackInfo.t @-> Ctypes.returning Future.t)) in
  fun device descriptor callbackInfo -> (Lazy.force s) device descriptor callbackInfo

(** [wgpuDeviceCreateSampler] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) SamplerDescriptor.t Ctypes.ptr -> Sampler.t] *)
let wgpuDeviceCreateSampler =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateSampler" Ctypes.(Device.t @-> (Ctypes.ptr SamplerDescriptor.t) @-> Ctypes.returning Sampler.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateShaderModule] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) ShaderModuleDescriptor.t Ctypes.ptr -> ShaderModule.t] *)
let wgpuDeviceCreateShaderModule =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateShaderModule" Ctypes.(Device.t @-> (Ctypes.ptr ShaderModuleDescriptor.t) @-> Ctypes.returning ShaderModule.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceCreateTexture] (from webgpu.h)

    [(* device *) Device.t -> (* descriptor *) TextureDescriptor.t Ctypes.ptr -> Texture.t] *)
let wgpuDeviceCreateTexture =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateTexture" Ctypes.(Device.t @-> (Ctypes.ptr TextureDescriptor.t) @-> Ctypes.returning Texture.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuDeviceDestroy] (from webgpu.h)

    [(* device *) Device.t -> unit] *)
let wgpuDeviceDestroy =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceDestroy" Ctypes.(Device.t @-> Ctypes.returning Ctypes.void)) in
  fun device -> (Lazy.force s) device

(** [wgpuDeviceGetAdapterInfo] (from webgpu.h)

    [(* device *) Device.t -> (* adapterInfo *) AdapterInfo.t Ctypes.ptr -> Status.t] *)
let wgpuDeviceGetAdapterInfo =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceGetAdapterInfo" Ctypes.(Device.t @-> (Ctypes.ptr AdapterInfo.t) @-> Ctypes.returning Status.t)) in
  fun device adapterInfo -> (Lazy.force s) device adapterInfo

(** [wgpuDeviceGetFeatures] (from webgpu.h)

    [(* device *) Device.t -> (* features *) SupportedFeatures.t Ctypes.ptr -> unit] *)
let wgpuDeviceGetFeatures =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceGetFeatures" Ctypes.(Device.t @-> (Ctypes.ptr SupportedFeatures.t) @-> Ctypes.returning Ctypes.void)) in
  fun device features -> (Lazy.force s) device features

(** [wgpuDeviceGetLimits] (from webgpu.h)

    [(* device *) Device.t -> (* limits *) Limits.t Ctypes.ptr -> Status.t] *)
let wgpuDeviceGetLimits =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceGetLimits" Ctypes.(Device.t @-> (Ctypes.ptr Limits.t) @-> Ctypes.returning Status.t)) in
  fun device limits -> (Lazy.force s) device limits

(** [wgpuDeviceGetLostFuture] (from webgpu.h)

    [(* device *) Device.t -> Future.t] *)
let wgpuDeviceGetLostFuture =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceGetLostFuture" Ctypes.(Device.t @-> Ctypes.returning Future.t)) in
  fun device -> (Lazy.force s) device

(** [wgpuDeviceGetQueue] (from webgpu.h)

    [(* device *) Device.t -> Queue.t] *)
let wgpuDeviceGetQueue =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceGetQueue" Ctypes.(Device.t @-> Ctypes.returning Queue.t)) in
  fun device -> (Lazy.force s) device

(** [wgpuDeviceHasFeature] (from webgpu.h)

    [(* device *) Device.t -> (* feature *) FeatureName.t -> Unsigned.UInt32.t] *)
let wgpuDeviceHasFeature =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceHasFeature" Ctypes.(Device.t @-> FeatureName.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun device feature -> (Lazy.force s) device feature

(** [wgpuDevicePopErrorScope] (from webgpu.h)

    [(* device *) Device.t -> (* callbackInfo *) PopErrorScopeCallbackInfo.t -> Future.t] *)
let wgpuDevicePopErrorScope =
  let s = lazy (Wgpu_loader.foreign "wgpuDevicePopErrorScope" Ctypes.(Device.t @-> PopErrorScopeCallbackInfo.t @-> Ctypes.returning Future.t)) in
  fun device callbackInfo -> (Lazy.force s) device callbackInfo

(** [wgpuDevicePushErrorScope] (from webgpu.h)

    [(* device *) Device.t -> (* filter *) ErrorFilter.t -> unit] *)
let wgpuDevicePushErrorScope =
  let s = lazy (Wgpu_loader.foreign "wgpuDevicePushErrorScope" Ctypes.(Device.t @-> ErrorFilter.t @-> Ctypes.returning Ctypes.void)) in
  fun device filter -> (Lazy.force s) device filter

(** [wgpuDeviceSetLabel] (from webgpu.h)

    [(* device *) Device.t -> (* label *) StringView.t -> unit] *)
let wgpuDeviceSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceSetLabel" Ctypes.(Device.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun device label -> (Lazy.force s) device label

(** [wgpuDeviceAddRef] (from webgpu.h)

    [(* device *) Device.t -> unit] *)
let wgpuDeviceAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceAddRef" Ctypes.(Device.t @-> Ctypes.returning Ctypes.void)) in
  fun device -> (Lazy.force s) device

(** [wgpuDeviceRelease] (from webgpu.h)

    [(* device *) Device.t -> unit] *)
let wgpuDeviceRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceRelease" Ctypes.(Device.t @-> Ctypes.returning Ctypes.void)) in
  fun device -> (Lazy.force s) device

(** [wgpuExternalTextureSetLabel] (from webgpu.h)

    [(* externalTexture *) ExternalTexture.t -> (* label *) StringView.t -> unit] *)
let wgpuExternalTextureSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuExternalTextureSetLabel" Ctypes.(ExternalTexture.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun externalTexture label -> (Lazy.force s) externalTexture label

(** [wgpuExternalTextureAddRef] (from webgpu.h)

    [(* externalTexture *) ExternalTexture.t -> unit] *)
let wgpuExternalTextureAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuExternalTextureAddRef" Ctypes.(ExternalTexture.t @-> Ctypes.returning Ctypes.void)) in
  fun externalTexture -> (Lazy.force s) externalTexture

(** [wgpuExternalTextureRelease] (from webgpu.h)

    [(* externalTexture *) ExternalTexture.t -> unit] *)
let wgpuExternalTextureRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuExternalTextureRelease" Ctypes.(ExternalTexture.t @-> Ctypes.returning Ctypes.void)) in
  fun externalTexture -> (Lazy.force s) externalTexture

(** [wgpuInstanceCreateSurface] (from webgpu.h)

    [(* instance *) Instance.t -> (* descriptor *) SurfaceDescriptor.t Ctypes.ptr -> Surface.t] *)
let wgpuInstanceCreateSurface =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceCreateSurface" Ctypes.(Instance.t @-> (Ctypes.ptr SurfaceDescriptor.t) @-> Ctypes.returning Surface.t)) in
  fun instance descriptor -> (Lazy.force s) instance descriptor

(** [wgpuInstanceGetWGSLLanguageFeatures] (from webgpu.h)

    [(* instance *) Instance.t -> (* features *) SupportedWGSLLanguageFeatures.t Ctypes.ptr -> unit] *)
let wgpuInstanceGetWGSLLanguageFeatures =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceGetWGSLLanguageFeatures" Ctypes.(Instance.t @-> (Ctypes.ptr SupportedWGSLLanguageFeatures.t) @-> Ctypes.returning Ctypes.void)) in
  fun instance features -> (Lazy.force s) instance features

(** [wgpuInstanceHasWGSLLanguageFeature] (from webgpu.h)

    [(* instance *) Instance.t -> (* feature *) WGSLLanguageFeatureName.t -> Unsigned.UInt32.t] *)
let wgpuInstanceHasWGSLLanguageFeature =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceHasWGSLLanguageFeature" Ctypes.(Instance.t @-> WGSLLanguageFeatureName.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun instance feature -> (Lazy.force s) instance feature

(** [wgpuInstanceProcessEvents] (from webgpu.h)

    [(* instance *) Instance.t -> unit] *)
let wgpuInstanceProcessEvents =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceProcessEvents" Ctypes.(Instance.t @-> Ctypes.returning Ctypes.void)) in
  fun instance -> (Lazy.force s) instance

(** [wgpuInstanceRequestAdapter] (from webgpu.h)

    [(* instance *) Instance.t -> (* options *) RequestAdapterOptions.t Ctypes.ptr -> (* callbackInfo *) RequestAdapterCallbackInfo.t -> Future.t] *)
let wgpuInstanceRequestAdapter =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceRequestAdapter" Ctypes.(Instance.t @-> (Ctypes.ptr RequestAdapterOptions.t) @-> RequestAdapterCallbackInfo.t @-> Ctypes.returning Future.t)) in
  fun instance options callbackInfo -> (Lazy.force s) instance options callbackInfo

(** [wgpuInstanceWaitAny] (from webgpu.h)

    [(* instance *) Instance.t -> (* futureCount *) Unsigned.Size_t.t -> (* futures *) FutureWaitInfo.t Ctypes.ptr -> (* timeoutNS *) Unsigned.UInt64.t -> WaitStatus.t] *)
let wgpuInstanceWaitAny =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceWaitAny" Ctypes.(Instance.t @-> Ctypes.size_t @-> (Ctypes.ptr FutureWaitInfo.t) @-> Ctypes.uint64_t @-> Ctypes.returning WaitStatus.t)) in
  fun instance futureCount futures timeoutNS -> (Lazy.force s) instance futureCount futures timeoutNS

(** [wgpuInstanceAddRef] (from webgpu.h)

    [(* instance *) Instance.t -> unit] *)
let wgpuInstanceAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceAddRef" Ctypes.(Instance.t @-> Ctypes.returning Ctypes.void)) in
  fun instance -> (Lazy.force s) instance

(** [wgpuInstanceRelease] (from webgpu.h)

    [(* instance *) Instance.t -> unit] *)
let wgpuInstanceRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceRelease" Ctypes.(Instance.t @-> Ctypes.returning Ctypes.void)) in
  fun instance -> (Lazy.force s) instance

(** [wgpuPipelineLayoutSetLabel] (from webgpu.h)

    [(* pipelineLayout *) PipelineLayout.t -> (* label *) StringView.t -> unit] *)
let wgpuPipelineLayoutSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuPipelineLayoutSetLabel" Ctypes.(PipelineLayout.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun pipelineLayout label -> (Lazy.force s) pipelineLayout label

(** [wgpuPipelineLayoutAddRef] (from webgpu.h)

    [(* pipelineLayout *) PipelineLayout.t -> unit] *)
let wgpuPipelineLayoutAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuPipelineLayoutAddRef" Ctypes.(PipelineLayout.t @-> Ctypes.returning Ctypes.void)) in
  fun pipelineLayout -> (Lazy.force s) pipelineLayout

(** [wgpuPipelineLayoutRelease] (from webgpu.h)

    [(* pipelineLayout *) PipelineLayout.t -> unit] *)
let wgpuPipelineLayoutRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuPipelineLayoutRelease" Ctypes.(PipelineLayout.t @-> Ctypes.returning Ctypes.void)) in
  fun pipelineLayout -> (Lazy.force s) pipelineLayout

(** [wgpuQuerySetDestroy] (from webgpu.h)

    [(* querySet *) QuerySet.t -> unit] *)
let wgpuQuerySetDestroy =
  let s = lazy (Wgpu_loader.foreign "wgpuQuerySetDestroy" Ctypes.(QuerySet.t @-> Ctypes.returning Ctypes.void)) in
  fun querySet -> (Lazy.force s) querySet

(** [wgpuQuerySetGetCount] (from webgpu.h)

    [(* querySet *) QuerySet.t -> Unsigned.UInt32.t] *)
let wgpuQuerySetGetCount =
  let s = lazy (Wgpu_loader.foreign "wgpuQuerySetGetCount" Ctypes.(QuerySet.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun querySet -> (Lazy.force s) querySet

(** [wgpuQuerySetGetType] (from webgpu.h)

    [(* querySet *) QuerySet.t -> QueryType.t] *)
let wgpuQuerySetGetType =
  let s = lazy (Wgpu_loader.foreign "wgpuQuerySetGetType" Ctypes.(QuerySet.t @-> Ctypes.returning QueryType.t)) in
  fun querySet -> (Lazy.force s) querySet

(** [wgpuQuerySetSetLabel] (from webgpu.h)

    [(* querySet *) QuerySet.t -> (* label *) StringView.t -> unit] *)
let wgpuQuerySetSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuQuerySetSetLabel" Ctypes.(QuerySet.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun querySet label -> (Lazy.force s) querySet label

(** [wgpuQuerySetAddRef] (from webgpu.h)

    [(* querySet *) QuerySet.t -> unit] *)
let wgpuQuerySetAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuQuerySetAddRef" Ctypes.(QuerySet.t @-> Ctypes.returning Ctypes.void)) in
  fun querySet -> (Lazy.force s) querySet

(** [wgpuQuerySetRelease] (from webgpu.h)

    [(* querySet *) QuerySet.t -> unit] *)
let wgpuQuerySetRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuQuerySetRelease" Ctypes.(QuerySet.t @-> Ctypes.returning Ctypes.void)) in
  fun querySet -> (Lazy.force s) querySet

(** [wgpuQueueOnSubmittedWorkDone] (from webgpu.h)

    [(* queue *) Queue.t -> (* callbackInfo *) QueueWorkDoneCallbackInfo.t -> Future.t] *)
let wgpuQueueOnSubmittedWorkDone =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueOnSubmittedWorkDone" Ctypes.(Queue.t @-> QueueWorkDoneCallbackInfo.t @-> Ctypes.returning Future.t)) in
  fun queue callbackInfo -> (Lazy.force s) queue callbackInfo

(** [wgpuQueueSetLabel] (from webgpu.h)

    [(* queue *) Queue.t -> (* label *) StringView.t -> unit] *)
let wgpuQueueSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueSetLabel" Ctypes.(Queue.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun queue label -> (Lazy.force s) queue label

(** [wgpuQueueSubmit] (from webgpu.h)

    [(* queue *) Queue.t -> (* commandCount *) Unsigned.Size_t.t -> (* commands *) CommandBuffer.t Ctypes.ptr -> unit] *)
let wgpuQueueSubmit =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueSubmit" Ctypes.(Queue.t @-> Ctypes.size_t @-> (Ctypes.ptr CommandBuffer.t) @-> Ctypes.returning Ctypes.void)) in
  fun queue commandCount commands -> (Lazy.force s) queue commandCount commands

(** [wgpuQueueWriteBuffer] (from webgpu.h)

    [(* queue *) Queue.t -> (* buffer *) Buffer.t -> (* bufferOffset *) Unsigned.UInt64.t -> (* data *) unit Ctypes.ptr -> (* size *) Unsigned.Size_t.t -> unit] *)
let wgpuQueueWriteBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueWriteBuffer" Ctypes.(Queue.t @-> Buffer.t @-> Ctypes.uint64_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Ctypes.void)) in
  fun queue buffer bufferOffset data size -> (Lazy.force s) queue buffer bufferOffset data size

(** [wgpuQueueWriteTexture] (from webgpu.h)

    [(* queue *) Queue.t -> (* destination *) TexelCopyTextureInfo.t Ctypes.ptr -> (* data *) unit Ctypes.ptr -> (* dataSize *) Unsigned.Size_t.t -> (* dataLayout *) TexelCopyBufferLayout.t Ctypes.ptr -> (* writeSize *) Extent3D.t Ctypes.ptr -> unit] *)
let wgpuQueueWriteTexture =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueWriteTexture" Ctypes.(Queue.t @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> (Ctypes.ptr TexelCopyBufferLayout.t) @-> (Ctypes.ptr Extent3D.t) @-> Ctypes.returning Ctypes.void)) in
  fun queue destination data dataSize dataLayout writeSize -> (Lazy.force s) queue destination data dataSize dataLayout writeSize

(** [wgpuQueueAddRef] (from webgpu.h)

    [(* queue *) Queue.t -> unit] *)
let wgpuQueueAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueAddRef" Ctypes.(Queue.t @-> Ctypes.returning Ctypes.void)) in
  fun queue -> (Lazy.force s) queue

(** [wgpuQueueRelease] (from webgpu.h)

    [(* queue *) Queue.t -> unit] *)
let wgpuQueueRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueRelease" Ctypes.(Queue.t @-> Ctypes.returning Ctypes.void)) in
  fun queue -> (Lazy.force s) queue

(** [wgpuRenderBundleSetLabel] (from webgpu.h)

    [(* renderBundle *) RenderBundle.t -> (* label *) StringView.t -> unit] *)
let wgpuRenderBundleSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleSetLabel" Ctypes.(RenderBundle.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundle label -> (Lazy.force s) renderBundle label

(** [wgpuRenderBundleAddRef] (from webgpu.h)

    [(* renderBundle *) RenderBundle.t -> unit] *)
let wgpuRenderBundleAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleAddRef" Ctypes.(RenderBundle.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundle -> (Lazy.force s) renderBundle

(** [wgpuRenderBundleRelease] (from webgpu.h)

    [(* renderBundle *) RenderBundle.t -> unit] *)
let wgpuRenderBundleRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleRelease" Ctypes.(RenderBundle.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundle -> (Lazy.force s) renderBundle

(** [wgpuRenderBundleEncoderDraw] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* vertexCount *) Unsigned.UInt32.t -> (* instanceCount *) Unsigned.UInt32.t -> (* firstVertex *) Unsigned.UInt32.t -> (* firstInstance *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderBundleEncoderDraw =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderDraw" Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder vertexCount instanceCount firstVertex firstInstance -> (Lazy.force s) renderBundleEncoder vertexCount instanceCount firstVertex firstInstance

(** [wgpuRenderBundleEncoderDrawIndexed] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* indexCount *) Unsigned.UInt32.t -> (* instanceCount *) Unsigned.UInt32.t -> (* firstIndex *) Unsigned.UInt32.t -> (* baseVertex *) int32 -> (* firstInstance *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderBundleEncoderDrawIndexed =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderDrawIndexed" Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.int32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder indexCount instanceCount firstIndex baseVertex firstInstance -> (Lazy.force s) renderBundleEncoder indexCount instanceCount firstIndex baseVertex firstInstance

(** [wgpuRenderBundleEncoderDrawIndexedIndirect] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* indirectBuffer *) Buffer.t -> (* indirectOffset *) Unsigned.UInt64.t -> unit] *)
let wgpuRenderBundleEncoderDrawIndexedIndirect =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderDrawIndexedIndirect" Ctypes.(RenderBundleEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder indirectBuffer indirectOffset -> (Lazy.force s) renderBundleEncoder indirectBuffer indirectOffset

(** [wgpuRenderBundleEncoderDrawIndirect] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* indirectBuffer *) Buffer.t -> (* indirectOffset *) Unsigned.UInt64.t -> unit] *)
let wgpuRenderBundleEncoderDrawIndirect =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderDrawIndirect" Ctypes.(RenderBundleEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder indirectBuffer indirectOffset -> (Lazy.force s) renderBundleEncoder indirectBuffer indirectOffset

(** [wgpuRenderBundleEncoderFinish] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* descriptor *) RenderBundleDescriptor.t Ctypes.ptr -> RenderBundle.t] *)
let wgpuRenderBundleEncoderFinish =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderFinish" Ctypes.(RenderBundleEncoder.t @-> (Ctypes.ptr RenderBundleDescriptor.t) @-> Ctypes.returning RenderBundle.t)) in
  fun renderBundleEncoder descriptor -> (Lazy.force s) renderBundleEncoder descriptor

(** [wgpuRenderBundleEncoderInsertDebugMarker] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* markerLabel *) StringView.t -> unit] *)
let wgpuRenderBundleEncoderInsertDebugMarker =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderInsertDebugMarker" Ctypes.(RenderBundleEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder markerLabel -> (Lazy.force s) renderBundleEncoder markerLabel

(** [wgpuRenderBundleEncoderPopDebugGroup] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> unit] *)
let wgpuRenderBundleEncoderPopDebugGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderPopDebugGroup" Ctypes.(RenderBundleEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder -> (Lazy.force s) renderBundleEncoder

(** [wgpuRenderBundleEncoderPushDebugGroup] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* groupLabel *) StringView.t -> unit] *)
let wgpuRenderBundleEncoderPushDebugGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderPushDebugGroup" Ctypes.(RenderBundleEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder groupLabel -> (Lazy.force s) renderBundleEncoder groupLabel

(** [wgpuRenderBundleEncoderSetBindGroup] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* groupIndex *) Unsigned.UInt32.t -> (* group *) BindGroup.t -> (* dynamicOffsetCount *) Unsigned.Size_t.t -> (* dynamicOffsets *) Unsigned.UInt32.t Ctypes.ptr -> unit] *)
let wgpuRenderBundleEncoderSetBindGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderSetBindGroup" Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> BindGroup.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.uint32_t) @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder groupIndex group dynamicOffsetCount dynamicOffsets -> (Lazy.force s) renderBundleEncoder groupIndex group dynamicOffsetCount dynamicOffsets

(** [wgpuRenderBundleEncoderSetImmediates] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* offset *) Unsigned.UInt32.t -> (* data *) unit Ctypes.ptr -> (* size *) Unsigned.Size_t.t -> unit] *)
let wgpuRenderBundleEncoderSetImmediates =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderSetImmediates" Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder offset data size -> (Lazy.force s) renderBundleEncoder offset data size

(** [wgpuRenderBundleEncoderSetIndexBuffer] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* buffer *) Buffer.t -> (* format *) IndexFormat.t -> (* offset *) Unsigned.UInt64.t -> (* size *) Unsigned.UInt64.t -> unit] *)
let wgpuRenderBundleEncoderSetIndexBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderSetIndexBuffer" Ctypes.(RenderBundleEncoder.t @-> Buffer.t @-> IndexFormat.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder buffer format offset size -> (Lazy.force s) renderBundleEncoder buffer format offset size

(** [wgpuRenderBundleEncoderSetLabel] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* label *) StringView.t -> unit] *)
let wgpuRenderBundleEncoderSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderSetLabel" Ctypes.(RenderBundleEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder label -> (Lazy.force s) renderBundleEncoder label

(** [wgpuRenderBundleEncoderSetPipeline] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* pipeline *) RenderPipeline.t -> unit] *)
let wgpuRenderBundleEncoderSetPipeline =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderSetPipeline" Ctypes.(RenderBundleEncoder.t @-> RenderPipeline.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder pipeline -> (Lazy.force s) renderBundleEncoder pipeline

(** [wgpuRenderBundleEncoderSetVertexBuffer] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> (* slot *) Unsigned.UInt32.t -> (* buffer *) Buffer.t -> (* offset *) Unsigned.UInt64.t -> (* size *) Unsigned.UInt64.t -> unit] *)
let wgpuRenderBundleEncoderSetVertexBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderSetVertexBuffer" Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder slot buffer offset size -> (Lazy.force s) renderBundleEncoder slot buffer offset size

(** [wgpuRenderBundleEncoderAddRef] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> unit] *)
let wgpuRenderBundleEncoderAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderAddRef" Ctypes.(RenderBundleEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder -> (Lazy.force s) renderBundleEncoder

(** [wgpuRenderBundleEncoderRelease] (from webgpu.h)

    [(* renderBundleEncoder *) RenderBundleEncoder.t -> unit] *)
let wgpuRenderBundleEncoderRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderBundleEncoderRelease" Ctypes.(RenderBundleEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderBundleEncoder -> (Lazy.force s) renderBundleEncoder

(** [wgpuRenderPassEncoderBeginOcclusionQuery] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* queryIndex *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderBeginOcclusionQuery =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderBeginOcclusionQuery" Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder queryIndex -> (Lazy.force s) renderPassEncoder queryIndex

(** [wgpuRenderPassEncoderDraw] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* vertexCount *) Unsigned.UInt32.t -> (* instanceCount *) Unsigned.UInt32.t -> (* firstVertex *) Unsigned.UInt32.t -> (* firstInstance *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderDraw =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderDraw" Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder vertexCount instanceCount firstVertex firstInstance -> (Lazy.force s) renderPassEncoder vertexCount instanceCount firstVertex firstInstance

(** [wgpuRenderPassEncoderDrawIndexed] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* indexCount *) Unsigned.UInt32.t -> (* instanceCount *) Unsigned.UInt32.t -> (* firstIndex *) Unsigned.UInt32.t -> (* baseVertex *) int32 -> (* firstInstance *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderDrawIndexed =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderDrawIndexed" Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.int32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder indexCount instanceCount firstIndex baseVertex firstInstance -> (Lazy.force s) renderPassEncoder indexCount instanceCount firstIndex baseVertex firstInstance

(** [wgpuRenderPassEncoderDrawIndexedIndirect] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* indirectBuffer *) Buffer.t -> (* indirectOffset *) Unsigned.UInt64.t -> unit] *)
let wgpuRenderPassEncoderDrawIndexedIndirect =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderDrawIndexedIndirect" Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder indirectBuffer indirectOffset -> (Lazy.force s) renderPassEncoder indirectBuffer indirectOffset

(** [wgpuRenderPassEncoderDrawIndirect] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* indirectBuffer *) Buffer.t -> (* indirectOffset *) Unsigned.UInt64.t -> unit] *)
let wgpuRenderPassEncoderDrawIndirect =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderDrawIndirect" Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder indirectBuffer indirectOffset -> (Lazy.force s) renderPassEncoder indirectBuffer indirectOffset

(** [wgpuRenderPassEncoderEnd] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> unit] *)
let wgpuRenderPassEncoderEnd =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderEnd" Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder -> (Lazy.force s) renderPassEncoder

(** [wgpuRenderPassEncoderEndOcclusionQuery] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> unit] *)
let wgpuRenderPassEncoderEndOcclusionQuery =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderEndOcclusionQuery" Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder -> (Lazy.force s) renderPassEncoder

(** [wgpuRenderPassEncoderExecuteBundles] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* bundleCount *) Unsigned.Size_t.t -> (* bundles *) RenderBundle.t Ctypes.ptr -> unit] *)
let wgpuRenderPassEncoderExecuteBundles =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderExecuteBundles" Ctypes.(RenderPassEncoder.t @-> Ctypes.size_t @-> (Ctypes.ptr RenderBundle.t) @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder bundleCount bundles -> (Lazy.force s) renderPassEncoder bundleCount bundles

(** [wgpuRenderPassEncoderInsertDebugMarker] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* markerLabel *) StringView.t -> unit] *)
let wgpuRenderPassEncoderInsertDebugMarker =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderInsertDebugMarker" Ctypes.(RenderPassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder markerLabel -> (Lazy.force s) renderPassEncoder markerLabel

(** [wgpuRenderPassEncoderPopDebugGroup] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> unit] *)
let wgpuRenderPassEncoderPopDebugGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderPopDebugGroup" Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder -> (Lazy.force s) renderPassEncoder

(** [wgpuRenderPassEncoderPushDebugGroup] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* groupLabel *) StringView.t -> unit] *)
let wgpuRenderPassEncoderPushDebugGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderPushDebugGroup" Ctypes.(RenderPassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder groupLabel -> (Lazy.force s) renderPassEncoder groupLabel

(** [wgpuRenderPassEncoderSetBindGroup] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* groupIndex *) Unsigned.UInt32.t -> (* group *) BindGroup.t -> (* dynamicOffsetCount *) Unsigned.Size_t.t -> (* dynamicOffsets *) Unsigned.UInt32.t Ctypes.ptr -> unit] *)
let wgpuRenderPassEncoderSetBindGroup =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetBindGroup" Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> BindGroup.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.uint32_t) @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder groupIndex group dynamicOffsetCount dynamicOffsets -> (Lazy.force s) renderPassEncoder groupIndex group dynamicOffsetCount dynamicOffsets

(** [wgpuRenderPassEncoderSetBlendConstant] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* color *) Color.t Ctypes.ptr -> unit] *)
let wgpuRenderPassEncoderSetBlendConstant =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetBlendConstant" Ctypes.(RenderPassEncoder.t @-> (Ctypes.ptr Color.t) @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder color -> (Lazy.force s) renderPassEncoder color

(** [wgpuRenderPassEncoderSetImmediates] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* offset *) Unsigned.UInt32.t -> (* data *) unit Ctypes.ptr -> (* size *) Unsigned.Size_t.t -> unit] *)
let wgpuRenderPassEncoderSetImmediates =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetImmediates" Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder offset data size -> (Lazy.force s) renderPassEncoder offset data size

(** [wgpuRenderPassEncoderSetIndexBuffer] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* buffer *) Buffer.t -> (* format *) IndexFormat.t -> (* offset *) Unsigned.UInt64.t -> (* size *) Unsigned.UInt64.t -> unit] *)
let wgpuRenderPassEncoderSetIndexBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetIndexBuffer" Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> IndexFormat.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder buffer format offset size -> (Lazy.force s) renderPassEncoder buffer format offset size

(** [wgpuRenderPassEncoderSetLabel] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* label *) StringView.t -> unit] *)
let wgpuRenderPassEncoderSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetLabel" Ctypes.(RenderPassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder label -> (Lazy.force s) renderPassEncoder label

(** [wgpuRenderPassEncoderSetPipeline] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* pipeline *) RenderPipeline.t -> unit] *)
let wgpuRenderPassEncoderSetPipeline =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetPipeline" Ctypes.(RenderPassEncoder.t @-> RenderPipeline.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder pipeline -> (Lazy.force s) renderPassEncoder pipeline

(** [wgpuRenderPassEncoderSetScissorRect] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* x *) Unsigned.UInt32.t -> (* y *) Unsigned.UInt32.t -> (* width *) Unsigned.UInt32.t -> (* height *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderSetScissorRect =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetScissorRect" Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder x y width height -> (Lazy.force s) renderPassEncoder x y width height

(** [wgpuRenderPassEncoderSetStencilReference] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* reference *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderSetStencilReference =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetStencilReference" Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder reference -> (Lazy.force s) renderPassEncoder reference

(** [wgpuRenderPassEncoderSetVertexBuffer] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* slot *) Unsigned.UInt32.t -> (* buffer *) Buffer.t -> (* offset *) Unsigned.UInt64.t -> (* size *) Unsigned.UInt64.t -> unit] *)
let wgpuRenderPassEncoderSetVertexBuffer =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetVertexBuffer" Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder slot buffer offset size -> (Lazy.force s) renderPassEncoder slot buffer offset size

(** [wgpuRenderPassEncoderSetViewport] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* x *) float -> (* y *) float -> (* width *) float -> (* height *) float -> (* minDepth *) float -> (* maxDepth *) float -> unit] *)
let wgpuRenderPassEncoderSetViewport =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderSetViewport" Ctypes.(RenderPassEncoder.t @-> Ctypes.float @-> Ctypes.float @-> Ctypes.float @-> Ctypes.float @-> Ctypes.float @-> Ctypes.float @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder x y width height minDepth maxDepth -> (Lazy.force s) renderPassEncoder x y width height minDepth maxDepth

(** [wgpuRenderPassEncoderAddRef] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> unit] *)
let wgpuRenderPassEncoderAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderAddRef" Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder -> (Lazy.force s) renderPassEncoder

(** [wgpuRenderPassEncoderRelease] (from webgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> unit] *)
let wgpuRenderPassEncoderRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderRelease" Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder -> (Lazy.force s) renderPassEncoder

(** [wgpuRenderPipelineGetBindGroupLayout] (from webgpu.h)

    [(* renderPipeline *) RenderPipeline.t -> (* groupIndex *) Unsigned.UInt32.t -> BindGroupLayout.t] *)
let wgpuRenderPipelineGetBindGroupLayout =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPipelineGetBindGroupLayout" Ctypes.(RenderPipeline.t @-> Ctypes.uint32_t @-> Ctypes.returning BindGroupLayout.t)) in
  fun renderPipeline groupIndex -> (Lazy.force s) renderPipeline groupIndex

(** [wgpuRenderPipelineSetLabel] (from webgpu.h)

    [(* renderPipeline *) RenderPipeline.t -> (* label *) StringView.t -> unit] *)
let wgpuRenderPipelineSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPipelineSetLabel" Ctypes.(RenderPipeline.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPipeline label -> (Lazy.force s) renderPipeline label

(** [wgpuRenderPipelineAddRef] (from webgpu.h)

    [(* renderPipeline *) RenderPipeline.t -> unit] *)
let wgpuRenderPipelineAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPipelineAddRef" Ctypes.(RenderPipeline.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPipeline -> (Lazy.force s) renderPipeline

(** [wgpuRenderPipelineRelease] (from webgpu.h)

    [(* renderPipeline *) RenderPipeline.t -> unit] *)
let wgpuRenderPipelineRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPipelineRelease" Ctypes.(RenderPipeline.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPipeline -> (Lazy.force s) renderPipeline

(** [wgpuSamplerSetLabel] (from webgpu.h)

    [(* sampler *) Sampler.t -> (* label *) StringView.t -> unit] *)
let wgpuSamplerSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuSamplerSetLabel" Ctypes.(Sampler.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun sampler label -> (Lazy.force s) sampler label

(** [wgpuSamplerAddRef] (from webgpu.h)

    [(* sampler *) Sampler.t -> unit] *)
let wgpuSamplerAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuSamplerAddRef" Ctypes.(Sampler.t @-> Ctypes.returning Ctypes.void)) in
  fun sampler -> (Lazy.force s) sampler

(** [wgpuSamplerRelease] (from webgpu.h)

    [(* sampler *) Sampler.t -> unit] *)
let wgpuSamplerRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuSamplerRelease" Ctypes.(Sampler.t @-> Ctypes.returning Ctypes.void)) in
  fun sampler -> (Lazy.force s) sampler

(** [wgpuShaderModuleGetCompilationInfo] (from webgpu.h)

    [(* shaderModule *) ShaderModule.t -> (* callbackInfo *) CompilationInfoCallbackInfo.t -> Future.t] *)
let wgpuShaderModuleGetCompilationInfo =
  let s = lazy (Wgpu_loader.foreign "wgpuShaderModuleGetCompilationInfo" Ctypes.(ShaderModule.t @-> CompilationInfoCallbackInfo.t @-> Ctypes.returning Future.t)) in
  fun shaderModule callbackInfo -> (Lazy.force s) shaderModule callbackInfo

(** [wgpuShaderModuleSetLabel] (from webgpu.h)

    [(* shaderModule *) ShaderModule.t -> (* label *) StringView.t -> unit] *)
let wgpuShaderModuleSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuShaderModuleSetLabel" Ctypes.(ShaderModule.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun shaderModule label -> (Lazy.force s) shaderModule label

(** [wgpuShaderModuleAddRef] (from webgpu.h)

    [(* shaderModule *) ShaderModule.t -> unit] *)
let wgpuShaderModuleAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuShaderModuleAddRef" Ctypes.(ShaderModule.t @-> Ctypes.returning Ctypes.void)) in
  fun shaderModule -> (Lazy.force s) shaderModule

(** [wgpuShaderModuleRelease] (from webgpu.h)

    [(* shaderModule *) ShaderModule.t -> unit] *)
let wgpuShaderModuleRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuShaderModuleRelease" Ctypes.(ShaderModule.t @-> Ctypes.returning Ctypes.void)) in
  fun shaderModule -> (Lazy.force s) shaderModule

(** [wgpuSupportedFeaturesFreeMembers] (from webgpu.h)

    [(* supportedFeatures *) SupportedFeatures.t -> unit] *)
let wgpuSupportedFeaturesFreeMembers =
  let s = lazy (Wgpu_loader.foreign "wgpuSupportedFeaturesFreeMembers" Ctypes.(SupportedFeatures.t @-> Ctypes.returning Ctypes.void)) in
  fun supportedFeatures -> (Lazy.force s) supportedFeatures

(** [wgpuSupportedInstanceFeaturesFreeMembers] (from webgpu.h)

    [(* supportedInstanceFeatures *) SupportedInstanceFeatures.t -> unit] *)
let wgpuSupportedInstanceFeaturesFreeMembers =
  let s = lazy (Wgpu_loader.foreign "wgpuSupportedInstanceFeaturesFreeMembers" Ctypes.(SupportedInstanceFeatures.t @-> Ctypes.returning Ctypes.void)) in
  fun supportedInstanceFeatures -> (Lazy.force s) supportedInstanceFeatures

(** [wgpuSupportedWGSLLanguageFeaturesFreeMembers] (from webgpu.h)

    [(* supportedWGSLLanguageFeatures *) SupportedWGSLLanguageFeatures.t -> unit] *)
let wgpuSupportedWGSLLanguageFeaturesFreeMembers =
  let s = lazy (Wgpu_loader.foreign "wgpuSupportedWGSLLanguageFeaturesFreeMembers" Ctypes.(SupportedWGSLLanguageFeatures.t @-> Ctypes.returning Ctypes.void)) in
  fun supportedWGSLLanguageFeatures -> (Lazy.force s) supportedWGSLLanguageFeatures

(** [wgpuSurfaceConfigure] (from webgpu.h)

    [(* surface *) Surface.t -> (* config *) SurfaceConfiguration.t Ctypes.ptr -> unit] *)
let wgpuSurfaceConfigure =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfaceConfigure" Ctypes.(Surface.t @-> (Ctypes.ptr SurfaceConfiguration.t) @-> Ctypes.returning Ctypes.void)) in
  fun surface config -> (Lazy.force s) surface config

(** [wgpuSurfaceGetCapabilities] (from webgpu.h)

    [(* surface *) Surface.t -> (* adapter *) Adapter.t -> (* capabilities *) SurfaceCapabilities.t Ctypes.ptr -> Status.t] *)
let wgpuSurfaceGetCapabilities =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfaceGetCapabilities" Ctypes.(Surface.t @-> Adapter.t @-> (Ctypes.ptr SurfaceCapabilities.t) @-> Ctypes.returning Status.t)) in
  fun surface adapter capabilities -> (Lazy.force s) surface adapter capabilities

(** [wgpuSurfaceGetCurrentTexture] (from webgpu.h)

    [(* surface *) Surface.t -> (* surfaceTexture *) SurfaceTexture.t Ctypes.ptr -> unit] *)
let wgpuSurfaceGetCurrentTexture =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfaceGetCurrentTexture" Ctypes.(Surface.t @-> (Ctypes.ptr SurfaceTexture.t) @-> Ctypes.returning Ctypes.void)) in
  fun surface surfaceTexture -> (Lazy.force s) surface surfaceTexture

(** [wgpuSurfacePresent] (from webgpu.h)

    [(* surface *) Surface.t -> Status.t] *)
let wgpuSurfacePresent =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfacePresent" Ctypes.(Surface.t @-> Ctypes.returning Status.t)) in
  fun surface -> (Lazy.force s) surface

(** [wgpuSurfaceSetLabel] (from webgpu.h)

    [(* surface *) Surface.t -> (* label *) StringView.t -> unit] *)
let wgpuSurfaceSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfaceSetLabel" Ctypes.(Surface.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun surface label -> (Lazy.force s) surface label

(** [wgpuSurfaceUnconfigure] (from webgpu.h)

    [(* surface *) Surface.t -> unit] *)
let wgpuSurfaceUnconfigure =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfaceUnconfigure" Ctypes.(Surface.t @-> Ctypes.returning Ctypes.void)) in
  fun surface -> (Lazy.force s) surface

(** [wgpuSurfaceAddRef] (from webgpu.h)

    [(* surface *) Surface.t -> unit] *)
let wgpuSurfaceAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfaceAddRef" Ctypes.(Surface.t @-> Ctypes.returning Ctypes.void)) in
  fun surface -> (Lazy.force s) surface

(** [wgpuSurfaceRelease] (from webgpu.h)

    [(* surface *) Surface.t -> unit] *)
let wgpuSurfaceRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfaceRelease" Ctypes.(Surface.t @-> Ctypes.returning Ctypes.void)) in
  fun surface -> (Lazy.force s) surface

(** [wgpuSurfaceCapabilitiesFreeMembers] (from webgpu.h)

    [(* surfaceCapabilities *) SurfaceCapabilities.t -> unit] *)
let wgpuSurfaceCapabilitiesFreeMembers =
  let s = lazy (Wgpu_loader.foreign "wgpuSurfaceCapabilitiesFreeMembers" Ctypes.(SurfaceCapabilities.t @-> Ctypes.returning Ctypes.void)) in
  fun surfaceCapabilities -> (Lazy.force s) surfaceCapabilities

(** [wgpuTextureCreateView] (from webgpu.h)

    [(* texture *) Texture.t -> (* descriptor *) TextureViewDescriptor.t Ctypes.ptr -> TextureView.t] *)
let wgpuTextureCreateView =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureCreateView" Ctypes.(Texture.t @-> (Ctypes.ptr TextureViewDescriptor.t) @-> Ctypes.returning TextureView.t)) in
  fun texture descriptor -> (Lazy.force s) texture descriptor

(** [wgpuTextureDestroy] (from webgpu.h)

    [(* texture *) Texture.t -> unit] *)
let wgpuTextureDestroy =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureDestroy" Ctypes.(Texture.t @-> Ctypes.returning Ctypes.void)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetDepthOrArrayLayers] (from webgpu.h)

    [(* texture *) Texture.t -> Unsigned.UInt32.t] *)
let wgpuTextureGetDepthOrArrayLayers =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetDepthOrArrayLayers" Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetDimension] (from webgpu.h)

    [(* texture *) Texture.t -> TextureDimension.t] *)
let wgpuTextureGetDimension =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetDimension" Ctypes.(Texture.t @-> Ctypes.returning TextureDimension.t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetFormat] (from webgpu.h)

    [(* texture *) Texture.t -> TextureFormat.t] *)
let wgpuTextureGetFormat =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetFormat" Ctypes.(Texture.t @-> Ctypes.returning TextureFormat.t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetHeight] (from webgpu.h)

    [(* texture *) Texture.t -> Unsigned.UInt32.t] *)
let wgpuTextureGetHeight =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetHeight" Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetMipLevelCount] (from webgpu.h)

    [(* texture *) Texture.t -> Unsigned.UInt32.t] *)
let wgpuTextureGetMipLevelCount =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetMipLevelCount" Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetSampleCount] (from webgpu.h)

    [(* texture *) Texture.t -> Unsigned.UInt32.t] *)
let wgpuTextureGetSampleCount =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetSampleCount" Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetTextureBindingViewDimension] (from webgpu.h)

    [(* texture *) Texture.t -> TextureViewDimension.t] *)
let wgpuTextureGetTextureBindingViewDimension =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetTextureBindingViewDimension" Ctypes.(Texture.t @-> Ctypes.returning TextureViewDimension.t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetUsage] (from webgpu.h)

    [(* texture *) Texture.t -> TextureUsage.t] *)
let wgpuTextureGetUsage =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetUsage" Ctypes.(Texture.t @-> Ctypes.returning TextureUsage.t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureGetWidth] (from webgpu.h)

    [(* texture *) Texture.t -> Unsigned.UInt32.t] *)
let wgpuTextureGetWidth =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetWidth" Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureSetLabel] (from webgpu.h)

    [(* texture *) Texture.t -> (* label *) StringView.t -> unit] *)
let wgpuTextureSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureSetLabel" Ctypes.(Texture.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun texture label -> (Lazy.force s) texture label

(** [wgpuTextureAddRef] (from webgpu.h)

    [(* texture *) Texture.t -> unit] *)
let wgpuTextureAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureAddRef" Ctypes.(Texture.t @-> Ctypes.returning Ctypes.void)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureRelease] (from webgpu.h)

    [(* texture *) Texture.t -> unit] *)
let wgpuTextureRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureRelease" Ctypes.(Texture.t @-> Ctypes.returning Ctypes.void)) in
  fun texture -> (Lazy.force s) texture

(** [wgpuTextureViewSetLabel] (from webgpu.h)

    [(* textureView *) TextureView.t -> (* label *) StringView.t -> unit] *)
let wgpuTextureViewSetLabel =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureViewSetLabel" Ctypes.(TextureView.t @-> StringView.t @-> Ctypes.returning Ctypes.void)) in
  fun textureView label -> (Lazy.force s) textureView label

(** [wgpuTextureViewAddRef] (from webgpu.h)

    [(* textureView *) TextureView.t -> unit] *)
let wgpuTextureViewAddRef =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureViewAddRef" Ctypes.(TextureView.t @-> Ctypes.returning Ctypes.void)) in
  fun textureView -> (Lazy.force s) textureView

(** [wgpuTextureViewRelease] (from webgpu.h)

    [(* textureView *) TextureView.t -> unit] *)
let wgpuTextureViewRelease =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureViewRelease" Ctypes.(TextureView.t @-> Ctypes.returning Ctypes.void)) in
  fun textureView -> (Lazy.force s) textureView

(** [wgpuGenerateReport] (from wgpu.h)

    [(* instance *) Instance.t -> (* report *) GlobalReport.t Ctypes.ptr -> unit] *)
let wgpuGenerateReport =
  let s = lazy (Wgpu_loader.foreign "wgpuGenerateReport" Ctypes.(Instance.t @-> (Ctypes.ptr GlobalReport.t) @-> Ctypes.returning Ctypes.void)) in
  fun instance report -> (Lazy.force s) instance report

(** [wgpuInstanceEnumerateAdapters] (from wgpu.h)

    [(* instance *) Instance.t -> (* options *) InstanceEnumerateAdapterOptions.t Ctypes.ptr -> (* adapters *) Adapter.t Ctypes.ptr -> Unsigned.Size_t.t] *)
let wgpuInstanceEnumerateAdapters =
  let s = lazy (Wgpu_loader.foreign "wgpuInstanceEnumerateAdapters" Ctypes.(Instance.t @-> (Ctypes.ptr InstanceEnumerateAdapterOptions.t) @-> (Ctypes.ptr Adapter.t) @-> Ctypes.returning Ctypes.size_t)) in
  fun instance options adapters -> (Lazy.force s) instance options adapters

(** [wgpuQueueSubmitForIndex] (from wgpu.h)

    [(* queue *) Queue.t -> (* commandCount *) Unsigned.Size_t.t -> (* commands *) CommandBuffer.t Ctypes.ptr -> Unsigned.UInt64.t] *)
let wgpuQueueSubmitForIndex =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueSubmitForIndex" Ctypes.(Queue.t @-> Ctypes.size_t @-> (Ctypes.ptr CommandBuffer.t) @-> Ctypes.returning Ctypes.uint64_t)) in
  fun queue commandCount commands -> (Lazy.force s) queue commandCount commands

(** [wgpuQueueGetTimestampPeriod] (from wgpu.h)

    [(* queue *) Queue.t -> float] *)
let wgpuQueueGetTimestampPeriod =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueGetTimestampPeriod" Ctypes.(Queue.t @-> Ctypes.returning Ctypes.float)) in
  fun queue -> (Lazy.force s) queue

(** [wgpuDevicePoll] (from wgpu.h)

    [(* device *) Device.t -> (* wait *) Unsigned.UInt32.t -> (* submissionIndex *) Unsigned.UInt64.t Ctypes.ptr -> Unsigned.UInt32.t] *)
let wgpuDevicePoll =
  let s = lazy (Wgpu_loader.foreign "wgpuDevicePoll" Ctypes.(Device.t @-> Ctypes.uint32_t @-> (Ctypes.ptr Ctypes.uint64_t) @-> Ctypes.returning Ctypes.uint32_t)) in
  fun device wait submissionIndex -> (Lazy.force s) device wait submissionIndex

(** [wgpuDeviceCreateShaderModuleSpirV] (from wgpu.h)

    [(* device *) Device.t -> (* descriptor *) ShaderModuleDescriptorSpirV.t Ctypes.ptr -> ShaderModule.t] *)
let wgpuDeviceCreateShaderModuleSpirV =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateShaderModuleSpirV" Ctypes.(Device.t @-> (Ctypes.ptr ShaderModuleDescriptorSpirV.t) @-> Ctypes.returning ShaderModule.t)) in
  fun device descriptor -> (Lazy.force s) device descriptor

(** [wgpuSetLogCallback] (from wgpu.h)

    [(* callback *) LogCallback.t -> (* userdata *) unit Ctypes.ptr -> unit] *)
let wgpuSetLogCallback =
  let s = lazy (Wgpu_loader.foreign "wgpuSetLogCallback" Ctypes.(LogCallback.t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)) in
  fun callback userdata -> (Lazy.force s) callback userdata

(** [wgpuSetLogLevel] (from wgpu.h)

    [(* level *) LogLevel.t -> unit] *)
let wgpuSetLogLevel =
  let s = lazy (Wgpu_loader.foreign "wgpuSetLogLevel" Ctypes.(LogLevel.t @-> Ctypes.returning Ctypes.void)) in
  fun level -> (Lazy.force s) level

(** [wgpuGetVersion] (from wgpu.h)

    [(* _ *) unit -> Unsigned.UInt32.t] *)
let wgpuGetVersion =
  let s = lazy (Wgpu_loader.foreign "wgpuGetVersion" Ctypes.(Ctypes.void @-> Ctypes.returning Ctypes.uint32_t)) in
  fun a0 -> (Lazy.force s) a0

(** [wgpuDeviceGetNativeMetalDevice] (from wgpu.h)

    [(* device *) Device.t -> unit Ctypes.ptr] *)
let wgpuDeviceGetNativeMetalDevice =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceGetNativeMetalDevice" Ctypes.(Device.t @-> Ctypes.returning (Ctypes.ptr Ctypes.void))) in
  fun device -> (Lazy.force s) device

(** [wgpuQueueGetNativeMetalCommandQueue] (from wgpu.h)

    [(* queue *) Queue.t -> unit Ctypes.ptr] *)
let wgpuQueueGetNativeMetalCommandQueue =
  let s = lazy (Wgpu_loader.foreign "wgpuQueueGetNativeMetalCommandQueue" Ctypes.(Queue.t @-> Ctypes.returning (Ctypes.ptr Ctypes.void))) in
  fun queue -> (Lazy.force s) queue

(** [wgpuTextureGetNativeMetalTexture] (from wgpu.h)

    [(* texture *) Texture.t -> unit Ctypes.ptr] *)
let wgpuTextureGetNativeMetalTexture =
  let s = lazy (Wgpu_loader.foreign "wgpuTextureGetNativeMetalTexture" Ctypes.(Texture.t @-> Ctypes.returning (Ctypes.ptr Ctypes.void))) in
  fun texture -> (Lazy.force s) texture

(** [wgpuRenderPassEncoderMultiDrawIndirect] (from wgpu.h)

    [(* encoder *) RenderPassEncoder.t -> (* buffer *) Buffer.t -> (* offset *) Unsigned.UInt64.t -> (* count *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderMultiDrawIndirect =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderMultiDrawIndirect" Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun encoder buffer offset count -> (Lazy.force s) encoder buffer offset count

(** [wgpuRenderPassEncoderMultiDrawIndexedIndirect] (from wgpu.h)

    [(* encoder *) RenderPassEncoder.t -> (* buffer *) Buffer.t -> (* offset *) Unsigned.UInt64.t -> (* count *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderMultiDrawIndexedIndirect =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderMultiDrawIndexedIndirect" Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun encoder buffer offset count -> (Lazy.force s) encoder buffer offset count

(** [wgpuRenderPassEncoderMultiDrawIndirectCount] (from wgpu.h)

    [(* encoder *) RenderPassEncoder.t -> (* buffer *) Buffer.t -> (* offset *) Unsigned.UInt64.t -> (* count_buffer *) Buffer.t -> (* count_buffer_offset *) Unsigned.UInt64.t -> (* max_count *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderMultiDrawIndirectCount =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderMultiDrawIndirectCount" Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun encoder buffer offset count_buffer count_buffer_offset max_count -> (Lazy.force s) encoder buffer offset count_buffer count_buffer_offset max_count

(** [wgpuRenderPassEncoderMultiDrawIndexedIndirectCount] (from wgpu.h)

    [(* encoder *) RenderPassEncoder.t -> (* buffer *) Buffer.t -> (* offset *) Unsigned.UInt64.t -> (* count_buffer *) Buffer.t -> (* count_buffer_offset *) Unsigned.UInt64.t -> (* max_count *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderMultiDrawIndexedIndirectCount =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderMultiDrawIndexedIndirectCount" Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun encoder buffer offset count_buffer count_buffer_offset max_count -> (Lazy.force s) encoder buffer offset count_buffer count_buffer_offset max_count

(** [wgpuComputePassEncoderBeginPipelineStatisticsQuery] (from wgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* querySet *) QuerySet.t -> (* queryIndex *) Unsigned.UInt32.t -> unit] *)
let wgpuComputePassEncoderBeginPipelineStatisticsQuery =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderBeginPipelineStatisticsQuery" Ctypes.(ComputePassEncoder.t @-> QuerySet.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder querySet queryIndex -> (Lazy.force s) computePassEncoder querySet queryIndex

(** [wgpuComputePassEncoderEndPipelineStatisticsQuery] (from wgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> unit] *)
let wgpuComputePassEncoderEndPipelineStatisticsQuery =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderEndPipelineStatisticsQuery" Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder -> (Lazy.force s) computePassEncoder

(** [wgpuRenderPassEncoderBeginPipelineStatisticsQuery] (from wgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* querySet *) QuerySet.t -> (* queryIndex *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderBeginPipelineStatisticsQuery =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderBeginPipelineStatisticsQuery" Ctypes.(RenderPassEncoder.t @-> QuerySet.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder querySet queryIndex -> (Lazy.force s) renderPassEncoder querySet queryIndex

(** [wgpuRenderPassEncoderEndPipelineStatisticsQuery] (from wgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> unit] *)
let wgpuRenderPassEncoderEndPipelineStatisticsQuery =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderEndPipelineStatisticsQuery" Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder -> (Lazy.force s) renderPassEncoder

(** [wgpuComputePassEncoderWriteTimestamp] (from wgpu.h)

    [(* computePassEncoder *) ComputePassEncoder.t -> (* querySet *) QuerySet.t -> (* queryIndex *) Unsigned.UInt32.t -> unit] *)
let wgpuComputePassEncoderWriteTimestamp =
  let s = lazy (Wgpu_loader.foreign "wgpuComputePassEncoderWriteTimestamp" Ctypes.(ComputePassEncoder.t @-> QuerySet.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun computePassEncoder querySet queryIndex -> (Lazy.force s) computePassEncoder querySet queryIndex

(** [wgpuRenderPassEncoderWriteTimestamp] (from wgpu.h)

    [(* renderPassEncoder *) RenderPassEncoder.t -> (* querySet *) QuerySet.t -> (* queryIndex *) Unsigned.UInt32.t -> unit] *)
let wgpuRenderPassEncoderWriteTimestamp =
  let s = lazy (Wgpu_loader.foreign "wgpuRenderPassEncoderWriteTimestamp" Ctypes.(RenderPassEncoder.t @-> QuerySet.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)) in
  fun renderPassEncoder querySet queryIndex -> (Lazy.force s) renderPassEncoder querySet queryIndex

(** [wgpuDeviceStartGraphicsDebuggerCapture] (from wgpu.h)

    [(* device *) Device.t -> Unsigned.UInt32.t] *)
let wgpuDeviceStartGraphicsDebuggerCapture =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceStartGraphicsDebuggerCapture" Ctypes.(Device.t @-> Ctypes.returning Ctypes.uint32_t)) in
  fun device -> (Lazy.force s) device

(** [wgpuDeviceStopGraphicsDebuggerCapture] (from wgpu.h)

    [(* device *) Device.t -> unit] *)
let wgpuDeviceStopGraphicsDebuggerCapture =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceStopGraphicsDebuggerCapture" Ctypes.(Device.t @-> Ctypes.returning Ctypes.void)) in
  fun device -> (Lazy.force s) device

(** [wgpuCommandEncoderClearTexture] (from wgpu.h)

    [(* commandEncoder *) CommandEncoder.t -> (* texture *) Texture.t -> (* range *) ImageSubresourceRange.t Ctypes.ptr -> unit] *)
let wgpuCommandEncoderClearTexture =
  let s = lazy (Wgpu_loader.foreign "wgpuCommandEncoderClearTexture" Ctypes.(CommandEncoder.t @-> Texture.t @-> (Ctypes.ptr ImageSubresourceRange.t) @-> Ctypes.returning Ctypes.void)) in
  fun commandEncoder texture range -> (Lazy.force s) commandEncoder texture range

(** [wgpuDeviceCreateShaderModuleTrusted] (from wgpu.h)

    [(* device *) Device.t -> (* descriptor *) ShaderModuleDescriptor.t Ctypes.ptr -> (* runtimeChecks *) ShaderRuntimeChecks.t -> ShaderModule.t] *)
let wgpuDeviceCreateShaderModuleTrusted =
  let s = lazy (Wgpu_loader.foreign "wgpuDeviceCreateShaderModuleTrusted" Ctypes.(Device.t @-> (Ctypes.ptr ShaderModuleDescriptor.t) @-> ShaderRuntimeChecks.t @-> Ctypes.returning ShaderModule.t)) in
  fun device descriptor runtimeChecks -> (Lazy.force s) device descriptor runtimeChecks

(** Every entry point bound by this module, in header order. *)
let names : string list =
  [ "wgpuCreateInstance"; "wgpuGetInstanceFeatures"; "wgpuGetInstanceLimits"; "wgpuHasInstanceFeature"; "wgpuGetProcAddress"; "wgpuAdapterGetFeatures"; "wgpuAdapterGetInfo"; "wgpuAdapterGetLimits"; "wgpuAdapterHasFeature"; "wgpuAdapterRequestDevice"; "wgpuAdapterAddRef"; "wgpuAdapterRelease"; "wgpuAdapterInfoFreeMembers"; "wgpuBindGroupSetLabel"; "wgpuBindGroupAddRef"; "wgpuBindGroupRelease"; "wgpuBindGroupLayoutSetLabel"; "wgpuBindGroupLayoutAddRef"; "wgpuBindGroupLayoutRelease"; "wgpuBufferDestroy"; "wgpuBufferGetConstMappedRange"; "wgpuBufferGetMappedRange"; "wgpuBufferGetMapState"; "wgpuBufferGetSize"; "wgpuBufferGetUsage"; "wgpuBufferMapAsync"; "wgpuBufferReadMappedRange"; "wgpuBufferSetLabel"; "wgpuBufferUnmap"; "wgpuBufferWriteMappedRange"; "wgpuBufferAddRef"; "wgpuBufferRelease"; "wgpuCommandBufferSetLabel"; "wgpuCommandBufferAddRef"; "wgpuCommandBufferRelease"; "wgpuCommandEncoderBeginComputePass"; "wgpuCommandEncoderBeginRenderPass"; "wgpuCommandEncoderClearBuffer"; "wgpuCommandEncoderCopyBufferToBuffer"; "wgpuCommandEncoderCopyBufferToTexture"; "wgpuCommandEncoderCopyTextureToBuffer"; "wgpuCommandEncoderCopyTextureToTexture"; "wgpuCommandEncoderFinish"; "wgpuCommandEncoderInsertDebugMarker"; "wgpuCommandEncoderPopDebugGroup"; "wgpuCommandEncoderPushDebugGroup"; "wgpuCommandEncoderResolveQuerySet"; "wgpuCommandEncoderSetLabel"; "wgpuCommandEncoderWriteTimestamp"; "wgpuCommandEncoderAddRef"; "wgpuCommandEncoderRelease"; "wgpuComputePassEncoderDispatchWorkgroups"; "wgpuComputePassEncoderDispatchWorkgroupsIndirect"; "wgpuComputePassEncoderEnd"; "wgpuComputePassEncoderInsertDebugMarker"; "wgpuComputePassEncoderPopDebugGroup"; "wgpuComputePassEncoderPushDebugGroup"; "wgpuComputePassEncoderSetBindGroup"; "wgpuComputePassEncoderSetImmediates"; "wgpuComputePassEncoderSetLabel"; "wgpuComputePassEncoderSetPipeline"; "wgpuComputePassEncoderAddRef"; "wgpuComputePassEncoderRelease"; "wgpuComputePipelineGetBindGroupLayout"; "wgpuComputePipelineSetLabel"; "wgpuComputePipelineAddRef"; "wgpuComputePipelineRelease"; "wgpuDeviceCreateBindGroup"; "wgpuDeviceCreateBindGroupLayout"; "wgpuDeviceCreateBuffer"; "wgpuDeviceCreateCommandEncoder"; "wgpuDeviceCreateComputePipeline"; "wgpuDeviceCreateComputePipelineAsync"; "wgpuDeviceCreatePipelineLayout"; "wgpuDeviceCreateQuerySet"; "wgpuDeviceCreateRenderBundleEncoder"; "wgpuDeviceCreateRenderPipeline"; "wgpuDeviceCreateRenderPipelineAsync"; "wgpuDeviceCreateSampler"; "wgpuDeviceCreateShaderModule"; "wgpuDeviceCreateTexture"; "wgpuDeviceDestroy"; "wgpuDeviceGetAdapterInfo"; "wgpuDeviceGetFeatures"; "wgpuDeviceGetLimits"; "wgpuDeviceGetLostFuture"; "wgpuDeviceGetQueue"; "wgpuDeviceHasFeature"; "wgpuDevicePopErrorScope"; "wgpuDevicePushErrorScope"; "wgpuDeviceSetLabel"; "wgpuDeviceAddRef"; "wgpuDeviceRelease"; "wgpuExternalTextureSetLabel"; "wgpuExternalTextureAddRef"; "wgpuExternalTextureRelease"; "wgpuInstanceCreateSurface"; "wgpuInstanceGetWGSLLanguageFeatures"; "wgpuInstanceHasWGSLLanguageFeature"; "wgpuInstanceProcessEvents"; "wgpuInstanceRequestAdapter"; "wgpuInstanceWaitAny"; "wgpuInstanceAddRef"; "wgpuInstanceRelease"; "wgpuPipelineLayoutSetLabel"; "wgpuPipelineLayoutAddRef"; "wgpuPipelineLayoutRelease"; "wgpuQuerySetDestroy"; "wgpuQuerySetGetCount"; "wgpuQuerySetGetType"; "wgpuQuerySetSetLabel"; "wgpuQuerySetAddRef"; "wgpuQuerySetRelease"; "wgpuQueueOnSubmittedWorkDone"; "wgpuQueueSetLabel"; "wgpuQueueSubmit"; "wgpuQueueWriteBuffer"; "wgpuQueueWriteTexture"; "wgpuQueueAddRef"; "wgpuQueueRelease"; "wgpuRenderBundleSetLabel"; "wgpuRenderBundleAddRef"; "wgpuRenderBundleRelease"; "wgpuRenderBundleEncoderDraw"; "wgpuRenderBundleEncoderDrawIndexed"; "wgpuRenderBundleEncoderDrawIndexedIndirect"; "wgpuRenderBundleEncoderDrawIndirect"; "wgpuRenderBundleEncoderFinish"; "wgpuRenderBundleEncoderInsertDebugMarker"; "wgpuRenderBundleEncoderPopDebugGroup"; "wgpuRenderBundleEncoderPushDebugGroup"; "wgpuRenderBundleEncoderSetBindGroup"; "wgpuRenderBundleEncoderSetImmediates"; "wgpuRenderBundleEncoderSetIndexBuffer"; "wgpuRenderBundleEncoderSetLabel"; "wgpuRenderBundleEncoderSetPipeline"; "wgpuRenderBundleEncoderSetVertexBuffer"; "wgpuRenderBundleEncoderAddRef"; "wgpuRenderBundleEncoderRelease"; "wgpuRenderPassEncoderBeginOcclusionQuery"; "wgpuRenderPassEncoderDraw"; "wgpuRenderPassEncoderDrawIndexed"; "wgpuRenderPassEncoderDrawIndexedIndirect"; "wgpuRenderPassEncoderDrawIndirect"; "wgpuRenderPassEncoderEnd"; "wgpuRenderPassEncoderEndOcclusionQuery"; "wgpuRenderPassEncoderExecuteBundles"; "wgpuRenderPassEncoderInsertDebugMarker"; "wgpuRenderPassEncoderPopDebugGroup"; "wgpuRenderPassEncoderPushDebugGroup"; "wgpuRenderPassEncoderSetBindGroup"; "wgpuRenderPassEncoderSetBlendConstant"; "wgpuRenderPassEncoderSetImmediates"; "wgpuRenderPassEncoderSetIndexBuffer"; "wgpuRenderPassEncoderSetLabel"; "wgpuRenderPassEncoderSetPipeline"; "wgpuRenderPassEncoderSetScissorRect"; "wgpuRenderPassEncoderSetStencilReference"; "wgpuRenderPassEncoderSetVertexBuffer"; "wgpuRenderPassEncoderSetViewport"; "wgpuRenderPassEncoderAddRef"; "wgpuRenderPassEncoderRelease"; "wgpuRenderPipelineGetBindGroupLayout"; "wgpuRenderPipelineSetLabel"; "wgpuRenderPipelineAddRef"; "wgpuRenderPipelineRelease"; "wgpuSamplerSetLabel"; "wgpuSamplerAddRef"; "wgpuSamplerRelease"; "wgpuShaderModuleGetCompilationInfo"; "wgpuShaderModuleSetLabel"; "wgpuShaderModuleAddRef"; "wgpuShaderModuleRelease"; "wgpuSupportedFeaturesFreeMembers"; "wgpuSupportedInstanceFeaturesFreeMembers"; "wgpuSupportedWGSLLanguageFeaturesFreeMembers"; "wgpuSurfaceConfigure"; "wgpuSurfaceGetCapabilities"; "wgpuSurfaceGetCurrentTexture"; "wgpuSurfacePresent"; "wgpuSurfaceSetLabel"; "wgpuSurfaceUnconfigure"; "wgpuSurfaceAddRef"; "wgpuSurfaceRelease"; "wgpuSurfaceCapabilitiesFreeMembers"; "wgpuTextureCreateView"; "wgpuTextureDestroy"; "wgpuTextureGetDepthOrArrayLayers"; "wgpuTextureGetDimension"; "wgpuTextureGetFormat"; "wgpuTextureGetHeight"; "wgpuTextureGetMipLevelCount"; "wgpuTextureGetSampleCount"; "wgpuTextureGetTextureBindingViewDimension"; "wgpuTextureGetUsage"; "wgpuTextureGetWidth"; "wgpuTextureSetLabel"; "wgpuTextureAddRef"; "wgpuTextureRelease"; "wgpuTextureViewSetLabel"; "wgpuTextureViewAddRef"; "wgpuTextureViewRelease"; "wgpuGenerateReport"; "wgpuInstanceEnumerateAdapters"; "wgpuQueueSubmitForIndex"; "wgpuQueueGetTimestampPeriod"; "wgpuDevicePoll"; "wgpuDeviceCreateShaderModuleSpirV"; "wgpuSetLogCallback"; "wgpuSetLogLevel"; "wgpuGetVersion"; "wgpuDeviceGetNativeMetalDevice"; "wgpuQueueGetNativeMetalCommandQueue"; "wgpuTextureGetNativeMetalTexture"; "wgpuRenderPassEncoderMultiDrawIndirect"; "wgpuRenderPassEncoderMultiDrawIndexedIndirect"; "wgpuRenderPassEncoderMultiDrawIndirectCount"; "wgpuRenderPassEncoderMultiDrawIndexedIndirectCount"; "wgpuComputePassEncoderBeginPipelineStatisticsQuery"; "wgpuComputePassEncoderEndPipelineStatisticsQuery"; "wgpuRenderPassEncoderBeginPipelineStatisticsQuery"; "wgpuRenderPassEncoderEndPipelineStatisticsQuery"; "wgpuComputePassEncoderWriteTimestamp"; "wgpuRenderPassEncoderWriteTimestamp"; "wgpuDeviceStartGraphicsDebuggerCapture"; "wgpuDeviceStopGraphicsDebuggerCapture"; "wgpuCommandEncoderClearTexture"; "wgpuDeviceCreateShaderModuleTrusted"; ]
