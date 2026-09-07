(** @canonical Wgpu.Types *)

(* Raw WebGPU / wgpu-native types: enums, bit sets, handles, structs.

   GENERATED FILE -- DO NOT EDIT.

   Produced by [gen/gen.ml] from the vendored headers
   [vendor/wgpu-native/include/webgpu/{webgpu,wgpu}.h], pinned at
   wgpu-native 29.0.1.1 (commit 6aed50955d934ac36049ba8d002034841633ae02, webgpu-headers 673658bc2bd70ec39fc55ebe6bb0173cf6d0a603).

   Run [dune build @gen] to regenerate and [dune promote] to accept. *)

(* Naming: C type [WGPUFoo] becomes module [Foo]; struct fields keep their C
   spelling; enum constant [WGPUFoo_BarBaz] becomes [Foo.bar_baz].  Every
   module records its C name in [c_name] and its constants in [values]. *)

(* Fresh, fully zeroed storage.  ctypes does not promise to zero the memory
   it hands out, and several WebGPU structs are only valid when the fields
   the INIT macro does not mention are zero. *)
let zeroed : type a. a Ctypes.structure Ctypes.typ -> a Ctypes.structure =
 fun t ->
  let v = Ctypes.make t in
  let bytes =
    Ctypes.CArray.from_ptr
      (Ctypes.coerce (Ctypes.ptr t) (Ctypes.ptr Ctypes.char) (Ctypes.addr v))
      (Ctypes.sizeof t)
  in
  for i = 0 to Ctypes.CArray.length bytes - 1 do
    Ctypes.CArray.set bytes i '\000'
  done;
  v

(** Sentinel values from the [#define]s in the headers. *)
module Constants = struct
  (** [WGPU_TRUE] *)
  let true_ : Unsigned.UInt32.t = Unsigned.UInt32.of_int 1

  (** [WGPU_FALSE] *)
  let false_ : Unsigned.UInt32.t = Unsigned.UInt32.of_int 0

  (** [WGPU_ARRAY_LAYER_COUNT_UNDEFINED] *)
  let array_layer_count_undefined : Unsigned.UInt32.t = Unsigned.UInt32.max_int

  (** [WGPU_COPY_STRIDE_UNDEFINED] *)
  let copy_stride_undefined : Unsigned.UInt32.t = Unsigned.UInt32.max_int

  (** [WGPU_DEPTH_CLEAR_VALUE_UNDEFINED] *)
  let depth_clear_value_undefined : float = Float.nan

  (** [WGPU_DEPTH_SLICE_UNDEFINED] *)
  let depth_slice_undefined : Unsigned.UInt32.t = Unsigned.UInt32.max_int

  (** [WGPU_LIMIT_U32_UNDEFINED] *)
  let limit_u32_undefined : Unsigned.UInt32.t = Unsigned.UInt32.max_int

  (** [WGPU_LIMIT_U64_UNDEFINED] *)
  let limit_u64_undefined : Unsigned.UInt64.t = Unsigned.UInt64.max_int

  (** [WGPU_MIP_LEVEL_COUNT_UNDEFINED] *)
  let mip_level_count_undefined : Unsigned.UInt32.t = Unsigned.UInt32.max_int

  (** [WGPU_QUERY_SET_INDEX_UNDEFINED] *)
  let query_set_index_undefined : Unsigned.UInt32.t = Unsigned.UInt32.max_int

  (** [WGPU_STRLEN] *)
  let strlen : Unsigned.Size_t.t = Unsigned.Size_t.max_int

  (** [WGPU_WHOLE_MAP_SIZE] *)
  let whole_map_size : Unsigned.Size_t.t = Unsigned.Size_t.max_int

  (** [WGPU_WHOLE_SIZE] *)
  let whole_size : Unsigned.UInt64.t = Unsigned.UInt64.max_int

  let names : string list = [ "WGPU_TRUE"; "WGPU_FALSE"; "WGPU_ARRAY_LAYER_COUNT_UNDEFINED"; "WGPU_COPY_STRIDE_UNDEFINED"; "WGPU_DEPTH_CLEAR_VALUE_UNDEFINED"; "WGPU_DEPTH_SLICE_UNDEFINED"; "WGPU_LIMIT_U32_UNDEFINED"; "WGPU_LIMIT_U64_UNDEFINED"; "WGPU_MIP_LEVEL_COUNT_UNDEFINED"; "WGPU_QUERY_SET_INDEX_UNDEFINED"; "WGPU_STRLEN"; "WGPU_WHOLE_MAP_SIZE"; "WGPU_WHOLE_SIZE"; ]
end

(** [WGPUAdapter] -- opaque, reference counted handle. *)
module Adapter = struct
  let c_name = "WGPUAdapter"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUAdapterImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUBindGroup] -- opaque, reference counted handle. *)
module BindGroup = struct
  let c_name = "WGPUBindGroup"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUBindGroupImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUBindGroupLayout] -- opaque, reference counted handle. *)
module BindGroupLayout = struct
  let c_name = "WGPUBindGroupLayout"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUBindGroupLayoutImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUBuffer] -- opaque, reference counted handle. *)
module Buffer = struct
  let c_name = "WGPUBuffer"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUBufferImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUCommandBuffer] -- opaque, reference counted handle. *)
module CommandBuffer = struct
  let c_name = "WGPUCommandBuffer"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUCommandBufferImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUCommandEncoder] -- opaque, reference counted handle. *)
module CommandEncoder = struct
  let c_name = "WGPUCommandEncoder"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUCommandEncoderImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUComputePassEncoder] -- opaque, reference counted handle. *)
module ComputePassEncoder = struct
  let c_name = "WGPUComputePassEncoder"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUComputePassEncoderImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUComputePipeline] -- opaque, reference counted handle. *)
module ComputePipeline = struct
  let c_name = "WGPUComputePipeline"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUComputePipelineImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUDevice] -- opaque, reference counted handle. *)
module Device = struct
  let c_name = "WGPUDevice"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUDeviceImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUExternalTexture] -- opaque, reference counted handle. *)
module ExternalTexture = struct
  let c_name = "WGPUExternalTexture"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUExternalTextureImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUInstance] -- opaque, reference counted handle. *)
module Instance = struct
  let c_name = "WGPUInstance"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUInstanceImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUPipelineLayout] -- opaque, reference counted handle. *)
module PipelineLayout = struct
  let c_name = "WGPUPipelineLayout"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUPipelineLayoutImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUQuerySet] -- opaque, reference counted handle. *)
module QuerySet = struct
  let c_name = "WGPUQuerySet"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUQuerySetImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUQueue] -- opaque, reference counted handle. *)
module Queue = struct
  let c_name = "WGPUQueue"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUQueueImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPURenderBundle] -- opaque, reference counted handle. *)
module RenderBundle = struct
  let c_name = "WGPURenderBundle"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPURenderBundleImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPURenderBundleEncoder] -- opaque, reference counted handle. *)
module RenderBundleEncoder = struct
  let c_name = "WGPURenderBundleEncoder"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPURenderBundleEncoderImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPURenderPassEncoder] -- opaque, reference counted handle. *)
module RenderPassEncoder = struct
  let c_name = "WGPURenderPassEncoder"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPURenderPassEncoderImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPURenderPipeline] -- opaque, reference counted handle. *)
module RenderPipeline = struct
  let c_name = "WGPURenderPipeline"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPURenderPipelineImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUSampler] -- opaque, reference counted handle. *)
module Sampler = struct
  let c_name = "WGPUSampler"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUSamplerImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUShaderModule] -- opaque, reference counted handle. *)
module ShaderModule = struct
  let c_name = "WGPUShaderModule"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUShaderModuleImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUSurface] -- opaque, reference counted handle. *)
module Surface = struct
  let c_name = "WGPUSurface"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUSurfaceImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUTexture] -- opaque, reference counted handle. *)
module Texture = struct
  let c_name = "WGPUTexture"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUTextureImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUTextureView] -- opaque, reference counted handle. *)
module TextureView = struct
  let c_name = "WGPUTextureView"

  type impl

  let impl : impl Ctypes.structure Ctypes.typ = Ctypes.structure "WGPUTextureViewImpl"

  type t = impl Ctypes.structure Ctypes.ptr

  let t : t Ctypes.typ = Ctypes.ptr impl

  let null : t = Ctypes.from_voidp impl Ctypes.null

  let is_null (h : t) = Ctypes.ptr_compare (Ctypes.to_voidp h) Ctypes.null = 0
end

(** [WGPUAdapterType] (from webgpu.h) *)
module AdapterType = struct
  let c_name = "WGPUAdapterType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUAdapterType_DiscreteGPU] *)
  let discrete_gpu : t = 1

  (** [WGPUAdapterType_IntegratedGPU] *)
  let integrated_gpu : t = 2

  (** [WGPUAdapterType_CPU] *)
  let cpu : t = 3

  (** [WGPUAdapterType_Unknown] *)
  let unknown : t = 4

  (** [WGPUAdapterType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUAdapterType_DiscreteGPU", 1); ("WGPUAdapterType_IntegratedGPU", 2); ("WGPUAdapterType_CPU", 3); ("WGPUAdapterType_Unknown", 4); ("WGPUAdapterType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUAddressMode] (from webgpu.h) *)
module AddressMode = struct
  let c_name = "WGPUAddressMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUAddressMode_Undefined] *)
  let undefined : t = 0

  (** [WGPUAddressMode_ClampToEdge] *)
  let clamp_to_edge : t = 1

  (** [WGPUAddressMode_Repeat] *)
  let repeat : t = 2

  (** [WGPUAddressMode_MirrorRepeat] *)
  let mirror_repeat : t = 3

  (** [WGPUAddressMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUAddressMode_Undefined", 0); ("WGPUAddressMode_ClampToEdge", 1); ("WGPUAddressMode_Repeat", 2); ("WGPUAddressMode_MirrorRepeat", 3); ("WGPUAddressMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUBackendType] (from webgpu.h) *)
module BackendType = struct
  let c_name = "WGPUBackendType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUBackendType_Undefined] *)
  let undefined : t = 0

  (** [WGPUBackendType_Null] *)
  let null : t = 1

  (** [WGPUBackendType_WebGPU] *)
  let web_gpu : t = 2

  (** [WGPUBackendType_D3D11] *)
  let d3_d11 : t = 3

  (** [WGPUBackendType_D3D12] *)
  let d3_d12 : t = 4

  (** [WGPUBackendType_Metal] *)
  let metal : t = 5

  (** [WGPUBackendType_Vulkan] *)
  let vulkan : t = 6

  (** [WGPUBackendType_OpenGL] *)
  let open_gl : t = 7

  (** [WGPUBackendType_OpenGLES] *)
  let open_gles : t = 8

  (** [WGPUBackendType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUBackendType_Undefined", 0); ("WGPUBackendType_Null", 1); ("WGPUBackendType_WebGPU", 2); ("WGPUBackendType_D3D11", 3); ("WGPUBackendType_D3D12", 4); ("WGPUBackendType_Metal", 5); ("WGPUBackendType_Vulkan", 6); ("WGPUBackendType_OpenGL", 7); ("WGPUBackendType_OpenGLES", 8); ("WGPUBackendType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUBlendFactor] (from webgpu.h) *)
module BlendFactor = struct
  let c_name = "WGPUBlendFactor"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUBlendFactor_Undefined] *)
  let undefined : t = 0

  (** [WGPUBlendFactor_Zero] *)
  let zero : t = 1

  (** [WGPUBlendFactor_One] *)
  let one : t = 2

  (** [WGPUBlendFactor_Src] *)
  let src : t = 3

  (** [WGPUBlendFactor_OneMinusSrc] *)
  let one_minus_src : t = 4

  (** [WGPUBlendFactor_SrcAlpha] *)
  let src_alpha : t = 5

  (** [WGPUBlendFactor_OneMinusSrcAlpha] *)
  let one_minus_src_alpha : t = 6

  (** [WGPUBlendFactor_Dst] *)
  let dst : t = 7

  (** [WGPUBlendFactor_OneMinusDst] *)
  let one_minus_dst : t = 8

  (** [WGPUBlendFactor_DstAlpha] *)
  let dst_alpha : t = 9

  (** [WGPUBlendFactor_OneMinusDstAlpha] *)
  let one_minus_dst_alpha : t = 10

  (** [WGPUBlendFactor_SrcAlphaSaturated] *)
  let src_alpha_saturated : t = 11

  (** [WGPUBlendFactor_Constant] *)
  let constant : t = 12

  (** [WGPUBlendFactor_OneMinusConstant] *)
  let one_minus_constant : t = 13

  (** [WGPUBlendFactor_Src1] *)
  let src1 : t = 14

  (** [WGPUBlendFactor_OneMinusSrc1] *)
  let one_minus_src1 : t = 15

  (** [WGPUBlendFactor_Src1Alpha] *)
  let src1_alpha : t = 16

  (** [WGPUBlendFactor_OneMinusSrc1Alpha] *)
  let one_minus_src1_alpha : t = 17

  (** [WGPUBlendFactor_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUBlendFactor_Undefined", 0); ("WGPUBlendFactor_Zero", 1); ("WGPUBlendFactor_One", 2); ("WGPUBlendFactor_Src", 3); ("WGPUBlendFactor_OneMinusSrc", 4); ("WGPUBlendFactor_SrcAlpha", 5); ("WGPUBlendFactor_OneMinusSrcAlpha", 6); ("WGPUBlendFactor_Dst", 7); ("WGPUBlendFactor_OneMinusDst", 8); ("WGPUBlendFactor_DstAlpha", 9); ("WGPUBlendFactor_OneMinusDstAlpha", 10); ("WGPUBlendFactor_SrcAlphaSaturated", 11); ("WGPUBlendFactor_Constant", 12); ("WGPUBlendFactor_OneMinusConstant", 13); ("WGPUBlendFactor_Src1", 14); ("WGPUBlendFactor_OneMinusSrc1", 15); ("WGPUBlendFactor_Src1Alpha", 16); ("WGPUBlendFactor_OneMinusSrc1Alpha", 17); ("WGPUBlendFactor_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUBlendOperation] (from webgpu.h) *)
module BlendOperation = struct
  let c_name = "WGPUBlendOperation"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUBlendOperation_Undefined] *)
  let undefined : t = 0

  (** [WGPUBlendOperation_Add] *)
  let add : t = 1

  (** [WGPUBlendOperation_Subtract] *)
  let subtract : t = 2

  (** [WGPUBlendOperation_ReverseSubtract] *)
  let reverse_subtract : t = 3

  (** [WGPUBlendOperation_Min] *)
  let min : t = 4

  (** [WGPUBlendOperation_Max] *)
  let max : t = 5

  (** [WGPUBlendOperation_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUBlendOperation_Undefined", 0); ("WGPUBlendOperation_Add", 1); ("WGPUBlendOperation_Subtract", 2); ("WGPUBlendOperation_ReverseSubtract", 3); ("WGPUBlendOperation_Min", 4); ("WGPUBlendOperation_Max", 5); ("WGPUBlendOperation_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUBufferBindingType] (from webgpu.h) *)
module BufferBindingType = struct
  let c_name = "WGPUBufferBindingType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUBufferBindingType_BindingNotUsed] *)
  let binding_not_used : t = 0

  (** [WGPUBufferBindingType_Undefined] *)
  let undefined : t = 1

  (** [WGPUBufferBindingType_Uniform] *)
  let uniform : t = 2

  (** [WGPUBufferBindingType_Storage] *)
  let storage : t = 3

  (** [WGPUBufferBindingType_ReadOnlyStorage] *)
  let read_only_storage : t = 4

  (** [WGPUBufferBindingType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUBufferBindingType_BindingNotUsed", 0); ("WGPUBufferBindingType_Undefined", 1); ("WGPUBufferBindingType_Uniform", 2); ("WGPUBufferBindingType_Storage", 3); ("WGPUBufferBindingType_ReadOnlyStorage", 4); ("WGPUBufferBindingType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUBufferMapState] (from webgpu.h) *)
module BufferMapState = struct
  let c_name = "WGPUBufferMapState"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUBufferMapState_Unmapped] *)
  let unmapped : t = 1

  (** [WGPUBufferMapState_Pending] *)
  let pending : t = 2

  (** [WGPUBufferMapState_Mapped] *)
  let mapped : t = 3

  (** [WGPUBufferMapState_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUBufferMapState_Unmapped", 1); ("WGPUBufferMapState_Pending", 2); ("WGPUBufferMapState_Mapped", 3); ("WGPUBufferMapState_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUCallbackMode] (from webgpu.h) *)
module CallbackMode = struct
  let c_name = "WGPUCallbackMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUCallbackMode_WaitAnyOnly] *)
  let wait_any_only : t = 1

  (** [WGPUCallbackMode_AllowProcessEvents] *)
  let allow_process_events : t = 2

  (** [WGPUCallbackMode_AllowSpontaneous] *)
  let allow_spontaneous : t = 3

  (** [WGPUCallbackMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUCallbackMode_WaitAnyOnly", 1); ("WGPUCallbackMode_AllowProcessEvents", 2); ("WGPUCallbackMode_AllowSpontaneous", 3); ("WGPUCallbackMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUCompareFunction] (from webgpu.h) *)
module CompareFunction = struct
  let c_name = "WGPUCompareFunction"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUCompareFunction_Undefined] *)
  let undefined : t = 0

  (** [WGPUCompareFunction_Never] *)
  let never : t = 1

  (** [WGPUCompareFunction_Less] *)
  let less : t = 2

  (** [WGPUCompareFunction_Equal] *)
  let equal : t = 3

  (** [WGPUCompareFunction_LessEqual] *)
  let less_equal : t = 4

  (** [WGPUCompareFunction_Greater] *)
  let greater : t = 5

  (** [WGPUCompareFunction_NotEqual] *)
  let not_equal : t = 6

  (** [WGPUCompareFunction_GreaterEqual] *)
  let greater_equal : t = 7

  (** [WGPUCompareFunction_Always] *)
  let always : t = 8

  (** [WGPUCompareFunction_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUCompareFunction_Undefined", 0); ("WGPUCompareFunction_Never", 1); ("WGPUCompareFunction_Less", 2); ("WGPUCompareFunction_Equal", 3); ("WGPUCompareFunction_LessEqual", 4); ("WGPUCompareFunction_Greater", 5); ("WGPUCompareFunction_NotEqual", 6); ("WGPUCompareFunction_GreaterEqual", 7); ("WGPUCompareFunction_Always", 8); ("WGPUCompareFunction_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUCompilationInfoRequestStatus] (from webgpu.h) *)
module CompilationInfoRequestStatus = struct
  let c_name = "WGPUCompilationInfoRequestStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUCompilationInfoRequestStatus_Success] *)
  let success : t = 1

  (** [WGPUCompilationInfoRequestStatus_CallbackCancelled] *)
  let callback_cancelled : t = 2

  (** [WGPUCompilationInfoRequestStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUCompilationInfoRequestStatus_Success", 1); ("WGPUCompilationInfoRequestStatus_CallbackCancelled", 2); ("WGPUCompilationInfoRequestStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUCompilationMessageType] (from webgpu.h) *)
module CompilationMessageType = struct
  let c_name = "WGPUCompilationMessageType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUCompilationMessageType_Error] *)
  let error : t = 1

  (** [WGPUCompilationMessageType_Warning] *)
  let warning : t = 2

  (** [WGPUCompilationMessageType_Info] *)
  let info : t = 3

  (** [WGPUCompilationMessageType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUCompilationMessageType_Error", 1); ("WGPUCompilationMessageType_Warning", 2); ("WGPUCompilationMessageType_Info", 3); ("WGPUCompilationMessageType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUComponentSwizzle] (from webgpu.h) *)
module ComponentSwizzle = struct
  let c_name = "WGPUComponentSwizzle"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUComponentSwizzle_Undefined] *)
  let undefined : t = 0

  (** [WGPUComponentSwizzle_Zero] *)
  let zero : t = 1

  (** [WGPUComponentSwizzle_One] *)
  let one : t = 2

  (** [WGPUComponentSwizzle_R] *)
  let r : t = 3

  (** [WGPUComponentSwizzle_G] *)
  let g : t = 4

  (** [WGPUComponentSwizzle_B] *)
  let b : t = 5

  (** [WGPUComponentSwizzle_A] *)
  let a : t = 6

  (** [WGPUComponentSwizzle_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUComponentSwizzle_Undefined", 0); ("WGPUComponentSwizzle_Zero", 1); ("WGPUComponentSwizzle_One", 2); ("WGPUComponentSwizzle_R", 3); ("WGPUComponentSwizzle_G", 4); ("WGPUComponentSwizzle_B", 5); ("WGPUComponentSwizzle_A", 6); ("WGPUComponentSwizzle_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUCompositeAlphaMode] (from webgpu.h) *)
module CompositeAlphaMode = struct
  let c_name = "WGPUCompositeAlphaMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUCompositeAlphaMode_Auto] *)
  let auto : t = 0

  (** [WGPUCompositeAlphaMode_Opaque] *)
  let opaque : t = 1

  (** [WGPUCompositeAlphaMode_Premultiplied] *)
  let premultiplied : t = 2

  (** [WGPUCompositeAlphaMode_Unpremultiplied] *)
  let unpremultiplied : t = 3

  (** [WGPUCompositeAlphaMode_Inherit] *)
  let inherit_ : t = 4

  (** [WGPUCompositeAlphaMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUCompositeAlphaMode_Auto", 0); ("WGPUCompositeAlphaMode_Opaque", 1); ("WGPUCompositeAlphaMode_Premultiplied", 2); ("WGPUCompositeAlphaMode_Unpremultiplied", 3); ("WGPUCompositeAlphaMode_Inherit", 4); ("WGPUCompositeAlphaMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUCreatePipelineAsyncStatus] (from webgpu.h) *)
module CreatePipelineAsyncStatus = struct
  let c_name = "WGPUCreatePipelineAsyncStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUCreatePipelineAsyncStatus_Success] *)
  let success : t = 1

  (** [WGPUCreatePipelineAsyncStatus_CallbackCancelled] *)
  let callback_cancelled : t = 2

  (** [WGPUCreatePipelineAsyncStatus_ValidationError] *)
  let validation_error : t = 3

  (** [WGPUCreatePipelineAsyncStatus_InternalError] *)
  let internal_error : t = 4

  (** [WGPUCreatePipelineAsyncStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUCreatePipelineAsyncStatus_Success", 1); ("WGPUCreatePipelineAsyncStatus_CallbackCancelled", 2); ("WGPUCreatePipelineAsyncStatus_ValidationError", 3); ("WGPUCreatePipelineAsyncStatus_InternalError", 4); ("WGPUCreatePipelineAsyncStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUCullMode] (from webgpu.h) *)
module CullMode = struct
  let c_name = "WGPUCullMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUCullMode_Undefined] *)
  let undefined : t = 0

  (** [WGPUCullMode_None] *)
  let none : t = 1

  (** [WGPUCullMode_Front] *)
  let front : t = 2

  (** [WGPUCullMode_Back] *)
  let back : t = 3

  (** [WGPUCullMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUCullMode_Undefined", 0); ("WGPUCullMode_None", 1); ("WGPUCullMode_Front", 2); ("WGPUCullMode_Back", 3); ("WGPUCullMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUDeviceLostReason] (from webgpu.h) *)
module DeviceLostReason = struct
  let c_name = "WGPUDeviceLostReason"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUDeviceLostReason_Unknown] *)
  let unknown : t = 1

  (** [WGPUDeviceLostReason_Destroyed] *)
  let destroyed : t = 2

  (** [WGPUDeviceLostReason_CallbackCancelled] *)
  let callback_cancelled : t = 3

  (** [WGPUDeviceLostReason_FailedCreation] *)
  let failed_creation : t = 4

  (** [WGPUDeviceLostReason_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUDeviceLostReason_Unknown", 1); ("WGPUDeviceLostReason_Destroyed", 2); ("WGPUDeviceLostReason_CallbackCancelled", 3); ("WGPUDeviceLostReason_FailedCreation", 4); ("WGPUDeviceLostReason_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUErrorFilter] (from webgpu.h) *)
module ErrorFilter = struct
  let c_name = "WGPUErrorFilter"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUErrorFilter_Validation] *)
  let validation : t = 1

  (** [WGPUErrorFilter_OutOfMemory] *)
  let out_of_memory : t = 2

  (** [WGPUErrorFilter_Internal] *)
  let internal : t = 3

  (** [WGPUErrorFilter_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUErrorFilter_Validation", 1); ("WGPUErrorFilter_OutOfMemory", 2); ("WGPUErrorFilter_Internal", 3); ("WGPUErrorFilter_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUErrorType] (from webgpu.h) *)
module ErrorType = struct
  let c_name = "WGPUErrorType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUErrorType_NoError] *)
  let no_error : t = 1

  (** [WGPUErrorType_Validation] *)
  let validation : t = 2

  (** [WGPUErrorType_OutOfMemory] *)
  let out_of_memory : t = 3

  (** [WGPUErrorType_Internal] *)
  let internal : t = 4

  (** [WGPUErrorType_Unknown] *)
  let unknown : t = 5

  (** [WGPUErrorType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUErrorType_NoError", 1); ("WGPUErrorType_Validation", 2); ("WGPUErrorType_OutOfMemory", 3); ("WGPUErrorType_Internal", 4); ("WGPUErrorType_Unknown", 5); ("WGPUErrorType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUFeatureLevel] (from webgpu.h) *)
module FeatureLevel = struct
  let c_name = "WGPUFeatureLevel"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUFeatureLevel_Undefined] *)
  let undefined : t = 0

  (** [WGPUFeatureLevel_Compatibility] *)
  let compatibility : t = 1

  (** [WGPUFeatureLevel_Core] *)
  let core : t = 2

  (** [WGPUFeatureLevel_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUFeatureLevel_Undefined", 0); ("WGPUFeatureLevel_Compatibility", 1); ("WGPUFeatureLevel_Core", 2); ("WGPUFeatureLevel_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUFeatureName] (from webgpu.h) *)
module FeatureName = struct
  let c_name = "WGPUFeatureName"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUFeatureName_CoreFeaturesAndLimits] *)
  let core_features_and_limits : t = 1

  (** [WGPUFeatureName_DepthClipControl] *)
  let depth_clip_control : t = 2

  (** [WGPUFeatureName_Depth32FloatStencil8] *)
  let depth32_float_stencil8 : t = 3

  (** [WGPUFeatureName_TextureCompressionBC] *)
  let texture_compression_bc : t = 4

  (** [WGPUFeatureName_TextureCompressionBCSliced3D] *)
  let texture_compression_bc_sliced3_d : t = 5

  (** [WGPUFeatureName_TextureCompressionETC2] *)
  let texture_compression_etc2 : t = 6

  (** [WGPUFeatureName_TextureCompressionASTC] *)
  let texture_compression_astc : t = 7

  (** [WGPUFeatureName_TextureCompressionASTCSliced3D] *)
  let texture_compression_astc_sliced3_d : t = 8

  (** [WGPUFeatureName_TimestampQuery] *)
  let timestamp_query : t = 9

  (** [WGPUFeatureName_IndirectFirstInstance] *)
  let indirect_first_instance : t = 10

  (** [WGPUFeatureName_ShaderF16] *)
  let shader_f16 : t = 11

  (** [WGPUFeatureName_RG11B10UfloatRenderable] *)
  let rg11_b10_ufloat_renderable : t = 12

  (** [WGPUFeatureName_BGRA8UnormStorage] *)
  let bgra8_unorm_storage : t = 13

  (** [WGPUFeatureName_Float32Filterable] *)
  let float32_filterable : t = 14

  (** [WGPUFeatureName_Float32Blendable] *)
  let float32_blendable : t = 15

  (** [WGPUFeatureName_ClipDistances] *)
  let clip_distances : t = 16

  (** [WGPUFeatureName_DualSourceBlending] *)
  let dual_source_blending : t = 17

  (** [WGPUFeatureName_Subgroups] *)
  let subgroups : t = 18

  (** [WGPUFeatureName_TextureFormatsTier1] *)
  let texture_formats_tier1 : t = 19

  (** [WGPUFeatureName_TextureFormatsTier2] *)
  let texture_formats_tier2 : t = 20

  (** [WGPUFeatureName_PrimitiveIndex] *)
  let primitive_index : t = 21

  (** [WGPUFeatureName_TextureComponentSwizzle] *)
  let texture_component_swizzle : t = 22

  (** [WGPUFeatureName_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUFeatureName_CoreFeaturesAndLimits", 1); ("WGPUFeatureName_DepthClipControl", 2); ("WGPUFeatureName_Depth32FloatStencil8", 3); ("WGPUFeatureName_TextureCompressionBC", 4); ("WGPUFeatureName_TextureCompressionBCSliced3D", 5); ("WGPUFeatureName_TextureCompressionETC2", 6); ("WGPUFeatureName_TextureCompressionASTC", 7); ("WGPUFeatureName_TextureCompressionASTCSliced3D", 8); ("WGPUFeatureName_TimestampQuery", 9); ("WGPUFeatureName_IndirectFirstInstance", 10); ("WGPUFeatureName_ShaderF16", 11); ("WGPUFeatureName_RG11B10UfloatRenderable", 12); ("WGPUFeatureName_BGRA8UnormStorage", 13); ("WGPUFeatureName_Float32Filterable", 14); ("WGPUFeatureName_Float32Blendable", 15); ("WGPUFeatureName_ClipDistances", 16); ("WGPUFeatureName_DualSourceBlending", 17); ("WGPUFeatureName_Subgroups", 18); ("WGPUFeatureName_TextureFormatsTier1", 19); ("WGPUFeatureName_TextureFormatsTier2", 20); ("WGPUFeatureName_PrimitiveIndex", 21); ("WGPUFeatureName_TextureComponentSwizzle", 22); ("WGPUFeatureName_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUFilterMode] (from webgpu.h) *)
module FilterMode = struct
  let c_name = "WGPUFilterMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUFilterMode_Undefined] *)
  let undefined : t = 0

  (** [WGPUFilterMode_Nearest] *)
  let nearest : t = 1

  (** [WGPUFilterMode_Linear] *)
  let linear : t = 2

  (** [WGPUFilterMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUFilterMode_Undefined", 0); ("WGPUFilterMode_Nearest", 1); ("WGPUFilterMode_Linear", 2); ("WGPUFilterMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUFrontFace] (from webgpu.h) *)
module FrontFace = struct
  let c_name = "WGPUFrontFace"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUFrontFace_Undefined] *)
  let undefined : t = 0

  (** [WGPUFrontFace_CCW] *)
  let ccw : t = 1

  (** [WGPUFrontFace_CW] *)
  let cw : t = 2

  (** [WGPUFrontFace_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUFrontFace_Undefined", 0); ("WGPUFrontFace_CCW", 1); ("WGPUFrontFace_CW", 2); ("WGPUFrontFace_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUIndexFormat] (from webgpu.h) *)
module IndexFormat = struct
  let c_name = "WGPUIndexFormat"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUIndexFormat_Undefined] *)
  let undefined : t = 0

  (** [WGPUIndexFormat_Uint16] *)
  let uint16 : t = 1

  (** [WGPUIndexFormat_Uint32] *)
  let uint32 : t = 2

  (** [WGPUIndexFormat_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUIndexFormat_Undefined", 0); ("WGPUIndexFormat_Uint16", 1); ("WGPUIndexFormat_Uint32", 2); ("WGPUIndexFormat_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUInstanceFeatureName] (from webgpu.h) *)
module InstanceFeatureName = struct
  let c_name = "WGPUInstanceFeatureName"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUInstanceFeatureName_TimedWaitAny] *)
  let timed_wait_any : t = 1

  (** [WGPUInstanceFeatureName_ShaderSourceSPIRV] *)
  let shader_source_spirv : t = 2

  (** [WGPUInstanceFeatureName_MultipleDevicesPerAdapter] *)
  let multiple_devices_per_adapter : t = 3

  (** [WGPUInstanceFeatureName_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUInstanceFeatureName_TimedWaitAny", 1); ("WGPUInstanceFeatureName_ShaderSourceSPIRV", 2); ("WGPUInstanceFeatureName_MultipleDevicesPerAdapter", 3); ("WGPUInstanceFeatureName_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPULoadOp] (from webgpu.h) *)
module LoadOp = struct
  let c_name = "WGPULoadOp"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPULoadOp_Undefined] *)
  let undefined : t = 0

  (** [WGPULoadOp_Load] *)
  let load : t = 1

  (** [WGPULoadOp_Clear] *)
  let clear : t = 2

  (** [WGPULoadOp_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPULoadOp_Undefined", 0); ("WGPULoadOp_Load", 1); ("WGPULoadOp_Clear", 2); ("WGPULoadOp_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUMapAsyncStatus] (from webgpu.h) *)
module MapAsyncStatus = struct
  let c_name = "WGPUMapAsyncStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUMapAsyncStatus_Success] *)
  let success : t = 1

  (** [WGPUMapAsyncStatus_CallbackCancelled] *)
  let callback_cancelled : t = 2

  (** [WGPUMapAsyncStatus_Error] *)
  let error : t = 3

  (** [WGPUMapAsyncStatus_Aborted] *)
  let aborted : t = 4

  (** [WGPUMapAsyncStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUMapAsyncStatus_Success", 1); ("WGPUMapAsyncStatus_CallbackCancelled", 2); ("WGPUMapAsyncStatus_Error", 3); ("WGPUMapAsyncStatus_Aborted", 4); ("WGPUMapAsyncStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUMipmapFilterMode] (from webgpu.h) *)
module MipmapFilterMode = struct
  let c_name = "WGPUMipmapFilterMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUMipmapFilterMode_Undefined] *)
  let undefined : t = 0

  (** [WGPUMipmapFilterMode_Nearest] *)
  let nearest : t = 1

  (** [WGPUMipmapFilterMode_Linear] *)
  let linear : t = 2

  (** [WGPUMipmapFilterMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUMipmapFilterMode_Undefined", 0); ("WGPUMipmapFilterMode_Nearest", 1); ("WGPUMipmapFilterMode_Linear", 2); ("WGPUMipmapFilterMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUOptionalBool] (from webgpu.h) *)
module OptionalBool = struct
  let c_name = "WGPUOptionalBool"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUOptionalBool_False] *)
  let false_ : t = 0

  (** [WGPUOptionalBool_True] *)
  let true_ : t = 1

  (** [WGPUOptionalBool_Undefined] *)
  let undefined : t = 2

  (** [WGPUOptionalBool_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUOptionalBool_False", 0); ("WGPUOptionalBool_True", 1); ("WGPUOptionalBool_Undefined", 2); ("WGPUOptionalBool_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUPopErrorScopeStatus] (from webgpu.h) *)
module PopErrorScopeStatus = struct
  let c_name = "WGPUPopErrorScopeStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUPopErrorScopeStatus_Success] *)
  let success : t = 1

  (** [WGPUPopErrorScopeStatus_CallbackCancelled] *)
  let callback_cancelled : t = 2

  (** [WGPUPopErrorScopeStatus_Error] *)
  let error : t = 3

  (** [WGPUPopErrorScopeStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUPopErrorScopeStatus_Success", 1); ("WGPUPopErrorScopeStatus_CallbackCancelled", 2); ("WGPUPopErrorScopeStatus_Error", 3); ("WGPUPopErrorScopeStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUPowerPreference] (from webgpu.h) *)
module PowerPreference = struct
  let c_name = "WGPUPowerPreference"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUPowerPreference_Undefined] *)
  let undefined : t = 0

  (** [WGPUPowerPreference_LowPower] *)
  let low_power : t = 1

  (** [WGPUPowerPreference_HighPerformance] *)
  let high_performance : t = 2

  (** [WGPUPowerPreference_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUPowerPreference_Undefined", 0); ("WGPUPowerPreference_LowPower", 1); ("WGPUPowerPreference_HighPerformance", 2); ("WGPUPowerPreference_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUPredefinedColorSpace] (from webgpu.h) *)
module PredefinedColorSpace = struct
  let c_name = "WGPUPredefinedColorSpace"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUPredefinedColorSpace_SRGB] *)
  let srgb : t = 1

  (** [WGPUPredefinedColorSpace_DisplayP3] *)
  let display_p3 : t = 2

  (** [WGPUPredefinedColorSpace_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUPredefinedColorSpace_SRGB", 1); ("WGPUPredefinedColorSpace_DisplayP3", 2); ("WGPUPredefinedColorSpace_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUPresentMode] (from webgpu.h) *)
module PresentMode = struct
  let c_name = "WGPUPresentMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUPresentMode_Undefined] *)
  let undefined : t = 0

  (** [WGPUPresentMode_Fifo] *)
  let fifo : t = 1

  (** [WGPUPresentMode_FifoRelaxed] *)
  let fifo_relaxed : t = 2

  (** [WGPUPresentMode_Immediate] *)
  let immediate : t = 3

  (** [WGPUPresentMode_Mailbox] *)
  let mailbox : t = 4

  (** [WGPUPresentMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUPresentMode_Undefined", 0); ("WGPUPresentMode_Fifo", 1); ("WGPUPresentMode_FifoRelaxed", 2); ("WGPUPresentMode_Immediate", 3); ("WGPUPresentMode_Mailbox", 4); ("WGPUPresentMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUPrimitiveTopology] (from webgpu.h) *)
module PrimitiveTopology = struct
  let c_name = "WGPUPrimitiveTopology"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUPrimitiveTopology_Undefined] *)
  let undefined : t = 0

  (** [WGPUPrimitiveTopology_PointList] *)
  let point_list : t = 1

  (** [WGPUPrimitiveTopology_LineList] *)
  let line_list : t = 2

  (** [WGPUPrimitiveTopology_LineStrip] *)
  let line_strip : t = 3

  (** [WGPUPrimitiveTopology_TriangleList] *)
  let triangle_list : t = 4

  (** [WGPUPrimitiveTopology_TriangleStrip] *)
  let triangle_strip : t = 5

  (** [WGPUPrimitiveTopology_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUPrimitiveTopology_Undefined", 0); ("WGPUPrimitiveTopology_PointList", 1); ("WGPUPrimitiveTopology_LineList", 2); ("WGPUPrimitiveTopology_LineStrip", 3); ("WGPUPrimitiveTopology_TriangleList", 4); ("WGPUPrimitiveTopology_TriangleStrip", 5); ("WGPUPrimitiveTopology_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUQueryType] (from webgpu.h) *)
module QueryType = struct
  let c_name = "WGPUQueryType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUQueryType_Occlusion] *)
  let occlusion : t = 1

  (** [WGPUQueryType_Timestamp] *)
  let timestamp : t = 2

  (** [WGPUQueryType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUQueryType_Occlusion", 1); ("WGPUQueryType_Timestamp", 2); ("WGPUQueryType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUQueueWorkDoneStatus] (from webgpu.h) *)
module QueueWorkDoneStatus = struct
  let c_name = "WGPUQueueWorkDoneStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUQueueWorkDoneStatus_Success] *)
  let success : t = 1

  (** [WGPUQueueWorkDoneStatus_CallbackCancelled] *)
  let callback_cancelled : t = 2

  (** [WGPUQueueWorkDoneStatus_Error] *)
  let error : t = 3

  (** [WGPUQueueWorkDoneStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUQueueWorkDoneStatus_Success", 1); ("WGPUQueueWorkDoneStatus_CallbackCancelled", 2); ("WGPUQueueWorkDoneStatus_Error", 3); ("WGPUQueueWorkDoneStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPURequestAdapterStatus] (from webgpu.h) *)
module RequestAdapterStatus = struct
  let c_name = "WGPURequestAdapterStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPURequestAdapterStatus_Success] *)
  let success : t = 1

  (** [WGPURequestAdapterStatus_CallbackCancelled] *)
  let callback_cancelled : t = 2

  (** [WGPURequestAdapterStatus_Unavailable] *)
  let unavailable : t = 3

  (** [WGPURequestAdapterStatus_Error] *)
  let error : t = 4

  (** [WGPURequestAdapterStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPURequestAdapterStatus_Success", 1); ("WGPURequestAdapterStatus_CallbackCancelled", 2); ("WGPURequestAdapterStatus_Unavailable", 3); ("WGPURequestAdapterStatus_Error", 4); ("WGPURequestAdapterStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPURequestDeviceStatus] (from webgpu.h) *)
module RequestDeviceStatus = struct
  let c_name = "WGPURequestDeviceStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPURequestDeviceStatus_Success] *)
  let success : t = 1

  (** [WGPURequestDeviceStatus_CallbackCancelled] *)
  let callback_cancelled : t = 2

  (** [WGPURequestDeviceStatus_Error] *)
  let error : t = 3

  (** [WGPURequestDeviceStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPURequestDeviceStatus_Success", 1); ("WGPURequestDeviceStatus_CallbackCancelled", 2); ("WGPURequestDeviceStatus_Error", 3); ("WGPURequestDeviceStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUSamplerBindingType] (from webgpu.h) *)
module SamplerBindingType = struct
  let c_name = "WGPUSamplerBindingType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUSamplerBindingType_BindingNotUsed] *)
  let binding_not_used : t = 0

  (** [WGPUSamplerBindingType_Undefined] *)
  let undefined : t = 1

  (** [WGPUSamplerBindingType_Filtering] *)
  let filtering : t = 2

  (** [WGPUSamplerBindingType_NonFiltering] *)
  let non_filtering : t = 3

  (** [WGPUSamplerBindingType_Comparison] *)
  let comparison : t = 4

  (** [WGPUSamplerBindingType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUSamplerBindingType_BindingNotUsed", 0); ("WGPUSamplerBindingType_Undefined", 1); ("WGPUSamplerBindingType_Filtering", 2); ("WGPUSamplerBindingType_NonFiltering", 3); ("WGPUSamplerBindingType_Comparison", 4); ("WGPUSamplerBindingType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUStatus] (from webgpu.h) *)
module Status = struct
  let c_name = "WGPUStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUStatus_Success] *)
  let success : t = 1

  (** [WGPUStatus_Error] *)
  let error : t = 2

  (** [WGPUStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUStatus_Success", 1); ("WGPUStatus_Error", 2); ("WGPUStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUStencilOperation] (from webgpu.h) *)
module StencilOperation = struct
  let c_name = "WGPUStencilOperation"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUStencilOperation_Undefined] *)
  let undefined : t = 0

  (** [WGPUStencilOperation_Keep] *)
  let keep : t = 1

  (** [WGPUStencilOperation_Zero] *)
  let zero : t = 2

  (** [WGPUStencilOperation_Replace] *)
  let replace : t = 3

  (** [WGPUStencilOperation_Invert] *)
  let invert : t = 4

  (** [WGPUStencilOperation_IncrementClamp] *)
  let increment_clamp : t = 5

  (** [WGPUStencilOperation_DecrementClamp] *)
  let decrement_clamp : t = 6

  (** [WGPUStencilOperation_IncrementWrap] *)
  let increment_wrap : t = 7

  (** [WGPUStencilOperation_DecrementWrap] *)
  let decrement_wrap : t = 8

  (** [WGPUStencilOperation_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUStencilOperation_Undefined", 0); ("WGPUStencilOperation_Keep", 1); ("WGPUStencilOperation_Zero", 2); ("WGPUStencilOperation_Replace", 3); ("WGPUStencilOperation_Invert", 4); ("WGPUStencilOperation_IncrementClamp", 5); ("WGPUStencilOperation_DecrementClamp", 6); ("WGPUStencilOperation_IncrementWrap", 7); ("WGPUStencilOperation_DecrementWrap", 8); ("WGPUStencilOperation_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUStorageTextureAccess] (from webgpu.h) *)
module StorageTextureAccess = struct
  let c_name = "WGPUStorageTextureAccess"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUStorageTextureAccess_BindingNotUsed] *)
  let binding_not_used : t = 0

  (** [WGPUStorageTextureAccess_Undefined] *)
  let undefined : t = 1

  (** [WGPUStorageTextureAccess_WriteOnly] *)
  let write_only : t = 2

  (** [WGPUStorageTextureAccess_ReadOnly] *)
  let read_only : t = 3

  (** [WGPUStorageTextureAccess_ReadWrite] *)
  let read_write : t = 4

  (** [WGPUStorageTextureAccess_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUStorageTextureAccess_BindingNotUsed", 0); ("WGPUStorageTextureAccess_Undefined", 1); ("WGPUStorageTextureAccess_WriteOnly", 2); ("WGPUStorageTextureAccess_ReadOnly", 3); ("WGPUStorageTextureAccess_ReadWrite", 4); ("WGPUStorageTextureAccess_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUStoreOp] (from webgpu.h) *)
module StoreOp = struct
  let c_name = "WGPUStoreOp"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUStoreOp_Undefined] *)
  let undefined : t = 0

  (** [WGPUStoreOp_Store] *)
  let store : t = 1

  (** [WGPUStoreOp_Discard] *)
  let discard : t = 2

  (** [WGPUStoreOp_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUStoreOp_Undefined", 0); ("WGPUStoreOp_Store", 1); ("WGPUStoreOp_Discard", 2); ("WGPUStoreOp_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUSType] (from webgpu.h) *)
module SType = struct
  let c_name = "WGPUSType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUSType_ShaderSourceSPIRV] *)
  let shader_source_spirv : t = 1

  (** [WGPUSType_ShaderSourceWGSL] *)
  let shader_source_wgsl : t = 2

  (** [WGPUSType_RenderPassMaxDrawCount] *)
  let render_pass_max_draw_count : t = 3

  (** [WGPUSType_SurfaceSourceMetalLayer] *)
  let surface_source_metal_layer : t = 4

  (** [WGPUSType_SurfaceSourceWindowsHWND] *)
  let surface_source_windows_hwnd : t = 5

  (** [WGPUSType_SurfaceSourceXlibWindow] *)
  let surface_source_xlib_window : t = 6

  (** [WGPUSType_SurfaceSourceWaylandSurface] *)
  let surface_source_wayland_surface : t = 7

  (** [WGPUSType_SurfaceSourceAndroidNativeWindow] *)
  let surface_source_android_native_window : t = 8

  (** [WGPUSType_SurfaceSourceXCBWindow] *)
  let surface_source_xcb_window : t = 9

  (** [WGPUSType_SurfaceColorManagement] *)
  let surface_color_management : t = 10

  (** [WGPUSType_RequestAdapterWebXROptions] *)
  let request_adapter_web_xr_options : t = 11

  (** [WGPUSType_TextureComponentSwizzleDescriptor] *)
  let texture_component_swizzle_descriptor : t = 12

  (** [WGPUSType_ExternalTextureBindingLayout] *)
  let external_texture_binding_layout : t = 13

  (** [WGPUSType_ExternalTextureBindingEntry] *)
  let external_texture_binding_entry : t = 14

  (** [WGPUSType_CompatibilityModeLimits] *)
  let compatibility_mode_limits : t = 15

  (** [WGPUSType_TextureBindingViewDimension] *)
  let texture_binding_view_dimension : t = 16

  (** [WGPUSType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUSType_ShaderSourceSPIRV", 1); ("WGPUSType_ShaderSourceWGSL", 2); ("WGPUSType_RenderPassMaxDrawCount", 3); ("WGPUSType_SurfaceSourceMetalLayer", 4); ("WGPUSType_SurfaceSourceWindowsHWND", 5); ("WGPUSType_SurfaceSourceXlibWindow", 6); ("WGPUSType_SurfaceSourceWaylandSurface", 7); ("WGPUSType_SurfaceSourceAndroidNativeWindow", 8); ("WGPUSType_SurfaceSourceXCBWindow", 9); ("WGPUSType_SurfaceColorManagement", 10); ("WGPUSType_RequestAdapterWebXROptions", 11); ("WGPUSType_TextureComponentSwizzleDescriptor", 12); ("WGPUSType_ExternalTextureBindingLayout", 13); ("WGPUSType_ExternalTextureBindingEntry", 14); ("WGPUSType_CompatibilityModeLimits", 15); ("WGPUSType_TextureBindingViewDimension", 16); ("WGPUSType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUSurfaceGetCurrentTextureStatus] (from webgpu.h) *)
module SurfaceGetCurrentTextureStatus = struct
  let c_name = "WGPUSurfaceGetCurrentTextureStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUSurfaceGetCurrentTextureStatus_SuccessOptimal] *)
  let success_optimal : t = 1

  (** [WGPUSurfaceGetCurrentTextureStatus_SuccessSuboptimal] *)
  let success_suboptimal : t = 2

  (** [WGPUSurfaceGetCurrentTextureStatus_Timeout] *)
  let timeout : t = 3

  (** [WGPUSurfaceGetCurrentTextureStatus_Outdated] *)
  let outdated : t = 4

  (** [WGPUSurfaceGetCurrentTextureStatus_Lost] *)
  let lost : t = 5

  (** [WGPUSurfaceGetCurrentTextureStatus_Error] *)
  let error : t = 6

  (** [WGPUSurfaceGetCurrentTextureStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUSurfaceGetCurrentTextureStatus_SuccessOptimal", 1); ("WGPUSurfaceGetCurrentTextureStatus_SuccessSuboptimal", 2); ("WGPUSurfaceGetCurrentTextureStatus_Timeout", 3); ("WGPUSurfaceGetCurrentTextureStatus_Outdated", 4); ("WGPUSurfaceGetCurrentTextureStatus_Lost", 5); ("WGPUSurfaceGetCurrentTextureStatus_Error", 6); ("WGPUSurfaceGetCurrentTextureStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUTextureAspect] (from webgpu.h) *)
module TextureAspect = struct
  let c_name = "WGPUTextureAspect"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUTextureAspect_Undefined] *)
  let undefined : t = 0

  (** [WGPUTextureAspect_All] *)
  let all : t = 1

  (** [WGPUTextureAspect_StencilOnly] *)
  let stencil_only : t = 2

  (** [WGPUTextureAspect_DepthOnly] *)
  let depth_only : t = 3

  (** [WGPUTextureAspect_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUTextureAspect_Undefined", 0); ("WGPUTextureAspect_All", 1); ("WGPUTextureAspect_StencilOnly", 2); ("WGPUTextureAspect_DepthOnly", 3); ("WGPUTextureAspect_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUTextureDimension] (from webgpu.h) *)
module TextureDimension = struct
  let c_name = "WGPUTextureDimension"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUTextureDimension_Undefined] *)
  let undefined : t = 0

  (** [WGPUTextureDimension_1D] *)
  let v1_d : t = 1

  (** [WGPUTextureDimension_2D] *)
  let v2_d : t = 2

  (** [WGPUTextureDimension_3D] *)
  let v3_d : t = 3

  (** [WGPUTextureDimension_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUTextureDimension_Undefined", 0); ("WGPUTextureDimension_1D", 1); ("WGPUTextureDimension_2D", 2); ("WGPUTextureDimension_3D", 3); ("WGPUTextureDimension_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUTextureFormat] (from webgpu.h) *)
module TextureFormat = struct
  let c_name = "WGPUTextureFormat"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUTextureFormat_Undefined] *)
  let undefined : t = 0

  (** [WGPUTextureFormat_R8Unorm] *)
  let r8_unorm : t = 1

  (** [WGPUTextureFormat_R8Snorm] *)
  let r8_snorm : t = 2

  (** [WGPUTextureFormat_R8Uint] *)
  let r8_uint : t = 3

  (** [WGPUTextureFormat_R8Sint] *)
  let r8_sint : t = 4

  (** [WGPUTextureFormat_R16Unorm] *)
  let r16_unorm : t = 5

  (** [WGPUTextureFormat_R16Snorm] *)
  let r16_snorm : t = 6

  (** [WGPUTextureFormat_R16Uint] *)
  let r16_uint : t = 7

  (** [WGPUTextureFormat_R16Sint] *)
  let r16_sint : t = 8

  (** [WGPUTextureFormat_R16Float] *)
  let r16_float : t = 9

  (** [WGPUTextureFormat_RG8Unorm] *)
  let rg8_unorm : t = 10

  (** [WGPUTextureFormat_RG8Snorm] *)
  let rg8_snorm : t = 11

  (** [WGPUTextureFormat_RG8Uint] *)
  let rg8_uint : t = 12

  (** [WGPUTextureFormat_RG8Sint] *)
  let rg8_sint : t = 13

  (** [WGPUTextureFormat_R32Float] *)
  let r32_float : t = 14

  (** [WGPUTextureFormat_R32Uint] *)
  let r32_uint : t = 15

  (** [WGPUTextureFormat_R32Sint] *)
  let r32_sint : t = 16

  (** [WGPUTextureFormat_RG16Unorm] *)
  let rg16_unorm : t = 17

  (** [WGPUTextureFormat_RG16Snorm] *)
  let rg16_snorm : t = 18

  (** [WGPUTextureFormat_RG16Uint] *)
  let rg16_uint : t = 19

  (** [WGPUTextureFormat_RG16Sint] *)
  let rg16_sint : t = 20

  (** [WGPUTextureFormat_RG16Float] *)
  let rg16_float : t = 21

  (** [WGPUTextureFormat_RGBA8Unorm] *)
  let rgba8_unorm : t = 22

  (** [WGPUTextureFormat_RGBA8UnormSrgb] *)
  let rgba8_unorm_srgb : t = 23

  (** [WGPUTextureFormat_RGBA8Snorm] *)
  let rgba8_snorm : t = 24

  (** [WGPUTextureFormat_RGBA8Uint] *)
  let rgba8_uint : t = 25

  (** [WGPUTextureFormat_RGBA8Sint] *)
  let rgba8_sint : t = 26

  (** [WGPUTextureFormat_BGRA8Unorm] *)
  let bgra8_unorm : t = 27

  (** [WGPUTextureFormat_BGRA8UnormSrgb] *)
  let bgra8_unorm_srgb : t = 28

  (** [WGPUTextureFormat_RGB10A2Uint] *)
  let rgb10_a2_uint : t = 29

  (** [WGPUTextureFormat_RGB10A2Unorm] *)
  let rgb10_a2_unorm : t = 30

  (** [WGPUTextureFormat_RG11B10Ufloat] *)
  let rg11_b10_ufloat : t = 31

  (** [WGPUTextureFormat_RGB9E5Ufloat] *)
  let rgb9_e5_ufloat : t = 32

  (** [WGPUTextureFormat_RG32Float] *)
  let rg32_float : t = 33

  (** [WGPUTextureFormat_RG32Uint] *)
  let rg32_uint : t = 34

  (** [WGPUTextureFormat_RG32Sint] *)
  let rg32_sint : t = 35

  (** [WGPUTextureFormat_RGBA16Unorm] *)
  let rgba16_unorm : t = 36

  (** [WGPUTextureFormat_RGBA16Snorm] *)
  let rgba16_snorm : t = 37

  (** [WGPUTextureFormat_RGBA16Uint] *)
  let rgba16_uint : t = 38

  (** [WGPUTextureFormat_RGBA16Sint] *)
  let rgba16_sint : t = 39

  (** [WGPUTextureFormat_RGBA16Float] *)
  let rgba16_float : t = 40

  (** [WGPUTextureFormat_RGBA32Float] *)
  let rgba32_float : t = 41

  (** [WGPUTextureFormat_RGBA32Uint] *)
  let rgba32_uint : t = 42

  (** [WGPUTextureFormat_RGBA32Sint] *)
  let rgba32_sint : t = 43

  (** [WGPUTextureFormat_Stencil8] *)
  let stencil8 : t = 44

  (** [WGPUTextureFormat_Depth16Unorm] *)
  let depth16_unorm : t = 45

  (** [WGPUTextureFormat_Depth24Plus] *)
  let depth24_plus : t = 46

  (** [WGPUTextureFormat_Depth24PlusStencil8] *)
  let depth24_plus_stencil8 : t = 47

  (** [WGPUTextureFormat_Depth32Float] *)
  let depth32_float : t = 48

  (** [WGPUTextureFormat_Depth32FloatStencil8] *)
  let depth32_float_stencil8 : t = 49

  (** [WGPUTextureFormat_BC1RGBAUnorm] *)
  let bc1_rgba_unorm : t = 50

  (** [WGPUTextureFormat_BC1RGBAUnormSrgb] *)
  let bc1_rgba_unorm_srgb : t = 51

  (** [WGPUTextureFormat_BC2RGBAUnorm] *)
  let bc2_rgba_unorm : t = 52

  (** [WGPUTextureFormat_BC2RGBAUnormSrgb] *)
  let bc2_rgba_unorm_srgb : t = 53

  (** [WGPUTextureFormat_BC3RGBAUnorm] *)
  let bc3_rgba_unorm : t = 54

  (** [WGPUTextureFormat_BC3RGBAUnormSrgb] *)
  let bc3_rgba_unorm_srgb : t = 55

  (** [WGPUTextureFormat_BC4RUnorm] *)
  let bc4_r_unorm : t = 56

  (** [WGPUTextureFormat_BC4RSnorm] *)
  let bc4_r_snorm : t = 57

  (** [WGPUTextureFormat_BC5RGUnorm] *)
  let bc5_rg_unorm : t = 58

  (** [WGPUTextureFormat_BC5RGSnorm] *)
  let bc5_rg_snorm : t = 59

  (** [WGPUTextureFormat_BC6HRGBUfloat] *)
  let bc6_hrgb_ufloat : t = 60

  (** [WGPUTextureFormat_BC6HRGBFloat] *)
  let bc6_hrgb_float : t = 61

  (** [WGPUTextureFormat_BC7RGBAUnorm] *)
  let bc7_rgba_unorm : t = 62

  (** [WGPUTextureFormat_BC7RGBAUnormSrgb] *)
  let bc7_rgba_unorm_srgb : t = 63

  (** [WGPUTextureFormat_ETC2RGB8Unorm] *)
  let etc2_rgb8_unorm : t = 64

  (** [WGPUTextureFormat_ETC2RGB8UnormSrgb] *)
  let etc2_rgb8_unorm_srgb : t = 65

  (** [WGPUTextureFormat_ETC2RGB8A1Unorm] *)
  let etc2_rgb8_a1_unorm : t = 66

  (** [WGPUTextureFormat_ETC2RGB8A1UnormSrgb] *)
  let etc2_rgb8_a1_unorm_srgb : t = 67

  (** [WGPUTextureFormat_ETC2RGBA8Unorm] *)
  let etc2_rgba8_unorm : t = 68

  (** [WGPUTextureFormat_ETC2RGBA8UnormSrgb] *)
  let etc2_rgba8_unorm_srgb : t = 69

  (** [WGPUTextureFormat_EACR11Unorm] *)
  let eacr11_unorm : t = 70

  (** [WGPUTextureFormat_EACR11Snorm] *)
  let eacr11_snorm : t = 71

  (** [WGPUTextureFormat_EACRG11Unorm] *)
  let eacrg11_unorm : t = 72

  (** [WGPUTextureFormat_EACRG11Snorm] *)
  let eacrg11_snorm : t = 73

  (** [WGPUTextureFormat_ASTC4x4Unorm] *)
  let astc4x4_unorm : t = 74

  (** [WGPUTextureFormat_ASTC4x4UnormSrgb] *)
  let astc4x4_unorm_srgb : t = 75

  (** [WGPUTextureFormat_ASTC5x4Unorm] *)
  let astc5x4_unorm : t = 76

  (** [WGPUTextureFormat_ASTC5x4UnormSrgb] *)
  let astc5x4_unorm_srgb : t = 77

  (** [WGPUTextureFormat_ASTC5x5Unorm] *)
  let astc5x5_unorm : t = 78

  (** [WGPUTextureFormat_ASTC5x5UnormSrgb] *)
  let astc5x5_unorm_srgb : t = 79

  (** [WGPUTextureFormat_ASTC6x5Unorm] *)
  let astc6x5_unorm : t = 80

  (** [WGPUTextureFormat_ASTC6x5UnormSrgb] *)
  let astc6x5_unorm_srgb : t = 81

  (** [WGPUTextureFormat_ASTC6x6Unorm] *)
  let astc6x6_unorm : t = 82

  (** [WGPUTextureFormat_ASTC6x6UnormSrgb] *)
  let astc6x6_unorm_srgb : t = 83

  (** [WGPUTextureFormat_ASTC8x5Unorm] *)
  let astc8x5_unorm : t = 84

  (** [WGPUTextureFormat_ASTC8x5UnormSrgb] *)
  let astc8x5_unorm_srgb : t = 85

  (** [WGPUTextureFormat_ASTC8x6Unorm] *)
  let astc8x6_unorm : t = 86

  (** [WGPUTextureFormat_ASTC8x6UnormSrgb] *)
  let astc8x6_unorm_srgb : t = 87

  (** [WGPUTextureFormat_ASTC8x8Unorm] *)
  let astc8x8_unorm : t = 88

  (** [WGPUTextureFormat_ASTC8x8UnormSrgb] *)
  let astc8x8_unorm_srgb : t = 89

  (** [WGPUTextureFormat_ASTC10x5Unorm] *)
  let astc10x5_unorm : t = 90

  (** [WGPUTextureFormat_ASTC10x5UnormSrgb] *)
  let astc10x5_unorm_srgb : t = 91

  (** [WGPUTextureFormat_ASTC10x6Unorm] *)
  let astc10x6_unorm : t = 92

  (** [WGPUTextureFormat_ASTC10x6UnormSrgb] *)
  let astc10x6_unorm_srgb : t = 93

  (** [WGPUTextureFormat_ASTC10x8Unorm] *)
  let astc10x8_unorm : t = 94

  (** [WGPUTextureFormat_ASTC10x8UnormSrgb] *)
  let astc10x8_unorm_srgb : t = 95

  (** [WGPUTextureFormat_ASTC10x10Unorm] *)
  let astc10x10_unorm : t = 96

  (** [WGPUTextureFormat_ASTC10x10UnormSrgb] *)
  let astc10x10_unorm_srgb : t = 97

  (** [WGPUTextureFormat_ASTC12x10Unorm] *)
  let astc12x10_unorm : t = 98

  (** [WGPUTextureFormat_ASTC12x10UnormSrgb] *)
  let astc12x10_unorm_srgb : t = 99

  (** [WGPUTextureFormat_ASTC12x12Unorm] *)
  let astc12x12_unorm : t = 100

  (** [WGPUTextureFormat_ASTC12x12UnormSrgb] *)
  let astc12x12_unorm_srgb : t = 101

  (** [WGPUTextureFormat_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUTextureFormat_Undefined", 0); ("WGPUTextureFormat_R8Unorm", 1); ("WGPUTextureFormat_R8Snorm", 2); ("WGPUTextureFormat_R8Uint", 3); ("WGPUTextureFormat_R8Sint", 4); ("WGPUTextureFormat_R16Unorm", 5); ("WGPUTextureFormat_R16Snorm", 6); ("WGPUTextureFormat_R16Uint", 7); ("WGPUTextureFormat_R16Sint", 8); ("WGPUTextureFormat_R16Float", 9); ("WGPUTextureFormat_RG8Unorm", 10); ("WGPUTextureFormat_RG8Snorm", 11); ("WGPUTextureFormat_RG8Uint", 12); ("WGPUTextureFormat_RG8Sint", 13); ("WGPUTextureFormat_R32Float", 14); ("WGPUTextureFormat_R32Uint", 15); ("WGPUTextureFormat_R32Sint", 16); ("WGPUTextureFormat_RG16Unorm", 17); ("WGPUTextureFormat_RG16Snorm", 18); ("WGPUTextureFormat_RG16Uint", 19); ("WGPUTextureFormat_RG16Sint", 20); ("WGPUTextureFormat_RG16Float", 21); ("WGPUTextureFormat_RGBA8Unorm", 22); ("WGPUTextureFormat_RGBA8UnormSrgb", 23); ("WGPUTextureFormat_RGBA8Snorm", 24); ("WGPUTextureFormat_RGBA8Uint", 25); ("WGPUTextureFormat_RGBA8Sint", 26); ("WGPUTextureFormat_BGRA8Unorm", 27); ("WGPUTextureFormat_BGRA8UnormSrgb", 28); ("WGPUTextureFormat_RGB10A2Uint", 29); ("WGPUTextureFormat_RGB10A2Unorm", 30); ("WGPUTextureFormat_RG11B10Ufloat", 31); ("WGPUTextureFormat_RGB9E5Ufloat", 32); ("WGPUTextureFormat_RG32Float", 33); ("WGPUTextureFormat_RG32Uint", 34); ("WGPUTextureFormat_RG32Sint", 35); ("WGPUTextureFormat_RGBA16Unorm", 36); ("WGPUTextureFormat_RGBA16Snorm", 37); ("WGPUTextureFormat_RGBA16Uint", 38); ("WGPUTextureFormat_RGBA16Sint", 39); ("WGPUTextureFormat_RGBA16Float", 40); ("WGPUTextureFormat_RGBA32Float", 41); ("WGPUTextureFormat_RGBA32Uint", 42); ("WGPUTextureFormat_RGBA32Sint", 43); ("WGPUTextureFormat_Stencil8", 44); ("WGPUTextureFormat_Depth16Unorm", 45); ("WGPUTextureFormat_Depth24Plus", 46); ("WGPUTextureFormat_Depth24PlusStencil8", 47); ("WGPUTextureFormat_Depth32Float", 48); ("WGPUTextureFormat_Depth32FloatStencil8", 49); ("WGPUTextureFormat_BC1RGBAUnorm", 50); ("WGPUTextureFormat_BC1RGBAUnormSrgb", 51); ("WGPUTextureFormat_BC2RGBAUnorm", 52); ("WGPUTextureFormat_BC2RGBAUnormSrgb", 53); ("WGPUTextureFormat_BC3RGBAUnorm", 54); ("WGPUTextureFormat_BC3RGBAUnormSrgb", 55); ("WGPUTextureFormat_BC4RUnorm", 56); ("WGPUTextureFormat_BC4RSnorm", 57); ("WGPUTextureFormat_BC5RGUnorm", 58); ("WGPUTextureFormat_BC5RGSnorm", 59); ("WGPUTextureFormat_BC6HRGBUfloat", 60); ("WGPUTextureFormat_BC6HRGBFloat", 61); ("WGPUTextureFormat_BC7RGBAUnorm", 62); ("WGPUTextureFormat_BC7RGBAUnormSrgb", 63); ("WGPUTextureFormat_ETC2RGB8Unorm", 64); ("WGPUTextureFormat_ETC2RGB8UnormSrgb", 65); ("WGPUTextureFormat_ETC2RGB8A1Unorm", 66); ("WGPUTextureFormat_ETC2RGB8A1UnormSrgb", 67); ("WGPUTextureFormat_ETC2RGBA8Unorm", 68); ("WGPUTextureFormat_ETC2RGBA8UnormSrgb", 69); ("WGPUTextureFormat_EACR11Unorm", 70); ("WGPUTextureFormat_EACR11Snorm", 71); ("WGPUTextureFormat_EACRG11Unorm", 72); ("WGPUTextureFormat_EACRG11Snorm", 73); ("WGPUTextureFormat_ASTC4x4Unorm", 74); ("WGPUTextureFormat_ASTC4x4UnormSrgb", 75); ("WGPUTextureFormat_ASTC5x4Unorm", 76); ("WGPUTextureFormat_ASTC5x4UnormSrgb", 77); ("WGPUTextureFormat_ASTC5x5Unorm", 78); ("WGPUTextureFormat_ASTC5x5UnormSrgb", 79); ("WGPUTextureFormat_ASTC6x5Unorm", 80); ("WGPUTextureFormat_ASTC6x5UnormSrgb", 81); ("WGPUTextureFormat_ASTC6x6Unorm", 82); ("WGPUTextureFormat_ASTC6x6UnormSrgb", 83); ("WGPUTextureFormat_ASTC8x5Unorm", 84); ("WGPUTextureFormat_ASTC8x5UnormSrgb", 85); ("WGPUTextureFormat_ASTC8x6Unorm", 86); ("WGPUTextureFormat_ASTC8x6UnormSrgb", 87); ("WGPUTextureFormat_ASTC8x8Unorm", 88); ("WGPUTextureFormat_ASTC8x8UnormSrgb", 89); ("WGPUTextureFormat_ASTC10x5Unorm", 90); ("WGPUTextureFormat_ASTC10x5UnormSrgb", 91); ("WGPUTextureFormat_ASTC10x6Unorm", 92); ("WGPUTextureFormat_ASTC10x6UnormSrgb", 93); ("WGPUTextureFormat_ASTC10x8Unorm", 94); ("WGPUTextureFormat_ASTC10x8UnormSrgb", 95); ("WGPUTextureFormat_ASTC10x10Unorm", 96); ("WGPUTextureFormat_ASTC10x10UnormSrgb", 97); ("WGPUTextureFormat_ASTC12x10Unorm", 98); ("WGPUTextureFormat_ASTC12x10UnormSrgb", 99); ("WGPUTextureFormat_ASTC12x12Unorm", 100); ("WGPUTextureFormat_ASTC12x12UnormSrgb", 101); ("WGPUTextureFormat_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUTextureSampleType] (from webgpu.h) *)
module TextureSampleType = struct
  let c_name = "WGPUTextureSampleType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUTextureSampleType_BindingNotUsed] *)
  let binding_not_used : t = 0

  (** [WGPUTextureSampleType_Undefined] *)
  let undefined : t = 1

  (** [WGPUTextureSampleType_Float] *)
  let float : t = 2

  (** [WGPUTextureSampleType_UnfilterableFloat] *)
  let unfilterable_float : t = 3

  (** [WGPUTextureSampleType_Depth] *)
  let depth : t = 4

  (** [WGPUTextureSampleType_Sint] *)
  let sint : t = 5

  (** [WGPUTextureSampleType_Uint] *)
  let uint : t = 6

  (** [WGPUTextureSampleType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUTextureSampleType_BindingNotUsed", 0); ("WGPUTextureSampleType_Undefined", 1); ("WGPUTextureSampleType_Float", 2); ("WGPUTextureSampleType_UnfilterableFloat", 3); ("WGPUTextureSampleType_Depth", 4); ("WGPUTextureSampleType_Sint", 5); ("WGPUTextureSampleType_Uint", 6); ("WGPUTextureSampleType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUTextureViewDimension] (from webgpu.h) *)
module TextureViewDimension = struct
  let c_name = "WGPUTextureViewDimension"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUTextureViewDimension_Undefined] *)
  let undefined : t = 0

  (** [WGPUTextureViewDimension_1D] *)
  let v1_d : t = 1

  (** [WGPUTextureViewDimension_2D] *)
  let v2_d : t = 2

  (** [WGPUTextureViewDimension_2DArray] *)
  let v2_d_array : t = 3

  (** [WGPUTextureViewDimension_Cube] *)
  let cube : t = 4

  (** [WGPUTextureViewDimension_CubeArray] *)
  let cube_array : t = 5

  (** [WGPUTextureViewDimension_3D] *)
  let v3_d : t = 6

  (** [WGPUTextureViewDimension_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUTextureViewDimension_Undefined", 0); ("WGPUTextureViewDimension_1D", 1); ("WGPUTextureViewDimension_2D", 2); ("WGPUTextureViewDimension_2DArray", 3); ("WGPUTextureViewDimension_Cube", 4); ("WGPUTextureViewDimension_CubeArray", 5); ("WGPUTextureViewDimension_3D", 6); ("WGPUTextureViewDimension_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUToneMappingMode] (from webgpu.h) *)
module ToneMappingMode = struct
  let c_name = "WGPUToneMappingMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUToneMappingMode_Standard] *)
  let standard : t = 1

  (** [WGPUToneMappingMode_Extended] *)
  let extended : t = 2

  (** [WGPUToneMappingMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUToneMappingMode_Standard", 1); ("WGPUToneMappingMode_Extended", 2); ("WGPUToneMappingMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUVertexFormat] (from webgpu.h) *)
module VertexFormat = struct
  let c_name = "WGPUVertexFormat"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUVertexFormat_Uint8] *)
  let uint8 : t = 1

  (** [WGPUVertexFormat_Uint8x2] *)
  let uint8x2 : t = 2

  (** [WGPUVertexFormat_Uint8x4] *)
  let uint8x4 : t = 3

  (** [WGPUVertexFormat_Sint8] *)
  let sint8 : t = 4

  (** [WGPUVertexFormat_Sint8x2] *)
  let sint8x2 : t = 5

  (** [WGPUVertexFormat_Sint8x4] *)
  let sint8x4 : t = 6

  (** [WGPUVertexFormat_Unorm8] *)
  let unorm8 : t = 7

  (** [WGPUVertexFormat_Unorm8x2] *)
  let unorm8x2 : t = 8

  (** [WGPUVertexFormat_Unorm8x4] *)
  let unorm8x4 : t = 9

  (** [WGPUVertexFormat_Snorm8] *)
  let snorm8 : t = 10

  (** [WGPUVertexFormat_Snorm8x2] *)
  let snorm8x2 : t = 11

  (** [WGPUVertexFormat_Snorm8x4] *)
  let snorm8x4 : t = 12

  (** [WGPUVertexFormat_Uint16] *)
  let uint16 : t = 13

  (** [WGPUVertexFormat_Uint16x2] *)
  let uint16x2 : t = 14

  (** [WGPUVertexFormat_Uint16x4] *)
  let uint16x4 : t = 15

  (** [WGPUVertexFormat_Sint16] *)
  let sint16 : t = 16

  (** [WGPUVertexFormat_Sint16x2] *)
  let sint16x2 : t = 17

  (** [WGPUVertexFormat_Sint16x4] *)
  let sint16x4 : t = 18

  (** [WGPUVertexFormat_Unorm16] *)
  let unorm16 : t = 19

  (** [WGPUVertexFormat_Unorm16x2] *)
  let unorm16x2 : t = 20

  (** [WGPUVertexFormat_Unorm16x4] *)
  let unorm16x4 : t = 21

  (** [WGPUVertexFormat_Snorm16] *)
  let snorm16 : t = 22

  (** [WGPUVertexFormat_Snorm16x2] *)
  let snorm16x2 : t = 23

  (** [WGPUVertexFormat_Snorm16x4] *)
  let snorm16x4 : t = 24

  (** [WGPUVertexFormat_Float16] *)
  let float16 : t = 25

  (** [WGPUVertexFormat_Float16x2] *)
  let float16x2 : t = 26

  (** [WGPUVertexFormat_Float16x4] *)
  let float16x4 : t = 27

  (** [WGPUVertexFormat_Float32] *)
  let float32 : t = 28

  (** [WGPUVertexFormat_Float32x2] *)
  let float32x2 : t = 29

  (** [WGPUVertexFormat_Float32x3] *)
  let float32x3 : t = 30

  (** [WGPUVertexFormat_Float32x4] *)
  let float32x4 : t = 31

  (** [WGPUVertexFormat_Uint32] *)
  let uint32 : t = 32

  (** [WGPUVertexFormat_Uint32x2] *)
  let uint32x2 : t = 33

  (** [WGPUVertexFormat_Uint32x3] *)
  let uint32x3 : t = 34

  (** [WGPUVertexFormat_Uint32x4] *)
  let uint32x4 : t = 35

  (** [WGPUVertexFormat_Sint32] *)
  let sint32 : t = 36

  (** [WGPUVertexFormat_Sint32x2] *)
  let sint32x2 : t = 37

  (** [WGPUVertexFormat_Sint32x3] *)
  let sint32x3 : t = 38

  (** [WGPUVertexFormat_Sint32x4] *)
  let sint32x4 : t = 39

  (** [WGPUVertexFormat_Unorm10_10_10_2] *)
  let unorm10_10_10_2 : t = 40

  (** [WGPUVertexFormat_Unorm8x4BGRA] *)
  let unorm8x4_bgra : t = 41

  (** [WGPUVertexFormat_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUVertexFormat_Uint8", 1); ("WGPUVertexFormat_Uint8x2", 2); ("WGPUVertexFormat_Uint8x4", 3); ("WGPUVertexFormat_Sint8", 4); ("WGPUVertexFormat_Sint8x2", 5); ("WGPUVertexFormat_Sint8x4", 6); ("WGPUVertexFormat_Unorm8", 7); ("WGPUVertexFormat_Unorm8x2", 8); ("WGPUVertexFormat_Unorm8x4", 9); ("WGPUVertexFormat_Snorm8", 10); ("WGPUVertexFormat_Snorm8x2", 11); ("WGPUVertexFormat_Snorm8x4", 12); ("WGPUVertexFormat_Uint16", 13); ("WGPUVertexFormat_Uint16x2", 14); ("WGPUVertexFormat_Uint16x4", 15); ("WGPUVertexFormat_Sint16", 16); ("WGPUVertexFormat_Sint16x2", 17); ("WGPUVertexFormat_Sint16x4", 18); ("WGPUVertexFormat_Unorm16", 19); ("WGPUVertexFormat_Unorm16x2", 20); ("WGPUVertexFormat_Unorm16x4", 21); ("WGPUVertexFormat_Snorm16", 22); ("WGPUVertexFormat_Snorm16x2", 23); ("WGPUVertexFormat_Snorm16x4", 24); ("WGPUVertexFormat_Float16", 25); ("WGPUVertexFormat_Float16x2", 26); ("WGPUVertexFormat_Float16x4", 27); ("WGPUVertexFormat_Float32", 28); ("WGPUVertexFormat_Float32x2", 29); ("WGPUVertexFormat_Float32x3", 30); ("WGPUVertexFormat_Float32x4", 31); ("WGPUVertexFormat_Uint32", 32); ("WGPUVertexFormat_Uint32x2", 33); ("WGPUVertexFormat_Uint32x3", 34); ("WGPUVertexFormat_Uint32x4", 35); ("WGPUVertexFormat_Sint32", 36); ("WGPUVertexFormat_Sint32x2", 37); ("WGPUVertexFormat_Sint32x3", 38); ("WGPUVertexFormat_Sint32x4", 39); ("WGPUVertexFormat_Unorm10_10_10_2", 40); ("WGPUVertexFormat_Unorm8x4BGRA", 41); ("WGPUVertexFormat_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUVertexStepMode] (from webgpu.h) *)
module VertexStepMode = struct
  let c_name = "WGPUVertexStepMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUVertexStepMode_Undefined] *)
  let undefined : t = 0

  (** [WGPUVertexStepMode_Vertex] *)
  let vertex : t = 1

  (** [WGPUVertexStepMode_Instance] *)
  let instance : t = 2

  (** [WGPUVertexStepMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUVertexStepMode_Undefined", 0); ("WGPUVertexStepMode_Vertex", 1); ("WGPUVertexStepMode_Instance", 2); ("WGPUVertexStepMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUWaitStatus] (from webgpu.h) *)
module WaitStatus = struct
  let c_name = "WGPUWaitStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUWaitStatus_Success] *)
  let success : t = 1

  (** [WGPUWaitStatus_TimedOut] *)
  let timed_out : t = 2

  (** [WGPUWaitStatus_Error] *)
  let error : t = 3

  (** [WGPUWaitStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUWaitStatus_Success", 1); ("WGPUWaitStatus_TimedOut", 2); ("WGPUWaitStatus_Error", 3); ("WGPUWaitStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUWGSLLanguageFeatureName] (from webgpu.h) *)
module WGSLLanguageFeatureName = struct
  let c_name = "WGPUWGSLLanguageFeatureName"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUWGSLLanguageFeatureName_ReadonlyAndReadwriteStorageTextures] *)
  let readonly_and_readwrite_storage_textures : t = 1

  (** [WGPUWGSLLanguageFeatureName_Packed4x8IntegerDotProduct] *)
  let packed4x8_integer_dot_product : t = 2

  (** [WGPUWGSLLanguageFeatureName_UnrestrictedPointerParameters] *)
  let unrestricted_pointer_parameters : t = 3

  (** [WGPUWGSLLanguageFeatureName_PointerCompositeAccess] *)
  let pointer_composite_access : t = 4

  (** [WGPUWGSLLanguageFeatureName_UniformBufferStandardLayout] *)
  let uniform_buffer_standard_layout : t = 5

  (** [WGPUWGSLLanguageFeatureName_SubgroupId] *)
  let subgroup_id : t = 6

  (** [WGPUWGSLLanguageFeatureName_TextureAndSamplerLet] *)
  let texture_and_sampler_let : t = 7

  (** [WGPUWGSLLanguageFeatureName_SubgroupUniformity] *)
  let subgroup_uniformity : t = 8

  (** [WGPUWGSLLanguageFeatureName_TextureFormatsTier1] *)
  let texture_formats_tier1 : t = 9

  (** [WGPUWGSLLanguageFeatureName_LinearIndexing] *)
  let linear_indexing : t = 10

  (** [WGPUWGSLLanguageFeatureName_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUWGSLLanguageFeatureName_ReadonlyAndReadwriteStorageTextures", 1); ("WGPUWGSLLanguageFeatureName_Packed4x8IntegerDotProduct", 2); ("WGPUWGSLLanguageFeatureName_UnrestrictedPointerParameters", 3); ("WGPUWGSLLanguageFeatureName_PointerCompositeAccess", 4); ("WGPUWGSLLanguageFeatureName_UniformBufferStandardLayout", 5); ("WGPUWGSLLanguageFeatureName_SubgroupId", 6); ("WGPUWGSLLanguageFeatureName_TextureAndSamplerLet", 7); ("WGPUWGSLLanguageFeatureName_SubgroupUniformity", 8); ("WGPUWGSLLanguageFeatureName_TextureFormatsTier1", 9); ("WGPUWGSLLanguageFeatureName_LinearIndexing", 10); ("WGPUWGSLLanguageFeatureName_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUNativeSType] (from wgpu.h) *)
module NativeSType = struct
  let c_name = "WGPUNativeSType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUSType_DeviceExtras] *)
  let device_extras : t = 196609

  (** [WGPUSType_NativeLimits] *)
  let native_limits : t = 196610

  (** [WGPUSType_ShaderSourceGLSL] *)
  let shader_source_glsl : t = 196611

  (** [WGPUSType_InstanceExtras] *)
  let instance_extras : t = 196612

  (** [WGPUSType_BindGroupEntryExtras] *)
  let bind_group_entry_extras : t = 196613

  (** [WGPUSType_BindGroupLayoutEntryExtras] *)
  let bind_group_layout_entry_extras : t = 196614

  (** [WGPUSType_QuerySetDescriptorExtras] *)
  let query_set_descriptor_extras : t = 196615

  (** [WGPUSType_SurfaceConfigurationExtras] *)
  let surface_configuration_extras : t = 196616

  (** [WGPUSType_SurfaceSourceSwapChainPanel] *)
  let surface_source_swap_chain_panel : t = 196617

  (** [WGPUSType_PrimitiveStateExtras] *)
  let primitive_state_extras : t = 196618

  (** [WGPUSType_SamplerDescriptorExtras] *)
  let sampler_descriptor_extras : t = 196619

  (** [WGPUNativeSType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUSType_DeviceExtras", 196609); ("WGPUSType_NativeLimits", 196610); ("WGPUSType_ShaderSourceGLSL", 196611); ("WGPUSType_InstanceExtras", 196612); ("WGPUSType_BindGroupEntryExtras", 196613); ("WGPUSType_BindGroupLayoutEntryExtras", 196614); ("WGPUSType_QuerySetDescriptorExtras", 196615); ("WGPUSType_SurfaceConfigurationExtras", 196616); ("WGPUSType_SurfaceSourceSwapChainPanel", 196617); ("WGPUSType_PrimitiveStateExtras", 196618); ("WGPUSType_SamplerDescriptorExtras", 196619); ("WGPUNativeSType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUNativeSurfaceGetCurrentTextureStatus] (from wgpu.h) *)
module NativeSurfaceGetCurrentTextureStatus = struct
  let c_name = "WGPUNativeSurfaceGetCurrentTextureStatus"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUSurfaceGetCurrentTextureStatus_Occluded] *)
  let occluded : t = 196609

  (** [WGPUNativeSurfaceGetCurrentTextureStatus_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUSurfaceGetCurrentTextureStatus_Occluded", 196609); ("WGPUNativeSurfaceGetCurrentTextureStatus_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUNativeFeature] (from wgpu.h) *)
module NativeFeature = struct
  let c_name = "WGPUNativeFeature"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUNativeFeature_Immediates] *)
  let immediates : t = 196609

  (** [WGPUNativeFeature_TextureAdapterSpecificFormatFeatures] *)
  let texture_adapter_specific_format_features : t = 196610

  (** [WGPUNativeFeature_MultiDrawIndirectCount] *)
  let multi_draw_indirect_count : t = 196612

  (** [WGPUNativeFeature_VertexWritableStorage] *)
  let vertex_writable_storage : t = 196613

  (** [WGPUNativeFeature_TextureBindingArray] *)
  let texture_binding_array : t = 196614

  (** [WGPUNativeFeature_SampledTextureAndStorageBufferArrayNonUniformIndexing] *)
  let sampled_texture_and_storage_buffer_array_non_uniform_indexing : t = 196615

  (** [WGPUNativeFeature_PipelineStatisticsQuery] *)
  let pipeline_statistics_query : t = 196616

  (** [WGPUNativeFeature_StorageResourceBindingArray] *)
  let storage_resource_binding_array : t = 196617

  (** [WGPUNativeFeature_PartiallyBoundBindingArray] *)
  let partially_bound_binding_array : t = 196618

  (** [WGPUNativeFeature_TextureFormat16bitNorm] *)
  let texture_format16bit_norm : t = 196619

  (** [WGPUNativeFeature_TextureCompressionAstcHdr] *)
  let texture_compression_astc_hdr : t = 196620

  (** [WGPUNativeFeature_MappablePrimaryBuffers] *)
  let mappable_primary_buffers : t = 196622

  (** [WGPUNativeFeature_BufferBindingArray] *)
  let buffer_binding_array : t = 196623

  (** [WGPUNativeFeature_StorageTextureArrayNonUniformIndexing] *)
  let storage_texture_array_non_uniform_indexing : t = 196624

  (** [WGPUNativeFeature_AddressModeClampToZero] *)
  let address_mode_clamp_to_zero : t = 196625

  (** [WGPUNativeFeature_AddressModeClampToBorder] *)
  let address_mode_clamp_to_border : t = 196626

  (** [WGPUNativeFeature_PolygonModeLine] *)
  let polygon_mode_line : t = 196627

  (** [WGPUNativeFeature_PolygonModePoint] *)
  let polygon_mode_point : t = 196628

  (** [WGPUNativeFeature_ConservativeRasterization] *)
  let conservative_rasterization : t = 196629

  (** [WGPUNativeFeature_ClearTexture] *)
  let clear_texture : t = 196630

  (** [WGPUNativeFeature_Multiview] *)
  let multiview : t = 196632

  (** [WGPUNativeFeature_VertexAttribute64bit] *)
  let vertex_attribute64bit : t = 196633

  (** [WGPUNativeFeature_TextureFormatNv12] *)
  let texture_format_nv12 : t = 196634

  (** [WGPUNativeFeature_RayQuery] *)
  let ray_query : t = 196636

  (** [WGPUNativeFeature_ShaderF64] *)
  let shader_f64 : t = 196637

  (** [WGPUNativeFeature_ShaderI16] *)
  let shader_i16 : t = 196638

  (** [WGPUNativeFeature_ShaderEarlyDepthTest] *)
  let shader_early_depth_test : t = 196640

  (** [WGPUNativeFeature_Subgroup] *)
  let subgroup : t = 196641

  (** [WGPUNativeFeature_SubgroupVertex] *)
  let subgroup_vertex : t = 196642

  (** [WGPUNativeFeature_SubgroupBarrier] *)
  let subgroup_barrier : t = 196643

  (** [WGPUNativeFeature_TimestampQueryInsideEncoders] *)
  let timestamp_query_inside_encoders : t = 196644

  (** [WGPUNativeFeature_TimestampQueryInsidePasses] *)
  let timestamp_query_inside_passes : t = 196645

  (** [WGPUNativeFeature_ShaderInt64] *)
  let shader_int64 : t = 196646

  (** [WGPUNativeFeature_ShaderFloat32Atomic] *)
  let shader_float32_atomic : t = 196647

  (** [WGPUNativeFeature_TextureAtomic] *)
  let texture_atomic : t = 196648

  (** [WGPUNativeFeature_TextureFormatP010] *)
  let texture_format_p010 : t = 196649

  (** [WGPUNativeFeature_PipelineCache] *)
  let pipeline_cache : t = 196651

  (** [WGPUNativeFeature_ShaderInt64AtomicMinMax] *)
  let shader_int64_atomic_min_max : t = 196652

  (** [WGPUNativeFeature_ShaderInt64AtomicAllOps] *)
  let shader_int64_atomic_all_ops : t = 196653

  (** [WGPUNativeFeature_TextureInt64Atomic] *)
  let texture_int64_atomic : t = 196656

  (** [WGPUNativeFeature_ShaderBarycentrics] *)
  let shader_barycentrics : t = 196663

  (** [WGPUNativeFeature_SelectiveMultiview] *)
  let selective_multiview : t = 196664

  (** [WGPUNativeFeature_MultisampleArray] *)
  let multisample_array : t = 196666

  (** [WGPUNativeFeature_CooperativeMatrix] *)
  let cooperative_matrix : t = 196667

  (** [WGPUNativeFeature_ShaderPerVertex] *)
  let shader_per_vertex : t = 196668

  (** [WGPUNativeFeature_ShaderDrawIndex] *)
  let shader_draw_index : t = 196669

  (** [WGPUNativeFeature_AccelerationStructureBindingArray] *)
  let acceleration_structure_binding_array : t = 196670

  (** [WGPUNativeFeature_MemoryDecorationCoherent] *)
  let memory_decoration_coherent : t = 196671

  (** [WGPUNativeFeature_MemoryDecorationVolatile] *)
  let memory_decoration_volatile : t = 196672

  (** [WGPUNativeFeature_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUNativeFeature_Immediates", 196609); ("WGPUNativeFeature_TextureAdapterSpecificFormatFeatures", 196610); ("WGPUNativeFeature_MultiDrawIndirectCount", 196612); ("WGPUNativeFeature_VertexWritableStorage", 196613); ("WGPUNativeFeature_TextureBindingArray", 196614); ("WGPUNativeFeature_SampledTextureAndStorageBufferArrayNonUniformIndexing", 196615); ("WGPUNativeFeature_PipelineStatisticsQuery", 196616); ("WGPUNativeFeature_StorageResourceBindingArray", 196617); ("WGPUNativeFeature_PartiallyBoundBindingArray", 196618); ("WGPUNativeFeature_TextureFormat16bitNorm", 196619); ("WGPUNativeFeature_TextureCompressionAstcHdr", 196620); ("WGPUNativeFeature_MappablePrimaryBuffers", 196622); ("WGPUNativeFeature_BufferBindingArray", 196623); ("WGPUNativeFeature_StorageTextureArrayNonUniformIndexing", 196624); ("WGPUNativeFeature_AddressModeClampToZero", 196625); ("WGPUNativeFeature_AddressModeClampToBorder", 196626); ("WGPUNativeFeature_PolygonModeLine", 196627); ("WGPUNativeFeature_PolygonModePoint", 196628); ("WGPUNativeFeature_ConservativeRasterization", 196629); ("WGPUNativeFeature_ClearTexture", 196630); ("WGPUNativeFeature_Multiview", 196632); ("WGPUNativeFeature_VertexAttribute64bit", 196633); ("WGPUNativeFeature_TextureFormatNv12", 196634); ("WGPUNativeFeature_RayQuery", 196636); ("WGPUNativeFeature_ShaderF64", 196637); ("WGPUNativeFeature_ShaderI16", 196638); ("WGPUNativeFeature_ShaderEarlyDepthTest", 196640); ("WGPUNativeFeature_Subgroup", 196641); ("WGPUNativeFeature_SubgroupVertex", 196642); ("WGPUNativeFeature_SubgroupBarrier", 196643); ("WGPUNativeFeature_TimestampQueryInsideEncoders", 196644); ("WGPUNativeFeature_TimestampQueryInsidePasses", 196645); ("WGPUNativeFeature_ShaderInt64", 196646); ("WGPUNativeFeature_ShaderFloat32Atomic", 196647); ("WGPUNativeFeature_TextureAtomic", 196648); ("WGPUNativeFeature_TextureFormatP010", 196649); ("WGPUNativeFeature_PipelineCache", 196651); ("WGPUNativeFeature_ShaderInt64AtomicMinMax", 196652); ("WGPUNativeFeature_ShaderInt64AtomicAllOps", 196653); ("WGPUNativeFeature_TextureInt64Atomic", 196656); ("WGPUNativeFeature_ShaderBarycentrics", 196663); ("WGPUNativeFeature_SelectiveMultiview", 196664); ("WGPUNativeFeature_MultisampleArray", 196666); ("WGPUNativeFeature_CooperativeMatrix", 196667); ("WGPUNativeFeature_ShaderPerVertex", 196668); ("WGPUNativeFeature_ShaderDrawIndex", 196669); ("WGPUNativeFeature_AccelerationStructureBindingArray", 196670); ("WGPUNativeFeature_MemoryDecorationCoherent", 196671); ("WGPUNativeFeature_MemoryDecorationVolatile", 196672); ("WGPUNativeFeature_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPULogLevel] (from wgpu.h) *)
module LogLevel = struct
  let c_name = "WGPULogLevel"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPULogLevel_Off] *)
  let off : t = 0

  (** [WGPULogLevel_Error] *)
  let error : t = 1

  (** [WGPULogLevel_Warn] *)
  let warn : t = 2

  (** [WGPULogLevel_Info] *)
  let info : t = 3

  (** [WGPULogLevel_Debug] *)
  let debug : t = 4

  (** [WGPULogLevel_Trace] *)
  let trace : t = 5

  (** [WGPULogLevel_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPULogLevel_Off", 0); ("WGPULogLevel_Error", 1); ("WGPULogLevel_Warn", 2); ("WGPULogLevel_Info", 3); ("WGPULogLevel_Debug", 4); ("WGPULogLevel_Trace", 5); ("WGPULogLevel_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUDx12Compiler] (from wgpu.h) *)
module Dx12Compiler = struct
  let c_name = "WGPUDx12Compiler"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUDx12Compiler_Undefined] *)
  let undefined : t = 0

  (** [WGPUDx12Compiler_Fxc] *)
  let fxc : t = 1

  (** [WGPUDx12Compiler_Dxc] *)
  let dxc : t = 2

  (** [WGPUDx12Compiler_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUDx12Compiler_Undefined", 0); ("WGPUDx12Compiler_Fxc", 1); ("WGPUDx12Compiler_Dxc", 2); ("WGPUDx12Compiler_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUGles3MinorVersion] (from wgpu.h) *)
module Gles3MinorVersion = struct
  let c_name = "WGPUGles3MinorVersion"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUGles3MinorVersion_Automatic] *)
  let automatic : t = 0

  (** [WGPUGles3MinorVersion_Version0] *)
  let version0 : t = 1

  (** [WGPUGles3MinorVersion_Version1] *)
  let version1 : t = 2

  (** [WGPUGles3MinorVersion_Version2] *)
  let version2 : t = 3

  (** [WGPUGles3MinorVersion_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUGles3MinorVersion_Automatic", 0); ("WGPUGles3MinorVersion_Version0", 1); ("WGPUGles3MinorVersion_Version1", 2); ("WGPUGles3MinorVersion_Version2", 3); ("WGPUGles3MinorVersion_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUPipelineStatisticName] (from wgpu.h) *)
module PipelineStatisticName = struct
  let c_name = "WGPUPipelineStatisticName"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUPipelineStatisticName_VertexShaderInvocations] *)
  let vertex_shader_invocations : t = 0

  (** [WGPUPipelineStatisticName_ClipperInvocations] *)
  let clipper_invocations : t = 1

  (** [WGPUPipelineStatisticName_ClipperPrimitivesOut] *)
  let clipper_primitives_out : t = 2

  (** [WGPUPipelineStatisticName_FragmentShaderInvocations] *)
  let fragment_shader_invocations : t = 3

  (** [WGPUPipelineStatisticName_ComputeShaderInvocations] *)
  let compute_shader_invocations : t = 4

  (** [WGPUPipelineStatisticName_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUPipelineStatisticName_VertexShaderInvocations", 0); ("WGPUPipelineStatisticName_ClipperInvocations", 1); ("WGPUPipelineStatisticName_ClipperPrimitivesOut", 2); ("WGPUPipelineStatisticName_FragmentShaderInvocations", 3); ("WGPUPipelineStatisticName_ComputeShaderInvocations", 4); ("WGPUPipelineStatisticName_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUNativeQueryType] (from wgpu.h) *)
module NativeQueryType = struct
  let c_name = "WGPUNativeQueryType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUNativeQueryType_PipelineStatistics] *)
  let pipeline_statistics : t = 196608

  (** [WGPUNativeQueryType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUNativeQueryType_PipelineStatistics", 196608); ("WGPUNativeQueryType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUDxcMaxShaderModel] (from wgpu.h) *)
module DxcMaxShaderModel = struct
  let c_name = "WGPUDxcMaxShaderModel"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUDxcMaxShaderModel_V6_0] *)
  let v6_0 : t = 0

  (** [WGPUDxcMaxShaderModel_V6_1] *)
  let v6_1 : t = 1

  (** [WGPUDxcMaxShaderModel_V6_2] *)
  let v6_2 : t = 2

  (** [WGPUDxcMaxShaderModel_V6_3] *)
  let v6_3 : t = 3

  (** [WGPUDxcMaxShaderModel_V6_4] *)
  let v6_4 : t = 4

  (** [WGPUDxcMaxShaderModel_V6_5] *)
  let v6_5 : t = 5

  (** [WGPUDxcMaxShaderModel_V6_6] *)
  let v6_6 : t = 6

  (** [WGPUDxcMaxShaderModel_V6_7] *)
  let v6_7 : t = 7

  (** [WGPUDxcMaxShaderModel_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUDxcMaxShaderModel_V6_0", 0); ("WGPUDxcMaxShaderModel_V6_1", 1); ("WGPUDxcMaxShaderModel_V6_2", 2); ("WGPUDxcMaxShaderModel_V6_3", 3); ("WGPUDxcMaxShaderModel_V6_4", 4); ("WGPUDxcMaxShaderModel_V6_5", 5); ("WGPUDxcMaxShaderModel_V6_6", 6); ("WGPUDxcMaxShaderModel_V6_7", 7); ("WGPUDxcMaxShaderModel_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUGLFenceBehaviour] (from wgpu.h) *)
module GLFenceBehaviour = struct
  let c_name = "WGPUGLFenceBehaviour"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUGLFenceBehaviour_Normal] *)
  let normal : t = 0

  (** [WGPUGLFenceBehaviour_AutoFinish] *)
  let auto_finish : t = 1

  (** [WGPUGLFenceBehaviour_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUGLFenceBehaviour_Normal", 0); ("WGPUGLFenceBehaviour_AutoFinish", 1); ("WGPUGLFenceBehaviour_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUDx12SwapchainKind] (from wgpu.h) *)
module Dx12SwapchainKind = struct
  let c_name = "WGPUDx12SwapchainKind"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUDx12SwapchainKind_Undefined] *)
  let undefined : t = 0

  (** [WGPUDx12SwapchainKind_DxgiFromHwnd] *)
  let dxgi_from_hwnd : t = 1

  (** [WGPUDx12SwapchainKind_DxgiFromVisual] *)
  let dxgi_from_visual : t = 2

  (** [WGPUDx12SwapchainKind_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUDx12SwapchainKind_Undefined", 0); ("WGPUDx12SwapchainKind_DxgiFromHwnd", 1); ("WGPUDx12SwapchainKind_DxgiFromVisual", 2); ("WGPUDx12SwapchainKind_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUNativeDisplayHandleType] (from wgpu.h) *)
module NativeDisplayHandleType = struct
  let c_name = "WGPUNativeDisplayHandleType"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUNativeDisplayHandleType_None] *)
  let none : t = 0

  (** [WGPUNativeDisplayHandleType_Xlib] *)
  let xlib : t = 1

  (** [WGPUNativeDisplayHandleType_Xcb] *)
  let xcb : t = 2

  (** [WGPUNativeDisplayHandleType_Wayland] *)
  let wayland : t = 3

  (** [WGPUNativeDisplayHandleType_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUNativeDisplayHandleType_None", 0); ("WGPUNativeDisplayHandleType_Xlib", 1); ("WGPUNativeDisplayHandleType_Xcb", 2); ("WGPUNativeDisplayHandleType_Wayland", 3); ("WGPUNativeDisplayHandleType_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUPolygonMode] (from wgpu.h) *)
module PolygonMode = struct
  let c_name = "WGPUPolygonMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUPolygonMode_Fill] *)
  let fill : t = 0

  (** [WGPUPolygonMode_Line] *)
  let line : t = 1

  (** [WGPUPolygonMode_Point] *)
  let point : t = 2

  let values : (string * t) list =
    [ ("WGPUPolygonMode_Fill", 0); ("WGPUPolygonMode_Line", 1); ("WGPUPolygonMode_Point", 2); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUNativeTextureFormat] (from wgpu.h) *)
module NativeTextureFormat = struct
  let c_name = "WGPUNativeTextureFormat"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUNativeTextureFormat_NV12] *)
  let nv12 : t = 196615

  (** [WGPUNativeTextureFormat_P010] *)
  let p010 : t = 196616

  let values : (string * t) list =
    [ ("WGPUNativeTextureFormat_NV12", 196615); ("WGPUNativeTextureFormat_P010", 196616); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUNativeAddressMode] (from wgpu.h) *)
module NativeAddressMode = struct
  let c_name = "WGPUNativeAddressMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUNativeAddressMode_ClampToBorder] *)
  let clamp_to_border : t = 4

  (** [WGPUNativeAddressMode_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUNativeAddressMode_ClampToBorder", 4); ("WGPUNativeAddressMode_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUSamplerBorderColor] (from wgpu.h) *)
module SamplerBorderColor = struct
  let c_name = "WGPUSamplerBorderColor"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt32.to_int ~write:Unsigned.UInt32.of_int Ctypes.uint32_t

  (** [WGPUSamplerBorderColor_Undefined] *)
  let undefined : t = 0

  (** [WGPUSamplerBorderColor_TransparentBlack] *)
  let transparent_black : t = 1

  (** [WGPUSamplerBorderColor_OpaqueBlack] *)
  let opaque_black : t = 2

  (** [WGPUSamplerBorderColor_OpaqueWhite] *)
  let opaque_white : t = 3

  (** [WGPUSamplerBorderColor_Zero] *)
  let zero : t = 4

  (** [WGPUSamplerBorderColor_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUSamplerBorderColor_Undefined", 0); ("WGPUSamplerBorderColor_TransparentBlack", 1); ("WGPUSamplerBorderColor_OpaqueBlack", 2); ("WGPUSamplerBorderColor_OpaqueWhite", 3); ("WGPUSamplerBorderColor_Zero", 4); ("WGPUSamplerBorderColor_Force32", 2147483647); ]

  let to_string (v : t) =
    match List.find_opt (fun (_, x) -> x = v) values with
    | Some (n, _) -> n
    | None -> Printf.sprintf "%s(0x%08x)" c_name v
end

(** [WGPUBufferUsage] -- a bit set over [WGPUFlags] (from webgpu.h) *)
module BufferUsage = struct
  let c_name = "WGPUBufferUsage"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t

  (** [WGPUBufferUsage_None] *)
  let none : t = 0

  (** [WGPUBufferUsage_MapRead] *)
  let map_read : t = 1

  (** [WGPUBufferUsage_MapWrite] *)
  let map_write : t = 2

  (** [WGPUBufferUsage_CopySrc] *)
  let copy_src : t = 4

  (** [WGPUBufferUsage_CopyDst] *)
  let copy_dst : t = 8

  (** [WGPUBufferUsage_Index] *)
  let index : t = 16

  (** [WGPUBufferUsage_Vertex] *)
  let vertex : t = 32

  (** [WGPUBufferUsage_Uniform] *)
  let uniform : t = 64

  (** [WGPUBufferUsage_Storage] *)
  let storage : t = 128

  (** [WGPUBufferUsage_Indirect] *)
  let indirect : t = 256

  (** [WGPUBufferUsage_QueryResolve] *)
  let query_resolve : t = 512

  let values : (string * t) list =
    [ ("WGPUBufferUsage_None", 0); ("WGPUBufferUsage_MapRead", 1); ("WGPUBufferUsage_MapWrite", 2); ("WGPUBufferUsage_CopySrc", 4); ("WGPUBufferUsage_CopyDst", 8); ("WGPUBufferUsage_Index", 16); ("WGPUBufferUsage_Vertex", 32); ("WGPUBufferUsage_Uniform", 64); ("WGPUBufferUsage_Storage", 128); ("WGPUBufferUsage_Indirect", 256); ("WGPUBufferUsage_QueryResolve", 512); ]

  let ( + ) : t -> t -> t = ( lor )

  let combine (l : t list) : t = List.fold_left ( lor ) 0 l

  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0

  let to_string (v : t) =
    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in
    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in
    let names = List.map fst set in
    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf "0x%x" (v land lnot covered) ] else names in
    match names with [] -> c_name ^ "_None" | l -> String.concat "|" l
end

(** [WGPUColorWriteMask] -- a bit set over [WGPUFlags] (from webgpu.h) *)
module ColorWriteMask = struct
  let c_name = "WGPUColorWriteMask"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t

  (** [WGPUColorWriteMask_None] *)
  let none : t = 0

  (** [WGPUColorWriteMask_Red] *)
  let red : t = 1

  (** [WGPUColorWriteMask_Green] *)
  let green : t = 2

  (** [WGPUColorWriteMask_Blue] *)
  let blue : t = 4

  (** [WGPUColorWriteMask_Alpha] *)
  let alpha : t = 8

  (** [WGPUColorWriteMask_All] *)
  let all : t = 15

  let values : (string * t) list =
    [ ("WGPUColorWriteMask_None", 0); ("WGPUColorWriteMask_Red", 1); ("WGPUColorWriteMask_Green", 2); ("WGPUColorWriteMask_Blue", 4); ("WGPUColorWriteMask_Alpha", 8); ("WGPUColorWriteMask_All", 15); ]

  let ( + ) : t -> t -> t = ( lor )

  let combine (l : t list) : t = List.fold_left ( lor ) 0 l

  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0

  let to_string (v : t) =
    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in
    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in
    let names = List.map fst set in
    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf "0x%x" (v land lnot covered) ] else names in
    match names with [] -> c_name ^ "_None" | l -> String.concat "|" l
end

(** [WGPUMapMode] -- a bit set over [WGPUFlags] (from webgpu.h) *)
module MapMode = struct
  let c_name = "WGPUMapMode"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t

  (** [WGPUMapMode_None] *)
  let none : t = 0

  (** [WGPUMapMode_Read] *)
  let read : t = 1

  (** [WGPUMapMode_Write] *)
  let write : t = 2

  let values : (string * t) list =
    [ ("WGPUMapMode_None", 0); ("WGPUMapMode_Read", 1); ("WGPUMapMode_Write", 2); ]

  let ( + ) : t -> t -> t = ( lor )

  let combine (l : t list) : t = List.fold_left ( lor ) 0 l

  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0

  let to_string (v : t) =
    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in
    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in
    let names = List.map fst set in
    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf "0x%x" (v land lnot covered) ] else names in
    match names with [] -> c_name ^ "_None" | l -> String.concat "|" l
end

(** [WGPUShaderStage] -- a bit set over [WGPUFlags] (from webgpu.h) *)
module ShaderStage = struct
  let c_name = "WGPUShaderStage"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t

  (** [WGPUShaderStage_None] *)
  let none : t = 0

  (** [WGPUShaderStage_Vertex] *)
  let vertex : t = 1

  (** [WGPUShaderStage_Fragment] *)
  let fragment : t = 2

  (** [WGPUShaderStage_Compute] *)
  let compute : t = 4

  let values : (string * t) list =
    [ ("WGPUShaderStage_None", 0); ("WGPUShaderStage_Vertex", 1); ("WGPUShaderStage_Fragment", 2); ("WGPUShaderStage_Compute", 4); ]

  let ( + ) : t -> t -> t = ( lor )

  let combine (l : t list) : t = List.fold_left ( lor ) 0 l

  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0

  let to_string (v : t) =
    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in
    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in
    let names = List.map fst set in
    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf "0x%x" (v land lnot covered) ] else names in
    match names with [] -> c_name ^ "_None" | l -> String.concat "|" l
end

(** [WGPUTextureUsage] -- a bit set over [WGPUFlags] (from webgpu.h) *)
module TextureUsage = struct
  let c_name = "WGPUTextureUsage"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t

  (** [WGPUTextureUsage_None] *)
  let none : t = 0

  (** [WGPUTextureUsage_CopySrc] *)
  let copy_src : t = 1

  (** [WGPUTextureUsage_CopyDst] *)
  let copy_dst : t = 2

  (** [WGPUTextureUsage_TextureBinding] *)
  let texture_binding : t = 4

  (** [WGPUTextureUsage_StorageBinding] *)
  let storage_binding : t = 8

  (** [WGPUTextureUsage_RenderAttachment] *)
  let render_attachment : t = 16

  (** [WGPUTextureUsage_TransientAttachment] *)
  let transient_attachment : t = 32

  let values : (string * t) list =
    [ ("WGPUTextureUsage_None", 0); ("WGPUTextureUsage_CopySrc", 1); ("WGPUTextureUsage_CopyDst", 2); ("WGPUTextureUsage_TextureBinding", 4); ("WGPUTextureUsage_StorageBinding", 8); ("WGPUTextureUsage_RenderAttachment", 16); ("WGPUTextureUsage_TransientAttachment", 32); ]

  let ( + ) : t -> t -> t = ( lor )

  let combine (l : t list) : t = List.fold_left ( lor ) 0 l

  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0

  let to_string (v : t) =
    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in
    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in
    let names = List.map fst set in
    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf "0x%x" (v land lnot covered) ] else names in
    match names with [] -> c_name ^ "_None" | l -> String.concat "|" l
end

(** [WGPUInstanceBackend] -- a bit set over [WGPUFlags] (from wgpu.h) *)
module InstanceBackend = struct
  let c_name = "WGPUInstanceBackend"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t

  (** [WGPUInstanceBackend_All] *)
  let all : t = 0

  (** [WGPUInstanceBackend_Vulkan] *)
  let vulkan : t = 1

  (** [WGPUInstanceBackend_GL] *)
  let gl : t = 2

  (** [WGPUInstanceBackend_Metal] *)
  let metal : t = 4

  (** [WGPUInstanceBackend_DX12] *)
  let dx12 : t = 8

  (** [WGPUInstanceBackend_BrowserWebGPU] *)
  let browser_web_gpu : t = 32

  (** [WGPUInstanceBackend_Primary] *)
  let primary : t = 45

  (** [WGPUInstanceBackend_Secondary] *)
  let secondary : t = 2

  (** [WGPUInstanceBackend_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUInstanceBackend_All", 0); ("WGPUInstanceBackend_Vulkan", 1); ("WGPUInstanceBackend_GL", 2); ("WGPUInstanceBackend_Metal", 4); ("WGPUInstanceBackend_DX12", 8); ("WGPUInstanceBackend_BrowserWebGPU", 32); ("WGPUInstanceBackend_Primary", 45); ("WGPUInstanceBackend_Secondary", 2); ("WGPUInstanceBackend_Force32", 2147483647); ]

  let ( + ) : t -> t -> t = ( lor )

  let combine (l : t list) : t = List.fold_left ( lor ) 0 l

  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0

  let to_string (v : t) =
    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in
    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in
    let names = List.map fst set in
    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf "0x%x" (v land lnot covered) ] else names in
    match names with [] -> c_name ^ "_None" | l -> String.concat "|" l
end

(** [WGPUInstanceFlag] -- a bit set over [WGPUFlags] (from wgpu.h) *)
module InstanceFlag = struct
  let c_name = "WGPUInstanceFlag"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t

  (** [WGPUInstanceFlag_Empty] *)
  let empty : t = 0

  (** [WGPUInstanceFlag_Debug] *)
  let debug : t = 1

  (** [WGPUInstanceFlag_Validation] *)
  let validation : t = 2

  (** [WGPUInstanceFlag_DiscardHalLabels] *)
  let discard_hal_labels : t = 4

  (** [WGPUInstanceFlag_AllowUnderlyingNoncompliantAdapter] *)
  let allow_underlying_noncompliant_adapter : t = 8

  (** [WGPUInstanceFlag_GPUBasedValidation] *)
  let gpu_based_validation : t = 16

  (** [WGPUInstanceFlag_ValidationIndirectCall] *)
  let validation_indirect_call : t = 32

  (** [WGPUInstanceFlag_AutomaticTimestampNormalization] *)
  let automatic_timestamp_normalization : t = 64

  (** [WGPUInstanceFlag_Default] *)
  let default : t = 16777216

  (** [WGPUInstanceFlag_Debugging] *)
  let debugging : t = 33554432

  (** [WGPUInstanceFlag_AdvancedDebugging] *)
  let advanced_debugging : t = 67108864

  (** [WGPUInstanceFlag_WithEnv] *)
  let with_env : t = 134217728

  (** [WGPUInstanceFlag_Force32] *)
  let force32 : t = 2147483647

  let values : (string * t) list =
    [ ("WGPUInstanceFlag_Empty", 0); ("WGPUInstanceFlag_Debug", 1); ("WGPUInstanceFlag_Validation", 2); ("WGPUInstanceFlag_DiscardHalLabels", 4); ("WGPUInstanceFlag_AllowUnderlyingNoncompliantAdapter", 8); ("WGPUInstanceFlag_GPUBasedValidation", 16); ("WGPUInstanceFlag_ValidationIndirectCall", 32); ("WGPUInstanceFlag_AutomaticTimestampNormalization", 64); ("WGPUInstanceFlag_Default", 16777216); ("WGPUInstanceFlag_Debugging", 33554432); ("WGPUInstanceFlag_AdvancedDebugging", 67108864); ("WGPUInstanceFlag_WithEnv", 134217728); ("WGPUInstanceFlag_Force32", 2147483647); ]

  let ( + ) : t -> t -> t = ( lor )

  let combine (l : t list) : t = List.fold_left ( lor ) 0 l

  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0

  let to_string (v : t) =
    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in
    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in
    let names = List.map fst set in
    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf "0x%x" (v land lnot covered) ] else names in
    match names with [] -> c_name ^ "_None" | l -> String.concat "|" l
end

(** [WGPUShaderRuntimeChecks] -- a bit set over [WGPUFlags] (from wgpu.h) *)
module ShaderRuntimeChecks = struct
  let c_name = "WGPUShaderRuntimeChecks"

  type t = int

  let t : t Ctypes.typ =
    Ctypes.view ~read:Unsigned.UInt64.to_int ~write:Unsigned.UInt64.of_int Ctypes.uint64_t

  (** [WGPUShaderRuntimeChecks_None] *)
  let none : t = 0

  (** [WGPUShaderRuntimeChecks_BoundsChecks] *)
  let bounds_checks : t = 1

  (** [WGPUShaderRuntimeChecks_ForceLoopBounding] *)
  let force_loop_bounding : t = 2

  (** [WGPUShaderRuntimeChecks_RayQueryInitializationTracking] *)
  let ray_query_initialization_tracking : t = 4

  (** [WGPUShaderRuntimeChecks_TaskShaderDispatchTracking] *)
  let task_shader_dispatch_tracking : t = 8

  (** [WGPUShaderRuntimeChecks_MeshShaderPrimitiveIndicesClamp] *)
  let mesh_shader_primitive_indices_clamp : t = 16

  let values : (string * t) list =
    [ ("WGPUShaderRuntimeChecks_None", 0); ("WGPUShaderRuntimeChecks_BoundsChecks", 1); ("WGPUShaderRuntimeChecks_ForceLoopBounding", 2); ("WGPUShaderRuntimeChecks_RayQueryInitializationTracking", 4); ("WGPUShaderRuntimeChecks_TaskShaderDispatchTracking", 8); ("WGPUShaderRuntimeChecks_MeshShaderPrimitiveIndicesClamp", 16); ]

  let ( + ) : t -> t -> t = ( lor )

  let combine (l : t list) : t = List.fold_left ( lor ) 0 l

  let mem ~(bit : t) (v : t) = v land bit = bit && bit <> 0

  let to_string (v : t) =
    let set = List.filter (fun (_, x) -> x <> 0 && v land x = x) values in
    let covered = List.fold_left (fun a (_, x) -> a lor x) 0 set in
    let names = List.map fst set in
    let names = if v land lnot covered <> 0 then names @ [ Printf.sprintf "0x%x" (v land lnot covered) ] else names in
    match names with [] -> c_name ^ "_None" | l -> String.concat "|" l
end

(** [WGPUStringView] (from webgpu.h) *)
module StringView = struct
  let c_name = "WGPUStringView"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUStringView"

  (** [WGPUStringView data] : [char Ctypes.ptr] *)
  let data = Ctypes.field t "data" (Ctypes.ptr Ctypes.char)

  (** [WGPUStringView length] : [Unsigned.Size_t.t] *)
  let length = Ctypes.field t "length" Ctypes.size_t

  let () = Ctypes.seal t

  let field_names = [ "data"; "length"; ]

  (** A fresh value carrying the defaults of the header's [STRING_VIEW_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v length (Constants.strlen);
    v
end

(** [WGPUChainedStruct] (from webgpu.h) *)
module ChainedStruct = struct
  let c_name = "WGPUChainedStruct"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUChainedStruct"

  (** [WGPUChainedStruct next] : [t Ctypes.ptr] *)
  let next = Ctypes.field t "next" (Ctypes.ptr t)

  (** [WGPUChainedStruct sType] : [SType.t] *)
  let sType = Ctypes.field t "sType" SType.t

  let () = Ctypes.seal t

  let field_names = [ "next"; "sType"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUBufferMapCallback] (from webgpu.h) *)
module BufferMapCallback = struct
  let c_name = "WGPUBufferMapCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (MapAsyncStatus.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(MapAsyncStatus.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (MapAsyncStatus.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUBufferMapCallbackInfo] (from webgpu.h) *)
module BufferMapCallbackInfo = struct
  let c_name = "WGPUBufferMapCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBufferMapCallbackInfo"

  (** [WGPUBufferMapCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUBufferMapCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPUBufferMapCallbackInfo callback] : [BufferMapCallback.t] *)
  let callback = Ctypes.field t "callback" BufferMapCallback.t

  (** [WGPUBufferMapCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPUBufferMapCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [BUFFER_MAP_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUCompilationMessage] (from webgpu.h) *)
module CompilationMessage = struct
  let c_name = "WGPUCompilationMessage"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUCompilationMessage"

  (** [WGPUCompilationMessage nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUCompilationMessage message] : [StringView.t] *)
  let message = Ctypes.field t "message" StringView.t

  (** [WGPUCompilationMessage type] : [CompilationMessageType.t] *)
  let type_ = Ctypes.field t "type" CompilationMessageType.t

  (** [WGPUCompilationMessage lineNum] : [Unsigned.UInt64.t] *)
  let lineNum = Ctypes.field t "lineNum" Ctypes.uint64_t

  (** [WGPUCompilationMessage linePos] : [Unsigned.UInt64.t] *)
  let linePos = Ctypes.field t "linePos" Ctypes.uint64_t

  (** [WGPUCompilationMessage offset] : [Unsigned.UInt64.t] *)
  let offset = Ctypes.field t "offset" Ctypes.uint64_t

  (** [WGPUCompilationMessage length] : [Unsigned.UInt64.t] *)
  let length = Ctypes.field t "length" Ctypes.uint64_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "message"; "type"; "lineNum"; "linePos"; "offset"; "length"; ]

  (** A fresh value carrying the defaults of the header's [COMPILATION_MESSAGE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v message (StringView.init ());
    v
end

(** [WGPUCompilationInfo] (from webgpu.h) *)
module CompilationInfo = struct
  let c_name = "WGPUCompilationInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUCompilationInfo"

  (** [WGPUCompilationInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUCompilationInfo messageCount] : [Unsigned.Size_t.t] *)
  let messageCount = Ctypes.field t "messageCount" Ctypes.size_t

  (** [WGPUCompilationInfo messages] : [CompilationMessage.t Ctypes.ptr] *)
  let messages = Ctypes.field t "messages" (Ctypes.ptr CompilationMessage.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "messageCount"; "messages"; ]

  (** A fresh value carrying the defaults of the header's [COMPILATION_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUCompilationInfoCallback] (from webgpu.h) *)
module CompilationInfoCallback = struct
  let c_name = "WGPUCompilationInfoCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (CompilationInfoRequestStatus.t -> CompilationInfo.t Ctypes.ptr -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(CompilationInfoRequestStatus.t @-> (Ctypes.ptr CompilationInfo.t) @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CompilationInfoRequestStatus.t -> CompilationInfo.t Ctypes.ptr -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUCompilationInfoCallbackInfo] (from webgpu.h) *)
module CompilationInfoCallbackInfo = struct
  let c_name = "WGPUCompilationInfoCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUCompilationInfoCallbackInfo"

  (** [WGPUCompilationInfoCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUCompilationInfoCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPUCompilationInfoCallbackInfo callback] : [CompilationInfoCallback.t] *)
  let callback = Ctypes.field t "callback" CompilationInfoCallback.t

  (** [WGPUCompilationInfoCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPUCompilationInfoCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [COMPILATION_INFO_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUCreateComputePipelineAsyncCallback] (from webgpu.h) *)
module CreateComputePipelineAsyncCallback = struct
  let c_name = "WGPUCreateComputePipelineAsyncCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (CreatePipelineAsyncStatus.t -> ComputePipeline.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(CreatePipelineAsyncStatus.t @-> ComputePipeline.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CreatePipelineAsyncStatus.t -> ComputePipeline.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUCreateComputePipelineAsyncCallbackInfo] (from webgpu.h) *)
module CreateComputePipelineAsyncCallbackInfo = struct
  let c_name = "WGPUCreateComputePipelineAsyncCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUCreateComputePipelineAsyncCallbackInfo"

  (** [WGPUCreateComputePipelineAsyncCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUCreateComputePipelineAsyncCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPUCreateComputePipelineAsyncCallbackInfo callback] : [CreateComputePipelineAsyncCallback.t] *)
  let callback = Ctypes.field t "callback" CreateComputePipelineAsyncCallback.t

  (** [WGPUCreateComputePipelineAsyncCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPUCreateComputePipelineAsyncCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [CREATE_COMPUTE_PIPELINE_ASYNC_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUCreateRenderPipelineAsyncCallback] (from webgpu.h) *)
module CreateRenderPipelineAsyncCallback = struct
  let c_name = "WGPUCreateRenderPipelineAsyncCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (CreatePipelineAsyncStatus.t -> RenderPipeline.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(CreatePipelineAsyncStatus.t @-> RenderPipeline.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CreatePipelineAsyncStatus.t -> RenderPipeline.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUCreateRenderPipelineAsyncCallbackInfo] (from webgpu.h) *)
module CreateRenderPipelineAsyncCallbackInfo = struct
  let c_name = "WGPUCreateRenderPipelineAsyncCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUCreateRenderPipelineAsyncCallbackInfo"

  (** [WGPUCreateRenderPipelineAsyncCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUCreateRenderPipelineAsyncCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPUCreateRenderPipelineAsyncCallbackInfo callback] : [CreateRenderPipelineAsyncCallback.t] *)
  let callback = Ctypes.field t "callback" CreateRenderPipelineAsyncCallback.t

  (** [WGPUCreateRenderPipelineAsyncCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPUCreateRenderPipelineAsyncCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [CREATE_RENDER_PIPELINE_ASYNC_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUDeviceLostCallback] (from webgpu.h) *)
module DeviceLostCallback = struct
  let c_name = "WGPUDeviceLostCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t Ctypes.ptr -> DeviceLostReason.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.((Ctypes.ptr Device.t) @-> DeviceLostReason.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t Ctypes.ptr -> DeviceLostReason.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUDeviceLostCallbackInfo] (from webgpu.h) *)
module DeviceLostCallbackInfo = struct
  let c_name = "WGPUDeviceLostCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUDeviceLostCallbackInfo"

  (** [WGPUDeviceLostCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUDeviceLostCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPUDeviceLostCallbackInfo callback] : [DeviceLostCallback.t] *)
  let callback = Ctypes.field t "callback" DeviceLostCallback.t

  (** [WGPUDeviceLostCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPUDeviceLostCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [DEVICE_LOST_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUPopErrorScopeCallback] (from webgpu.h) *)
module PopErrorScopeCallback = struct
  let c_name = "WGPUPopErrorScopeCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (PopErrorScopeStatus.t -> ErrorType.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(PopErrorScopeStatus.t @-> ErrorType.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (PopErrorScopeStatus.t -> ErrorType.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUPopErrorScopeCallbackInfo] (from webgpu.h) *)
module PopErrorScopeCallbackInfo = struct
  let c_name = "WGPUPopErrorScopeCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUPopErrorScopeCallbackInfo"

  (** [WGPUPopErrorScopeCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUPopErrorScopeCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPUPopErrorScopeCallbackInfo callback] : [PopErrorScopeCallback.t] *)
  let callback = Ctypes.field t "callback" PopErrorScopeCallback.t

  (** [WGPUPopErrorScopeCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPUPopErrorScopeCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [POP_ERROR_SCOPE_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUQueueWorkDoneCallback] (from webgpu.h) *)
module QueueWorkDoneCallback = struct
  let c_name = "WGPUQueueWorkDoneCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (QueueWorkDoneStatus.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(QueueWorkDoneStatus.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (QueueWorkDoneStatus.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUQueueWorkDoneCallbackInfo] (from webgpu.h) *)
module QueueWorkDoneCallbackInfo = struct
  let c_name = "WGPUQueueWorkDoneCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUQueueWorkDoneCallbackInfo"

  (** [WGPUQueueWorkDoneCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUQueueWorkDoneCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPUQueueWorkDoneCallbackInfo callback] : [QueueWorkDoneCallback.t] *)
  let callback = Ctypes.field t "callback" QueueWorkDoneCallback.t

  (** [WGPUQueueWorkDoneCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPUQueueWorkDoneCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [QUEUE_WORK_DONE_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPURequestAdapterCallback] (from webgpu.h) *)
module RequestAdapterCallback = struct
  let c_name = "WGPURequestAdapterCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (RequestAdapterStatus.t -> Adapter.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(RequestAdapterStatus.t @-> Adapter.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RequestAdapterStatus.t -> Adapter.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPURequestAdapterCallbackInfo] (from webgpu.h) *)
module RequestAdapterCallbackInfo = struct
  let c_name = "WGPURequestAdapterCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURequestAdapterCallbackInfo"

  (** [WGPURequestAdapterCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURequestAdapterCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPURequestAdapterCallbackInfo callback] : [RequestAdapterCallback.t] *)
  let callback = Ctypes.field t "callback" RequestAdapterCallback.t

  (** [WGPURequestAdapterCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPURequestAdapterCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [REQUEST_ADAPTER_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPURequestDeviceCallback] (from webgpu.h) *)
module RequestDeviceCallback = struct
  let c_name = "WGPURequestDeviceCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (RequestDeviceStatus.t -> Device.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(RequestDeviceStatus.t @-> Device.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RequestDeviceStatus.t -> Device.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPURequestDeviceCallbackInfo] (from webgpu.h) *)
module RequestDeviceCallbackInfo = struct
  let c_name = "WGPURequestDeviceCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURequestDeviceCallbackInfo"

  (** [WGPURequestDeviceCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURequestDeviceCallbackInfo mode] : [CallbackMode.t] *)
  let mode = Ctypes.field t "mode" CallbackMode.t

  (** [WGPURequestDeviceCallbackInfo callback] : [RequestDeviceCallback.t] *)
  let callback = Ctypes.field t "callback" RequestDeviceCallback.t

  (** [WGPURequestDeviceCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPURequestDeviceCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "mode"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [REQUEST_DEVICE_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUUncapturedErrorCallback] (from webgpu.h) *)
module UncapturedErrorCallback = struct
  let c_name = "WGPUUncapturedErrorCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t Ctypes.ptr -> ErrorType.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.((Ctypes.ptr Device.t) @-> ErrorType.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t Ctypes.ptr -> ErrorType.t -> StringView.t -> unit Ctypes.ptr -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUUncapturedErrorCallbackInfo] (from webgpu.h) *)
module UncapturedErrorCallbackInfo = struct
  let c_name = "WGPUUncapturedErrorCallbackInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUUncapturedErrorCallbackInfo"

  (** [WGPUUncapturedErrorCallbackInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUUncapturedErrorCallbackInfo callback] : [UncapturedErrorCallback.t] *)
  let callback = Ctypes.field t "callback" UncapturedErrorCallback.t

  (** [WGPUUncapturedErrorCallbackInfo userdata1] : [unit Ctypes.ptr] *)
  let userdata1 = Ctypes.field t "userdata1" (Ctypes.ptr Ctypes.void)

  (** [WGPUUncapturedErrorCallbackInfo userdata2] : [unit Ctypes.ptr] *)
  let userdata2 = Ctypes.field t "userdata2" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "callback"; "userdata1"; "userdata2"; ]

  (** A fresh value carrying the defaults of the header's [UNCAPTURED_ERROR_CALLBACK_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUAdapterInfo] (from webgpu.h) *)
module AdapterInfo = struct
  let c_name = "WGPUAdapterInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUAdapterInfo"

  (** [WGPUAdapterInfo nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUAdapterInfo vendor] : [StringView.t] *)
  let vendor = Ctypes.field t "vendor" StringView.t

  (** [WGPUAdapterInfo architecture] : [StringView.t] *)
  let architecture = Ctypes.field t "architecture" StringView.t

  (** [WGPUAdapterInfo device] : [StringView.t] *)
  let device = Ctypes.field t "device" StringView.t

  (** [WGPUAdapterInfo description] : [StringView.t] *)
  let description = Ctypes.field t "description" StringView.t

  (** [WGPUAdapterInfo backendType] : [BackendType.t] *)
  let backendType = Ctypes.field t "backendType" BackendType.t

  (** [WGPUAdapterInfo adapterType] : [AdapterType.t] *)
  let adapterType = Ctypes.field t "adapterType" AdapterType.t

  (** [WGPUAdapterInfo vendorID] : [Unsigned.UInt32.t] *)
  let vendorID = Ctypes.field t "vendorID" Ctypes.uint32_t

  (** [WGPUAdapterInfo deviceID] : [Unsigned.UInt32.t] *)
  let deviceID = Ctypes.field t "deviceID" Ctypes.uint32_t

  (** [WGPUAdapterInfo subgroupMinSize] : [Unsigned.UInt32.t] *)
  let subgroupMinSize = Ctypes.field t "subgroupMinSize" Ctypes.uint32_t

  (** [WGPUAdapterInfo subgroupMaxSize] : [Unsigned.UInt32.t] *)
  let subgroupMaxSize = Ctypes.field t "subgroupMaxSize" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "vendor"; "architecture"; "device"; "description"; "backendType"; "adapterType"; "vendorID"; "deviceID"; "subgroupMinSize"; "subgroupMaxSize"; ]

  (** A fresh value carrying the defaults of the header's [ADAPTER_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v vendor (StringView.init ());
    Ctypes.setf v architecture (StringView.init ());
    Ctypes.setf v device (StringView.init ());
    Ctypes.setf v description (StringView.init ());
    Ctypes.setf v backendType (BackendType.undefined);
    v
end

(** [WGPUBlendComponent] (from webgpu.h) *)
module BlendComponent = struct
  let c_name = "WGPUBlendComponent"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBlendComponent"

  (** [WGPUBlendComponent operation] : [BlendOperation.t] *)
  let operation = Ctypes.field t "operation" BlendOperation.t

  (** [WGPUBlendComponent srcFactor] : [BlendFactor.t] *)
  let srcFactor = Ctypes.field t "srcFactor" BlendFactor.t

  (** [WGPUBlendComponent dstFactor] : [BlendFactor.t] *)
  let dstFactor = Ctypes.field t "dstFactor" BlendFactor.t

  let () = Ctypes.seal t

  let field_names = [ "operation"; "srcFactor"; "dstFactor"; ]

  (** A fresh value carrying the defaults of the header's [BLEND_COMPONENT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v operation (BlendOperation.undefined);
    Ctypes.setf v srcFactor (BlendFactor.undefined);
    Ctypes.setf v dstFactor (BlendFactor.undefined);
    v
end

(** [WGPUBufferBindingLayout] (from webgpu.h) *)
module BufferBindingLayout = struct
  let c_name = "WGPUBufferBindingLayout"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBufferBindingLayout"

  (** [WGPUBufferBindingLayout nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUBufferBindingLayout type] : [BufferBindingType.t] *)
  let type_ = Ctypes.field t "type" BufferBindingType.t

  (** [WGPUBufferBindingLayout hasDynamicOffset] : [Unsigned.UInt32.t] *)
  let hasDynamicOffset = Ctypes.field t "hasDynamicOffset" Ctypes.uint32_t

  (** [WGPUBufferBindingLayout minBindingSize] : [Unsigned.UInt64.t] *)
  let minBindingSize = Ctypes.field t "minBindingSize" Ctypes.uint64_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "type"; "hasDynamicOffset"; "minBindingSize"; ]

  (** A fresh value carrying the defaults of the header's [BUFFER_BINDING_LAYOUT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v type_ (BufferBindingType.undefined);
    Ctypes.setf v hasDynamicOffset (Constants.false_);
    v
end

(** [WGPUBufferDescriptor] (from webgpu.h) *)
module BufferDescriptor = struct
  let c_name = "WGPUBufferDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBufferDescriptor"

  (** [WGPUBufferDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUBufferDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUBufferDescriptor usage] : [BufferUsage.t] *)
  let usage = Ctypes.field t "usage" BufferUsage.t

  (** [WGPUBufferDescriptor size] : [Unsigned.UInt64.t] *)
  let size = Ctypes.field t "size" Ctypes.uint64_t

  (** [WGPUBufferDescriptor mappedAtCreation] : [Unsigned.UInt32.t] *)
  let mappedAtCreation = Ctypes.field t "mappedAtCreation" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "usage"; "size"; "mappedAtCreation"; ]

  (** A fresh value carrying the defaults of the header's [BUFFER_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    Ctypes.setf v usage (BufferUsage.none);
    Ctypes.setf v mappedAtCreation (Constants.false_);
    v
end

(** [WGPUColor] (from webgpu.h) *)
module Color = struct
  let c_name = "WGPUColor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUColor"

  (** [WGPUColor r] : [float] *)
  let r = Ctypes.field t "r" Ctypes.double

  (** [WGPUColor g] : [float] *)
  let g = Ctypes.field t "g" Ctypes.double

  (** [WGPUColor b] : [float] *)
  let b = Ctypes.field t "b" Ctypes.double

  (** [WGPUColor a] : [float] *)
  let a = Ctypes.field t "a" Ctypes.double

  let () = Ctypes.seal t

  let field_names = [ "r"; "g"; "b"; "a"; ]

  (** A fresh value carrying the defaults of the header's [COLOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUCommandBufferDescriptor] (from webgpu.h) *)
module CommandBufferDescriptor = struct
  let c_name = "WGPUCommandBufferDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUCommandBufferDescriptor"

  (** [WGPUCommandBufferDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUCommandBufferDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; ]

  (** A fresh value carrying the defaults of the header's [COMMAND_BUFFER_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUCommandEncoderDescriptor] (from webgpu.h) *)
module CommandEncoderDescriptor = struct
  let c_name = "WGPUCommandEncoderDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUCommandEncoderDescriptor"

  (** [WGPUCommandEncoderDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUCommandEncoderDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; ]

  (** A fresh value carrying the defaults of the header's [COMMAND_ENCODER_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUCompatibilityModeLimits] (from webgpu.h) *)
module CompatibilityModeLimits = struct
  let c_name = "WGPUCompatibilityModeLimits"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUCompatibilityModeLimits"

  (** [WGPUCompatibilityModeLimits chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUCompatibilityModeLimits maxStorageBuffersInVertexStage] : [Unsigned.UInt32.t] *)
  let maxStorageBuffersInVertexStage = Ctypes.field t "maxStorageBuffersInVertexStage" Ctypes.uint32_t

  (** [WGPUCompatibilityModeLimits maxStorageTexturesInVertexStage] : [Unsigned.UInt32.t] *)
  let maxStorageTexturesInVertexStage = Ctypes.field t "maxStorageTexturesInVertexStage" Ctypes.uint32_t

  (** [WGPUCompatibilityModeLimits maxStorageBuffersInFragmentStage] : [Unsigned.UInt32.t] *)
  let maxStorageBuffersInFragmentStage = Ctypes.field t "maxStorageBuffersInFragmentStage" Ctypes.uint32_t

  (** [WGPUCompatibilityModeLimits maxStorageTexturesInFragmentStage] : [Unsigned.UInt32.t] *)
  let maxStorageTexturesInFragmentStage = Ctypes.field t "maxStorageTexturesInFragmentStage" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "maxStorageBuffersInVertexStage"; "maxStorageTexturesInVertexStage"; "maxStorageBuffersInFragmentStage"; "maxStorageTexturesInFragmentStage"; ]

  (** A fresh value carrying the defaults of the header's [COMPATIBILITY_MODE_LIMITS_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.compatibility_mode_limits);  s);
    Ctypes.setf v maxStorageBuffersInVertexStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxStorageTexturesInVertexStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxStorageBuffersInFragmentStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxStorageTexturesInFragmentStage (Constants.limit_u32_undefined);
    v
end

(** [WGPUConstantEntry] (from webgpu.h) *)
module ConstantEntry = struct
  let c_name = "WGPUConstantEntry"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUConstantEntry"

  (** [WGPUConstantEntry nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUConstantEntry key] : [StringView.t] *)
  let key = Ctypes.field t "key" StringView.t

  (** [WGPUConstantEntry value] : [float] *)
  let value = Ctypes.field t "value" Ctypes.double

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "key"; "value"; ]

  (** A fresh value carrying the defaults of the header's [CONSTANT_ENTRY_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v key (StringView.init ());
    v
end

(** [WGPUExtent3D] (from webgpu.h) *)
module Extent3D = struct
  let c_name = "WGPUExtent3D"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUExtent3D"

  (** [WGPUExtent3D width] : [Unsigned.UInt32.t] *)
  let width = Ctypes.field t "width" Ctypes.uint32_t

  (** [WGPUExtent3D height] : [Unsigned.UInt32.t] *)
  let height = Ctypes.field t "height" Ctypes.uint32_t

  (** [WGPUExtent3D depthOrArrayLayers] : [Unsigned.UInt32.t] *)
  let depthOrArrayLayers = Ctypes.field t "depthOrArrayLayers" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "width"; "height"; "depthOrArrayLayers"; ]

  (** A fresh value carrying the defaults of the header's [EXTENT3_D_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v height (Unsigned.UInt32.of_int 1);
    Ctypes.setf v depthOrArrayLayers (Unsigned.UInt32.of_int 1);
    v
end

(** [WGPUExternalTextureBindingEntry] (from webgpu.h) *)
module ExternalTextureBindingEntry = struct
  let c_name = "WGPUExternalTextureBindingEntry"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUExternalTextureBindingEntry"

  (** [WGPUExternalTextureBindingEntry chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUExternalTextureBindingEntry externalTexture] : [ExternalTexture.t] *)
  let externalTexture = Ctypes.field t "externalTexture" ExternalTexture.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "externalTexture"; ]

  (** A fresh value carrying the defaults of the header's [EXTERNAL_TEXTURE_BINDING_ENTRY_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.external_texture_binding_entry);  s);
    v
end

(** [WGPUExternalTextureBindingLayout] (from webgpu.h) *)
module ExternalTextureBindingLayout = struct
  let c_name = "WGPUExternalTextureBindingLayout"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUExternalTextureBindingLayout"

  (** [WGPUExternalTextureBindingLayout chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; ]

  (** A fresh value carrying the defaults of the header's [EXTERNAL_TEXTURE_BINDING_LAYOUT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.external_texture_binding_layout);  s);
    v
end

(** [WGPUFuture] (from webgpu.h) *)
module Future = struct
  let c_name = "WGPUFuture"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUFuture"

  (** [WGPUFuture id] : [Unsigned.UInt64.t] *)
  let id = Ctypes.field t "id" Ctypes.uint64_t

  let () = Ctypes.seal t

  let field_names = [ "id"; ]

  (** A fresh value carrying the defaults of the header's [FUTURE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUInstanceLimits] (from webgpu.h) *)
module InstanceLimits = struct
  let c_name = "WGPUInstanceLimits"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUInstanceLimits"

  (** [WGPUInstanceLimits nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUInstanceLimits timedWaitAnyMaxCount] : [Unsigned.Size_t.t] *)
  let timedWaitAnyMaxCount = Ctypes.field t "timedWaitAnyMaxCount" Ctypes.size_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "timedWaitAnyMaxCount"; ]

  (** A fresh value carrying the defaults of the header's [INSTANCE_LIMITS_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUMultisampleState] (from webgpu.h) *)
module MultisampleState = struct
  let c_name = "WGPUMultisampleState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUMultisampleState"

  (** [WGPUMultisampleState nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUMultisampleState count] : [Unsigned.UInt32.t] *)
  let count = Ctypes.field t "count" Ctypes.uint32_t

  (** [WGPUMultisampleState mask] : [Unsigned.UInt32.t] *)
  let mask = Ctypes.field t "mask" Ctypes.uint32_t

  (** [WGPUMultisampleState alphaToCoverageEnabled] : [Unsigned.UInt32.t] *)
  let alphaToCoverageEnabled = Ctypes.field t "alphaToCoverageEnabled" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "count"; "mask"; "alphaToCoverageEnabled"; ]

  (** A fresh value carrying the defaults of the header's [MULTISAMPLE_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v count (Unsigned.UInt32.of_int 1);
    Ctypes.setf v mask (Unsigned.UInt32.of_int 4294967295);
    Ctypes.setf v alphaToCoverageEnabled (Constants.false_);
    v
end

(** [WGPUOrigin3D] (from webgpu.h) *)
module Origin3D = struct
  let c_name = "WGPUOrigin3D"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUOrigin3D"

  (** [WGPUOrigin3D x] : [Unsigned.UInt32.t] *)
  let x = Ctypes.field t "x" Ctypes.uint32_t

  (** [WGPUOrigin3D y] : [Unsigned.UInt32.t] *)
  let y = Ctypes.field t "y" Ctypes.uint32_t

  (** [WGPUOrigin3D z] : [Unsigned.UInt32.t] *)
  let z = Ctypes.field t "z" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "x"; "y"; "z"; ]

  (** A fresh value carrying the defaults of the header's [ORIGIN3_D_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUPassTimestampWrites] (from webgpu.h) *)
module PassTimestampWrites = struct
  let c_name = "WGPUPassTimestampWrites"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUPassTimestampWrites"

  (** [WGPUPassTimestampWrites nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUPassTimestampWrites querySet] : [QuerySet.t] *)
  let querySet = Ctypes.field t "querySet" QuerySet.t

  (** [WGPUPassTimestampWrites beginningOfPassWriteIndex] : [Unsigned.UInt32.t] *)
  let beginningOfPassWriteIndex = Ctypes.field t "beginningOfPassWriteIndex" Ctypes.uint32_t

  (** [WGPUPassTimestampWrites endOfPassWriteIndex] : [Unsigned.UInt32.t] *)
  let endOfPassWriteIndex = Ctypes.field t "endOfPassWriteIndex" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "querySet"; "beginningOfPassWriteIndex"; "endOfPassWriteIndex"; ]

  (** A fresh value carrying the defaults of the header's [PASS_TIMESTAMP_WRITES_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v beginningOfPassWriteIndex (Constants.query_set_index_undefined);
    Ctypes.setf v endOfPassWriteIndex (Constants.query_set_index_undefined);
    v
end

(** [WGPUPipelineLayoutDescriptor] (from webgpu.h) *)
module PipelineLayoutDescriptor = struct
  let c_name = "WGPUPipelineLayoutDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUPipelineLayoutDescriptor"

  (** [WGPUPipelineLayoutDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUPipelineLayoutDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUPipelineLayoutDescriptor bindGroupLayoutCount] : [Unsigned.Size_t.t] *)
  let bindGroupLayoutCount = Ctypes.field t "bindGroupLayoutCount" Ctypes.size_t

  (** [WGPUPipelineLayoutDescriptor bindGroupLayouts] : [BindGroupLayout.t Ctypes.ptr] *)
  let bindGroupLayouts = Ctypes.field t "bindGroupLayouts" (Ctypes.ptr BindGroupLayout.t)

  (** [WGPUPipelineLayoutDescriptor immediateSize] : [Unsigned.UInt32.t] *)
  let immediateSize = Ctypes.field t "immediateSize" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "bindGroupLayoutCount"; "bindGroupLayouts"; "immediateSize"; ]

  (** A fresh value carrying the defaults of the header's [PIPELINE_LAYOUT_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUPrimitiveState] (from webgpu.h) *)
module PrimitiveState = struct
  let c_name = "WGPUPrimitiveState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUPrimitiveState"

  (** [WGPUPrimitiveState nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUPrimitiveState topology] : [PrimitiveTopology.t] *)
  let topology = Ctypes.field t "topology" PrimitiveTopology.t

  (** [WGPUPrimitiveState stripIndexFormat] : [IndexFormat.t] *)
  let stripIndexFormat = Ctypes.field t "stripIndexFormat" IndexFormat.t

  (** [WGPUPrimitiveState frontFace] : [FrontFace.t] *)
  let frontFace = Ctypes.field t "frontFace" FrontFace.t

  (** [WGPUPrimitiveState cullMode] : [CullMode.t] *)
  let cullMode = Ctypes.field t "cullMode" CullMode.t

  (** [WGPUPrimitiveState unclippedDepth] : [Unsigned.UInt32.t] *)
  let unclippedDepth = Ctypes.field t "unclippedDepth" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "topology"; "stripIndexFormat"; "frontFace"; "cullMode"; "unclippedDepth"; ]

  (** A fresh value carrying the defaults of the header's [PRIMITIVE_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v topology (PrimitiveTopology.undefined);
    Ctypes.setf v stripIndexFormat (IndexFormat.undefined);
    Ctypes.setf v frontFace (FrontFace.undefined);
    Ctypes.setf v cullMode (CullMode.undefined);
    Ctypes.setf v unclippedDepth (Constants.false_);
    v
end

(** [WGPUQuerySetDescriptor] (from webgpu.h) *)
module QuerySetDescriptor = struct
  let c_name = "WGPUQuerySetDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUQuerySetDescriptor"

  (** [WGPUQuerySetDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUQuerySetDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUQuerySetDescriptor type] : [QueryType.t] *)
  let type_ = Ctypes.field t "type" QueryType.t

  (** [WGPUQuerySetDescriptor count] : [Unsigned.UInt32.t] *)
  let count = Ctypes.field t "count" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "type"; "count"; ]

  (** A fresh value carrying the defaults of the header's [QUERY_SET_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUQueueDescriptor] (from webgpu.h) *)
module QueueDescriptor = struct
  let c_name = "WGPUQueueDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUQueueDescriptor"

  (** [WGPUQueueDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUQueueDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; ]

  (** A fresh value carrying the defaults of the header's [QUEUE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPURenderBundleDescriptor] (from webgpu.h) *)
module RenderBundleDescriptor = struct
  let c_name = "WGPURenderBundleDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURenderBundleDescriptor"

  (** [WGPURenderBundleDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURenderBundleDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; ]

  (** A fresh value carrying the defaults of the header's [RENDER_BUNDLE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPURenderBundleEncoderDescriptor] (from webgpu.h) *)
module RenderBundleEncoderDescriptor = struct
  let c_name = "WGPURenderBundleEncoderDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURenderBundleEncoderDescriptor"

  (** [WGPURenderBundleEncoderDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURenderBundleEncoderDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPURenderBundleEncoderDescriptor colorFormatCount] : [Unsigned.Size_t.t] *)
  let colorFormatCount = Ctypes.field t "colorFormatCount" Ctypes.size_t

  (** [WGPURenderBundleEncoderDescriptor colorFormats] : [TextureFormat.t Ctypes.ptr] *)
  let colorFormats = Ctypes.field t "colorFormats" (Ctypes.ptr TextureFormat.t)

  (** [WGPURenderBundleEncoderDescriptor depthStencilFormat] : [TextureFormat.t] *)
  let depthStencilFormat = Ctypes.field t "depthStencilFormat" TextureFormat.t

  (** [WGPURenderBundleEncoderDescriptor sampleCount] : [Unsigned.UInt32.t] *)
  let sampleCount = Ctypes.field t "sampleCount" Ctypes.uint32_t

  (** [WGPURenderBundleEncoderDescriptor depthReadOnly] : [Unsigned.UInt32.t] *)
  let depthReadOnly = Ctypes.field t "depthReadOnly" Ctypes.uint32_t

  (** [WGPURenderBundleEncoderDescriptor stencilReadOnly] : [Unsigned.UInt32.t] *)
  let stencilReadOnly = Ctypes.field t "stencilReadOnly" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "colorFormatCount"; "colorFormats"; "depthStencilFormat"; "sampleCount"; "depthReadOnly"; "stencilReadOnly"; ]

  (** A fresh value carrying the defaults of the header's [RENDER_BUNDLE_ENCODER_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    Ctypes.setf v depthStencilFormat (TextureFormat.undefined);
    Ctypes.setf v sampleCount (Unsigned.UInt32.of_int 1);
    Ctypes.setf v depthReadOnly (Constants.false_);
    Ctypes.setf v stencilReadOnly (Constants.false_);
    v
end

(** [WGPURenderPassDepthStencilAttachment] (from webgpu.h) *)
module RenderPassDepthStencilAttachment = struct
  let c_name = "WGPURenderPassDepthStencilAttachment"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURenderPassDepthStencilAttachment"

  (** [WGPURenderPassDepthStencilAttachment nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURenderPassDepthStencilAttachment view] : [TextureView.t] *)
  let view = Ctypes.field t "view" TextureView.t

  (** [WGPURenderPassDepthStencilAttachment depthLoadOp] : [LoadOp.t] *)
  let depthLoadOp = Ctypes.field t "depthLoadOp" LoadOp.t

  (** [WGPURenderPassDepthStencilAttachment depthStoreOp] : [StoreOp.t] *)
  let depthStoreOp = Ctypes.field t "depthStoreOp" StoreOp.t

  (** [WGPURenderPassDepthStencilAttachment depthClearValue] : [float] *)
  let depthClearValue = Ctypes.field t "depthClearValue" Ctypes.float

  (** [WGPURenderPassDepthStencilAttachment depthReadOnly] : [Unsigned.UInt32.t] *)
  let depthReadOnly = Ctypes.field t "depthReadOnly" Ctypes.uint32_t

  (** [WGPURenderPassDepthStencilAttachment stencilLoadOp] : [LoadOp.t] *)
  let stencilLoadOp = Ctypes.field t "stencilLoadOp" LoadOp.t

  (** [WGPURenderPassDepthStencilAttachment stencilStoreOp] : [StoreOp.t] *)
  let stencilStoreOp = Ctypes.field t "stencilStoreOp" StoreOp.t

  (** [WGPURenderPassDepthStencilAttachment stencilClearValue] : [Unsigned.UInt32.t] *)
  let stencilClearValue = Ctypes.field t "stencilClearValue" Ctypes.uint32_t

  (** [WGPURenderPassDepthStencilAttachment stencilReadOnly] : [Unsigned.UInt32.t] *)
  let stencilReadOnly = Ctypes.field t "stencilReadOnly" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "view"; "depthLoadOp"; "depthStoreOp"; "depthClearValue"; "depthReadOnly"; "stencilLoadOp"; "stencilStoreOp"; "stencilClearValue"; "stencilReadOnly"; ]

  (** A fresh value carrying the defaults of the header's [RENDER_PASS_DEPTH_STENCIL_ATTACHMENT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v depthLoadOp (LoadOp.undefined);
    Ctypes.setf v depthStoreOp (StoreOp.undefined);
    Ctypes.setf v depthClearValue (Constants.depth_clear_value_undefined);
    Ctypes.setf v depthReadOnly (Constants.false_);
    Ctypes.setf v stencilLoadOp (LoadOp.undefined);
    Ctypes.setf v stencilStoreOp (StoreOp.undefined);
    Ctypes.setf v stencilReadOnly (Constants.false_);
    v
end

(** [WGPURenderPassMaxDrawCount] (from webgpu.h) *)
module RenderPassMaxDrawCount = struct
  let c_name = "WGPURenderPassMaxDrawCount"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURenderPassMaxDrawCount"

  (** [WGPURenderPassMaxDrawCount chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPURenderPassMaxDrawCount maxDrawCount] : [Unsigned.UInt64.t] *)
  let maxDrawCount = Ctypes.field t "maxDrawCount" Ctypes.uint64_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "maxDrawCount"; ]

  (** A fresh value carrying the defaults of the header's [RENDER_PASS_MAX_DRAW_COUNT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.render_pass_max_draw_count);  s);
    Ctypes.setf v maxDrawCount (Unsigned.UInt64.of_int64 50000000L);
    v
end

(** [WGPURequestAdapterWebXROptions] (from webgpu.h) *)
module RequestAdapterWebXROptions = struct
  let c_name = "WGPURequestAdapterWebXROptions"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURequestAdapterWebXROptions"

  (** [WGPURequestAdapterWebXROptions chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPURequestAdapterWebXROptions xrCompatible] : [Unsigned.UInt32.t] *)
  let xrCompatible = Ctypes.field t "xrCompatible" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "xrCompatible"; ]

  (** A fresh value carrying the defaults of the header's [REQUEST_ADAPTER_WEB_XR_OPTIONS_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.request_adapter_web_xr_options);  s);
    Ctypes.setf v xrCompatible (Constants.false_);
    v
end

(** [WGPUSamplerBindingLayout] (from webgpu.h) *)
module SamplerBindingLayout = struct
  let c_name = "WGPUSamplerBindingLayout"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSamplerBindingLayout"

  (** [WGPUSamplerBindingLayout nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUSamplerBindingLayout type] : [SamplerBindingType.t] *)
  let type_ = Ctypes.field t "type" SamplerBindingType.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "type"; ]

  (** A fresh value carrying the defaults of the header's [SAMPLER_BINDING_LAYOUT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v type_ (SamplerBindingType.undefined);
    v
end

(** [WGPUSamplerDescriptor] (from webgpu.h) *)
module SamplerDescriptor = struct
  let c_name = "WGPUSamplerDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSamplerDescriptor"

  (** [WGPUSamplerDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUSamplerDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUSamplerDescriptor addressModeU] : [AddressMode.t] *)
  let addressModeU = Ctypes.field t "addressModeU" AddressMode.t

  (** [WGPUSamplerDescriptor addressModeV] : [AddressMode.t] *)
  let addressModeV = Ctypes.field t "addressModeV" AddressMode.t

  (** [WGPUSamplerDescriptor addressModeW] : [AddressMode.t] *)
  let addressModeW = Ctypes.field t "addressModeW" AddressMode.t

  (** [WGPUSamplerDescriptor magFilter] : [FilterMode.t] *)
  let magFilter = Ctypes.field t "magFilter" FilterMode.t

  (** [WGPUSamplerDescriptor minFilter] : [FilterMode.t] *)
  let minFilter = Ctypes.field t "minFilter" FilterMode.t

  (** [WGPUSamplerDescriptor mipmapFilter] : [MipmapFilterMode.t] *)
  let mipmapFilter = Ctypes.field t "mipmapFilter" MipmapFilterMode.t

  (** [WGPUSamplerDescriptor lodMinClamp] : [float] *)
  let lodMinClamp = Ctypes.field t "lodMinClamp" Ctypes.float

  (** [WGPUSamplerDescriptor lodMaxClamp] : [float] *)
  let lodMaxClamp = Ctypes.field t "lodMaxClamp" Ctypes.float

  (** [WGPUSamplerDescriptor compare] : [CompareFunction.t] *)
  let compare = Ctypes.field t "compare" CompareFunction.t

  (** [WGPUSamplerDescriptor maxAnisotropy] : [Unsigned.UInt16.t] *)
  let maxAnisotropy = Ctypes.field t "maxAnisotropy" Ctypes.uint16_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "addressModeU"; "addressModeV"; "addressModeW"; "magFilter"; "minFilter"; "mipmapFilter"; "lodMinClamp"; "lodMaxClamp"; "compare"; "maxAnisotropy"; ]

  (** A fresh value carrying the defaults of the header's [SAMPLER_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    Ctypes.setf v addressModeU (AddressMode.undefined);
    Ctypes.setf v addressModeV (AddressMode.undefined);
    Ctypes.setf v addressModeW (AddressMode.undefined);
    Ctypes.setf v magFilter (FilterMode.undefined);
    Ctypes.setf v minFilter (FilterMode.undefined);
    Ctypes.setf v mipmapFilter (MipmapFilterMode.undefined);
    Ctypes.setf v lodMaxClamp (0x1p+5);
    Ctypes.setf v compare (CompareFunction.undefined);
    Ctypes.setf v maxAnisotropy (Unsigned.UInt16.of_int 1);
    v
end

(** [WGPUShaderSourceSPIRV] (from webgpu.h) *)
module ShaderSourceSPIRV = struct
  let c_name = "WGPUShaderSourceSPIRV"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUShaderSourceSPIRV"

  (** [WGPUShaderSourceSPIRV chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUShaderSourceSPIRV codeSize] : [Unsigned.UInt32.t] *)
  let codeSize = Ctypes.field t "codeSize" Ctypes.uint32_t

  (** [WGPUShaderSourceSPIRV code] : [Unsigned.UInt32.t Ctypes.ptr] *)
  let code = Ctypes.field t "code" (Ctypes.ptr Ctypes.uint32_t)

  let () = Ctypes.seal t

  let field_names = [ "chain"; "codeSize"; "code"; ]

  (** A fresh value carrying the defaults of the header's [SHADER_SOURCE_SPIRV_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.shader_source_spirv);  s);
    v
end

(** [WGPUShaderSourceWGSL] (from webgpu.h) *)
module ShaderSourceWGSL = struct
  let c_name = "WGPUShaderSourceWGSL"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUShaderSourceWGSL"

  (** [WGPUShaderSourceWGSL chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUShaderSourceWGSL code] : [StringView.t] *)
  let code = Ctypes.field t "code" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "code"; ]

  (** A fresh value carrying the defaults of the header's [SHADER_SOURCE_WGSL_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.shader_source_wgsl);  s);
    Ctypes.setf v code (StringView.init ());
    v
end

(** [WGPUStencilFaceState] (from webgpu.h) *)
module StencilFaceState = struct
  let c_name = "WGPUStencilFaceState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUStencilFaceState"

  (** [WGPUStencilFaceState compare] : [CompareFunction.t] *)
  let compare = Ctypes.field t "compare" CompareFunction.t

  (** [WGPUStencilFaceState failOp] : [StencilOperation.t] *)
  let failOp = Ctypes.field t "failOp" StencilOperation.t

  (** [WGPUStencilFaceState depthFailOp] : [StencilOperation.t] *)
  let depthFailOp = Ctypes.field t "depthFailOp" StencilOperation.t

  (** [WGPUStencilFaceState passOp] : [StencilOperation.t] *)
  let passOp = Ctypes.field t "passOp" StencilOperation.t

  let () = Ctypes.seal t

  let field_names = [ "compare"; "failOp"; "depthFailOp"; "passOp"; ]

  (** A fresh value carrying the defaults of the header's [STENCIL_FACE_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v compare (CompareFunction.undefined);
    Ctypes.setf v failOp (StencilOperation.undefined);
    Ctypes.setf v depthFailOp (StencilOperation.undefined);
    Ctypes.setf v passOp (StencilOperation.undefined);
    v
end

(** [WGPUStorageTextureBindingLayout] (from webgpu.h) *)
module StorageTextureBindingLayout = struct
  let c_name = "WGPUStorageTextureBindingLayout"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUStorageTextureBindingLayout"

  (** [WGPUStorageTextureBindingLayout nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUStorageTextureBindingLayout access] : [StorageTextureAccess.t] *)
  let access = Ctypes.field t "access" StorageTextureAccess.t

  (** [WGPUStorageTextureBindingLayout format] : [TextureFormat.t] *)
  let format = Ctypes.field t "format" TextureFormat.t

  (** [WGPUStorageTextureBindingLayout viewDimension] : [TextureViewDimension.t] *)
  let viewDimension = Ctypes.field t "viewDimension" TextureViewDimension.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "access"; "format"; "viewDimension"; ]

  (** A fresh value carrying the defaults of the header's [STORAGE_TEXTURE_BINDING_LAYOUT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v access (StorageTextureAccess.undefined);
    Ctypes.setf v format (TextureFormat.undefined);
    Ctypes.setf v viewDimension (TextureViewDimension.undefined);
    v
end

(** [WGPUSupportedFeatures] (from webgpu.h) *)
module SupportedFeatures = struct
  let c_name = "WGPUSupportedFeatures"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSupportedFeatures"

  (** [WGPUSupportedFeatures featureCount] : [Unsigned.Size_t.t] *)
  let featureCount = Ctypes.field t "featureCount" Ctypes.size_t

  (** [WGPUSupportedFeatures features] : [FeatureName.t Ctypes.ptr] *)
  let features = Ctypes.field t "features" (Ctypes.ptr FeatureName.t)

  let () = Ctypes.seal t

  let field_names = [ "featureCount"; "features"; ]

  (** A fresh value carrying the defaults of the header's [SUPPORTED_FEATURES_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUSupportedInstanceFeatures] (from webgpu.h) *)
module SupportedInstanceFeatures = struct
  let c_name = "WGPUSupportedInstanceFeatures"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSupportedInstanceFeatures"

  (** [WGPUSupportedInstanceFeatures featureCount] : [Unsigned.Size_t.t] *)
  let featureCount = Ctypes.field t "featureCount" Ctypes.size_t

  (** [WGPUSupportedInstanceFeatures features] : [InstanceFeatureName.t Ctypes.ptr] *)
  let features = Ctypes.field t "features" (Ctypes.ptr InstanceFeatureName.t)

  let () = Ctypes.seal t

  let field_names = [ "featureCount"; "features"; ]

  (** A fresh value carrying the defaults of the header's [SUPPORTED_INSTANCE_FEATURES_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUSupportedWGSLLanguageFeatures] (from webgpu.h) *)
module SupportedWGSLLanguageFeatures = struct
  let c_name = "WGPUSupportedWGSLLanguageFeatures"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSupportedWGSLLanguageFeatures"

  (** [WGPUSupportedWGSLLanguageFeatures featureCount] : [Unsigned.Size_t.t] *)
  let featureCount = Ctypes.field t "featureCount" Ctypes.size_t

  (** [WGPUSupportedWGSLLanguageFeatures features] : [WGSLLanguageFeatureName.t Ctypes.ptr] *)
  let features = Ctypes.field t "features" (Ctypes.ptr WGSLLanguageFeatureName.t)

  let () = Ctypes.seal t

  let field_names = [ "featureCount"; "features"; ]

  (** A fresh value carrying the defaults of the header's [SUPPORTED_WGSL_LANGUAGE_FEATURES_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUSurfaceCapabilities] (from webgpu.h) *)
module SurfaceCapabilities = struct
  let c_name = "WGPUSurfaceCapabilities"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceCapabilities"

  (** [WGPUSurfaceCapabilities nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUSurfaceCapabilities usages] : [TextureUsage.t] *)
  let usages = Ctypes.field t "usages" TextureUsage.t

  (** [WGPUSurfaceCapabilities formatCount] : [Unsigned.Size_t.t] *)
  let formatCount = Ctypes.field t "formatCount" Ctypes.size_t

  (** [WGPUSurfaceCapabilities formats] : [TextureFormat.t Ctypes.ptr] *)
  let formats = Ctypes.field t "formats" (Ctypes.ptr TextureFormat.t)

  (** [WGPUSurfaceCapabilities presentModeCount] : [Unsigned.Size_t.t] *)
  let presentModeCount = Ctypes.field t "presentModeCount" Ctypes.size_t

  (** [WGPUSurfaceCapabilities presentModes] : [PresentMode.t Ctypes.ptr] *)
  let presentModes = Ctypes.field t "presentModes" (Ctypes.ptr PresentMode.t)

  (** [WGPUSurfaceCapabilities alphaModeCount] : [Unsigned.Size_t.t] *)
  let alphaModeCount = Ctypes.field t "alphaModeCount" Ctypes.size_t

  (** [WGPUSurfaceCapabilities alphaModes] : [CompositeAlphaMode.t Ctypes.ptr] *)
  let alphaModes = Ctypes.field t "alphaModes" (Ctypes.ptr CompositeAlphaMode.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "usages"; "formatCount"; "formats"; "presentModeCount"; "presentModes"; "alphaModeCount"; "alphaModes"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_CAPABILITIES_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v usages (TextureUsage.none);
    v
end

(** [WGPUSurfaceColorManagement] (from webgpu.h) *)
module SurfaceColorManagement = struct
  let c_name = "WGPUSurfaceColorManagement"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceColorManagement"

  (** [WGPUSurfaceColorManagement chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceColorManagement colorSpace] : [PredefinedColorSpace.t] *)
  let colorSpace = Ctypes.field t "colorSpace" PredefinedColorSpace.t

  (** [WGPUSurfaceColorManagement toneMappingMode] : [ToneMappingMode.t] *)
  let toneMappingMode = Ctypes.field t "toneMappingMode" ToneMappingMode.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "colorSpace"; "toneMappingMode"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_COLOR_MANAGEMENT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.surface_color_management);  s);
    v
end

(** [WGPUSurfaceConfiguration] (from webgpu.h) *)
module SurfaceConfiguration = struct
  let c_name = "WGPUSurfaceConfiguration"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceConfiguration"

  (** [WGPUSurfaceConfiguration nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUSurfaceConfiguration device] : [Device.t] *)
  let device = Ctypes.field t "device" Device.t

  (** [WGPUSurfaceConfiguration format] : [TextureFormat.t] *)
  let format = Ctypes.field t "format" TextureFormat.t

  (** [WGPUSurfaceConfiguration usage] : [TextureUsage.t] *)
  let usage = Ctypes.field t "usage" TextureUsage.t

  (** [WGPUSurfaceConfiguration width] : [Unsigned.UInt32.t] *)
  let width = Ctypes.field t "width" Ctypes.uint32_t

  (** [WGPUSurfaceConfiguration height] : [Unsigned.UInt32.t] *)
  let height = Ctypes.field t "height" Ctypes.uint32_t

  (** [WGPUSurfaceConfiguration viewFormatCount] : [Unsigned.Size_t.t] *)
  let viewFormatCount = Ctypes.field t "viewFormatCount" Ctypes.size_t

  (** [WGPUSurfaceConfiguration viewFormats] : [TextureFormat.t Ctypes.ptr] *)
  let viewFormats = Ctypes.field t "viewFormats" (Ctypes.ptr TextureFormat.t)

  (** [WGPUSurfaceConfiguration alphaMode] : [CompositeAlphaMode.t] *)
  let alphaMode = Ctypes.field t "alphaMode" CompositeAlphaMode.t

  (** [WGPUSurfaceConfiguration presentMode] : [PresentMode.t] *)
  let presentMode = Ctypes.field t "presentMode" PresentMode.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "device"; "format"; "usage"; "width"; "height"; "viewFormatCount"; "viewFormats"; "alphaMode"; "presentMode"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_CONFIGURATION_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v format (TextureFormat.undefined);
    Ctypes.setf v usage (TextureUsage.render_attachment);
    Ctypes.setf v alphaMode (CompositeAlphaMode.auto);
    Ctypes.setf v presentMode (PresentMode.undefined);
    v
end

(** [WGPUSurfaceSourceAndroidNativeWindow] (from webgpu.h) *)
module SurfaceSourceAndroidNativeWindow = struct
  let c_name = "WGPUSurfaceSourceAndroidNativeWindow"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceSourceAndroidNativeWindow"

  (** [WGPUSurfaceSourceAndroidNativeWindow chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceSourceAndroidNativeWindow window] : [unit Ctypes.ptr] *)
  let window = Ctypes.field t "window" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "chain"; "window"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_SOURCE_ANDROID_NATIVE_WINDOW_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.surface_source_android_native_window);  s);
    v
end

(** [WGPUSurfaceSourceMetalLayer] (from webgpu.h) *)
module SurfaceSourceMetalLayer = struct
  let c_name = "WGPUSurfaceSourceMetalLayer"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceSourceMetalLayer"

  (** [WGPUSurfaceSourceMetalLayer chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceSourceMetalLayer layer] : [unit Ctypes.ptr] *)
  let layer = Ctypes.field t "layer" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "chain"; "layer"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_SOURCE_METAL_LAYER_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.surface_source_metal_layer);  s);
    v
end

(** [WGPUSurfaceSourceWaylandSurface] (from webgpu.h) *)
module SurfaceSourceWaylandSurface = struct
  let c_name = "WGPUSurfaceSourceWaylandSurface"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceSourceWaylandSurface"

  (** [WGPUSurfaceSourceWaylandSurface chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceSourceWaylandSurface display] : [unit Ctypes.ptr] *)
  let display = Ctypes.field t "display" (Ctypes.ptr Ctypes.void)

  (** [WGPUSurfaceSourceWaylandSurface surface] : [unit Ctypes.ptr] *)
  let surface = Ctypes.field t "surface" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "chain"; "display"; "surface"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_SOURCE_WAYLAND_SURFACE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.surface_source_wayland_surface);  s);
    v
end

(** [WGPUSurfaceSourceWindowsHWND] (from webgpu.h) *)
module SurfaceSourceWindowsHWND = struct
  let c_name = "WGPUSurfaceSourceWindowsHWND"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceSourceWindowsHWND"

  (** [WGPUSurfaceSourceWindowsHWND chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceSourceWindowsHWND hinstance] : [unit Ctypes.ptr] *)
  let hinstance = Ctypes.field t "hinstance" (Ctypes.ptr Ctypes.void)

  (** [WGPUSurfaceSourceWindowsHWND hwnd] : [unit Ctypes.ptr] *)
  let hwnd = Ctypes.field t "hwnd" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "chain"; "hinstance"; "hwnd"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_SOURCE_WINDOWS_HWND_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.surface_source_windows_hwnd);  s);
    v
end

(** [WGPUSurfaceSourceXCBWindow] (from webgpu.h) *)
module SurfaceSourceXCBWindow = struct
  let c_name = "WGPUSurfaceSourceXCBWindow"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceSourceXCBWindow"

  (** [WGPUSurfaceSourceXCBWindow chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceSourceXCBWindow connection] : [unit Ctypes.ptr] *)
  let connection = Ctypes.field t "connection" (Ctypes.ptr Ctypes.void)

  (** [WGPUSurfaceSourceXCBWindow window] : [Unsigned.UInt32.t] *)
  let window = Ctypes.field t "window" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "connection"; "window"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_SOURCE_XCB_WINDOW_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.surface_source_xcb_window);  s);
    v
end

(** [WGPUSurfaceSourceXlibWindow] (from webgpu.h) *)
module SurfaceSourceXlibWindow = struct
  let c_name = "WGPUSurfaceSourceXlibWindow"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceSourceXlibWindow"

  (** [WGPUSurfaceSourceXlibWindow chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceSourceXlibWindow display] : [unit Ctypes.ptr] *)
  let display = Ctypes.field t "display" (Ctypes.ptr Ctypes.void)

  (** [WGPUSurfaceSourceXlibWindow window] : [Unsigned.UInt64.t] *)
  let window = Ctypes.field t "window" Ctypes.uint64_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "display"; "window"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_SOURCE_XLIB_WINDOW_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.surface_source_xlib_window);  s);
    v
end

(** [WGPUSurfaceTexture] (from webgpu.h) *)
module SurfaceTexture = struct
  let c_name = "WGPUSurfaceTexture"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceTexture"

  (** [WGPUSurfaceTexture nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUSurfaceTexture texture] : [Texture.t] *)
  let texture = Ctypes.field t "texture" Texture.t

  (** [WGPUSurfaceTexture status] : [SurfaceGetCurrentTextureStatus.t] *)
  let status = Ctypes.field t "status" SurfaceGetCurrentTextureStatus.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "texture"; "status"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_TEXTURE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUTexelCopyBufferLayout] (from webgpu.h) *)
module TexelCopyBufferLayout = struct
  let c_name = "WGPUTexelCopyBufferLayout"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTexelCopyBufferLayout"

  (** [WGPUTexelCopyBufferLayout offset] : [Unsigned.UInt64.t] *)
  let offset = Ctypes.field t "offset" Ctypes.uint64_t

  (** [WGPUTexelCopyBufferLayout bytesPerRow] : [Unsigned.UInt32.t] *)
  let bytesPerRow = Ctypes.field t "bytesPerRow" Ctypes.uint32_t

  (** [WGPUTexelCopyBufferLayout rowsPerImage] : [Unsigned.UInt32.t] *)
  let rowsPerImage = Ctypes.field t "rowsPerImage" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "offset"; "bytesPerRow"; "rowsPerImage"; ]

  (** A fresh value carrying the defaults of the header's [TEXEL_COPY_BUFFER_LAYOUT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v bytesPerRow (Constants.copy_stride_undefined);
    Ctypes.setf v rowsPerImage (Constants.copy_stride_undefined);
    v
end

(** [WGPUTextureBindingLayout] (from webgpu.h) *)
module TextureBindingLayout = struct
  let c_name = "WGPUTextureBindingLayout"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTextureBindingLayout"

  (** [WGPUTextureBindingLayout nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUTextureBindingLayout sampleType] : [TextureSampleType.t] *)
  let sampleType = Ctypes.field t "sampleType" TextureSampleType.t

  (** [WGPUTextureBindingLayout viewDimension] : [TextureViewDimension.t] *)
  let viewDimension = Ctypes.field t "viewDimension" TextureViewDimension.t

  (** [WGPUTextureBindingLayout multisampled] : [Unsigned.UInt32.t] *)
  let multisampled = Ctypes.field t "multisampled" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "sampleType"; "viewDimension"; "multisampled"; ]

  (** A fresh value carrying the defaults of the header's [TEXTURE_BINDING_LAYOUT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v sampleType (TextureSampleType.undefined);
    Ctypes.setf v viewDimension (TextureViewDimension.undefined);
    Ctypes.setf v multisampled (Constants.false_);
    v
end

(** [WGPUTextureBindingViewDimension] (from webgpu.h) *)
module TextureBindingViewDimension = struct
  let c_name = "WGPUTextureBindingViewDimension"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTextureBindingViewDimension"

  (** [WGPUTextureBindingViewDimension chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUTextureBindingViewDimension textureBindingViewDimension] : [TextureViewDimension.t] *)
  let textureBindingViewDimension = Ctypes.field t "textureBindingViewDimension" TextureViewDimension.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "textureBindingViewDimension"; ]

  (** A fresh value carrying the defaults of the header's [TEXTURE_BINDING_VIEW_DIMENSION_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.texture_binding_view_dimension);  s);
    Ctypes.setf v textureBindingViewDimension (TextureViewDimension.undefined);
    v
end

(** [WGPUTextureComponentSwizzle] (from webgpu.h) *)
module TextureComponentSwizzle = struct
  let c_name = "WGPUTextureComponentSwizzle"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTextureComponentSwizzle"

  (** [WGPUTextureComponentSwizzle r] : [ComponentSwizzle.t] *)
  let r = Ctypes.field t "r" ComponentSwizzle.t

  (** [WGPUTextureComponentSwizzle g] : [ComponentSwizzle.t] *)
  let g = Ctypes.field t "g" ComponentSwizzle.t

  (** [WGPUTextureComponentSwizzle b] : [ComponentSwizzle.t] *)
  let b = Ctypes.field t "b" ComponentSwizzle.t

  (** [WGPUTextureComponentSwizzle a] : [ComponentSwizzle.t] *)
  let a = Ctypes.field t "a" ComponentSwizzle.t

  let () = Ctypes.seal t

  let field_names = [ "r"; "g"; "b"; "a"; ]

  (** A fresh value carrying the defaults of the header's [TEXTURE_COMPONENT_SWIZZLE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v r (ComponentSwizzle.undefined);
    Ctypes.setf v g (ComponentSwizzle.undefined);
    Ctypes.setf v b (ComponentSwizzle.undefined);
    Ctypes.setf v a (ComponentSwizzle.undefined);
    v
end

(** [WGPUVertexAttribute] (from webgpu.h) *)
module VertexAttribute = struct
  let c_name = "WGPUVertexAttribute"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUVertexAttribute"

  (** [WGPUVertexAttribute nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUVertexAttribute format] : [VertexFormat.t] *)
  let format = Ctypes.field t "format" VertexFormat.t

  (** [WGPUVertexAttribute offset] : [Unsigned.UInt64.t] *)
  let offset = Ctypes.field t "offset" Ctypes.uint64_t

  (** [WGPUVertexAttribute shaderLocation] : [Unsigned.UInt32.t] *)
  let shaderLocation = Ctypes.field t "shaderLocation" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "format"; "offset"; "shaderLocation"; ]

  (** A fresh value carrying the defaults of the header's [VERTEX_ATTRIBUTE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPUBindGroupEntry] (from webgpu.h) *)
module BindGroupEntry = struct
  let c_name = "WGPUBindGroupEntry"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBindGroupEntry"

  (** [WGPUBindGroupEntry nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUBindGroupEntry binding] : [Unsigned.UInt32.t] *)
  let binding = Ctypes.field t "binding" Ctypes.uint32_t

  (** [WGPUBindGroupEntry buffer] : [Buffer.t] *)
  let buffer = Ctypes.field t "buffer" Buffer.t

  (** [WGPUBindGroupEntry offset] : [Unsigned.UInt64.t] *)
  let offset = Ctypes.field t "offset" Ctypes.uint64_t

  (** [WGPUBindGroupEntry size] : [Unsigned.UInt64.t] *)
  let size = Ctypes.field t "size" Ctypes.uint64_t

  (** [WGPUBindGroupEntry sampler] : [Sampler.t] *)
  let sampler = Ctypes.field t "sampler" Sampler.t

  (** [WGPUBindGroupEntry textureView] : [TextureView.t] *)
  let textureView = Ctypes.field t "textureView" TextureView.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "binding"; "buffer"; "offset"; "size"; "sampler"; "textureView"; ]

  (** A fresh value carrying the defaults of the header's [BIND_GROUP_ENTRY_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v size (Constants.whole_size);
    v
end

(** [WGPUBindGroupLayoutEntry] (from webgpu.h) *)
module BindGroupLayoutEntry = struct
  let c_name = "WGPUBindGroupLayoutEntry"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBindGroupLayoutEntry"

  (** [WGPUBindGroupLayoutEntry nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUBindGroupLayoutEntry binding] : [Unsigned.UInt32.t] *)
  let binding = Ctypes.field t "binding" Ctypes.uint32_t

  (** [WGPUBindGroupLayoutEntry visibility] : [ShaderStage.t] *)
  let visibility = Ctypes.field t "visibility" ShaderStage.t

  (** [WGPUBindGroupLayoutEntry bindingArraySize] : [Unsigned.UInt32.t] *)
  let bindingArraySize = Ctypes.field t "bindingArraySize" Ctypes.uint32_t

  (** [WGPUBindGroupLayoutEntry buffer] : [BufferBindingLayout.t] *)
  let buffer = Ctypes.field t "buffer" BufferBindingLayout.t

  (** [WGPUBindGroupLayoutEntry sampler] : [SamplerBindingLayout.t] *)
  let sampler = Ctypes.field t "sampler" SamplerBindingLayout.t

  (** [WGPUBindGroupLayoutEntry texture] : [TextureBindingLayout.t] *)
  let texture = Ctypes.field t "texture" TextureBindingLayout.t

  (** [WGPUBindGroupLayoutEntry storageTexture] : [StorageTextureBindingLayout.t] *)
  let storageTexture = Ctypes.field t "storageTexture" StorageTextureBindingLayout.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "binding"; "visibility"; "bindingArraySize"; "buffer"; "sampler"; "texture"; "storageTexture"; ]

  (** A fresh value carrying the defaults of the header's [BIND_GROUP_LAYOUT_ENTRY_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v visibility (ShaderStage.none);
    v
end

(** [WGPUBlendState] (from webgpu.h) *)
module BlendState = struct
  let c_name = "WGPUBlendState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBlendState"

  (** [WGPUBlendState color] : [BlendComponent.t] *)
  let color = Ctypes.field t "color" BlendComponent.t

  (** [WGPUBlendState alpha] : [BlendComponent.t] *)
  let alpha = Ctypes.field t "alpha" BlendComponent.t

  let () = Ctypes.seal t

  let field_names = [ "color"; "alpha"; ]

  (** A fresh value carrying the defaults of the header's [BLEND_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v color (BlendComponent.init ());
    Ctypes.setf v alpha (BlendComponent.init ());
    v
end

(** [WGPUComputePassDescriptor] (from webgpu.h) *)
module ComputePassDescriptor = struct
  let c_name = "WGPUComputePassDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUComputePassDescriptor"

  (** [WGPUComputePassDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUComputePassDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUComputePassDescriptor timestampWrites] : [PassTimestampWrites.t Ctypes.ptr] *)
  let timestampWrites = Ctypes.field t "timestampWrites" (Ctypes.ptr PassTimestampWrites.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "timestampWrites"; ]

  (** A fresh value carrying the defaults of the header's [COMPUTE_PASS_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUComputeState] (from webgpu.h) *)
module ComputeState = struct
  let c_name = "WGPUComputeState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUComputeState"

  (** [WGPUComputeState nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUComputeState module] : [ShaderModule.t] *)
  let module_ = Ctypes.field t "module" ShaderModule.t

  (** [WGPUComputeState entryPoint] : [StringView.t] *)
  let entryPoint = Ctypes.field t "entryPoint" StringView.t

  (** [WGPUComputeState constantCount] : [Unsigned.Size_t.t] *)
  let constantCount = Ctypes.field t "constantCount" Ctypes.size_t

  (** [WGPUComputeState constants] : [ConstantEntry.t Ctypes.ptr] *)
  let constants = Ctypes.field t "constants" (Ctypes.ptr ConstantEntry.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "module"; "entryPoint"; "constantCount"; "constants"; ]

  (** A fresh value carrying the defaults of the header's [COMPUTE_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v entryPoint (StringView.init ());
    v
end

(** [WGPUDepthStencilState] (from webgpu.h) *)
module DepthStencilState = struct
  let c_name = "WGPUDepthStencilState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUDepthStencilState"

  (** [WGPUDepthStencilState nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUDepthStencilState format] : [TextureFormat.t] *)
  let format = Ctypes.field t "format" TextureFormat.t

  (** [WGPUDepthStencilState depthWriteEnabled] : [OptionalBool.t] *)
  let depthWriteEnabled = Ctypes.field t "depthWriteEnabled" OptionalBool.t

  (** [WGPUDepthStencilState depthCompare] : [CompareFunction.t] *)
  let depthCompare = Ctypes.field t "depthCompare" CompareFunction.t

  (** [WGPUDepthStencilState stencilFront] : [StencilFaceState.t] *)
  let stencilFront = Ctypes.field t "stencilFront" StencilFaceState.t

  (** [WGPUDepthStencilState stencilBack] : [StencilFaceState.t] *)
  let stencilBack = Ctypes.field t "stencilBack" StencilFaceState.t

  (** [WGPUDepthStencilState stencilReadMask] : [Unsigned.UInt32.t] *)
  let stencilReadMask = Ctypes.field t "stencilReadMask" Ctypes.uint32_t

  (** [WGPUDepthStencilState stencilWriteMask] : [Unsigned.UInt32.t] *)
  let stencilWriteMask = Ctypes.field t "stencilWriteMask" Ctypes.uint32_t

  (** [WGPUDepthStencilState depthBias] : [int32] *)
  let depthBias = Ctypes.field t "depthBias" Ctypes.int32_t

  (** [WGPUDepthStencilState depthBiasSlopeScale] : [float] *)
  let depthBiasSlopeScale = Ctypes.field t "depthBiasSlopeScale" Ctypes.float

  (** [WGPUDepthStencilState depthBiasClamp] : [float] *)
  let depthBiasClamp = Ctypes.field t "depthBiasClamp" Ctypes.float

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "format"; "depthWriteEnabled"; "depthCompare"; "stencilFront"; "stencilBack"; "stencilReadMask"; "stencilWriteMask"; "depthBias"; "depthBiasSlopeScale"; "depthBiasClamp"; ]

  (** A fresh value carrying the defaults of the header's [DEPTH_STENCIL_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v format (TextureFormat.undefined);
    Ctypes.setf v depthWriteEnabled (OptionalBool.undefined);
    Ctypes.setf v depthCompare (CompareFunction.undefined);
    Ctypes.setf v stencilFront (StencilFaceState.init ());
    Ctypes.setf v stencilBack (StencilFaceState.init ());
    Ctypes.setf v stencilReadMask (Unsigned.UInt32.of_int 4294967295);
    Ctypes.setf v stencilWriteMask (Unsigned.UInt32.of_int 4294967295);
    v
end

(** [WGPUFutureWaitInfo] (from webgpu.h) *)
module FutureWaitInfo = struct
  let c_name = "WGPUFutureWaitInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUFutureWaitInfo"

  (** [WGPUFutureWaitInfo future] : [Future.t] *)
  let future = Ctypes.field t "future" Future.t

  (** [WGPUFutureWaitInfo completed] : [Unsigned.UInt32.t] *)
  let completed = Ctypes.field t "completed" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "future"; "completed"; ]

  (** A fresh value carrying the defaults of the header's [FUTURE_WAIT_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v future (Future.init ());
    Ctypes.setf v completed (Constants.false_);
    v
end

(** [WGPUInstanceDescriptor] (from webgpu.h) *)
module InstanceDescriptor = struct
  let c_name = "WGPUInstanceDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUInstanceDescriptor"

  (** [WGPUInstanceDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUInstanceDescriptor requiredFeatureCount] : [Unsigned.Size_t.t] *)
  let requiredFeatureCount = Ctypes.field t "requiredFeatureCount" Ctypes.size_t

  (** [WGPUInstanceDescriptor requiredFeatures] : [InstanceFeatureName.t Ctypes.ptr] *)
  let requiredFeatures = Ctypes.field t "requiredFeatures" (Ctypes.ptr InstanceFeatureName.t)

  (** [WGPUInstanceDescriptor requiredLimits] : [InstanceLimits.t Ctypes.ptr] *)
  let requiredLimits = Ctypes.field t "requiredLimits" (Ctypes.ptr InstanceLimits.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "requiredFeatureCount"; "requiredFeatures"; "requiredLimits"; ]

  (** A fresh value carrying the defaults of the header's [INSTANCE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    v
end

(** [WGPULimits] (from webgpu.h) *)
module Limits = struct
  let c_name = "WGPULimits"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPULimits"

  (** [WGPULimits nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPULimits maxTextureDimension1D] : [Unsigned.UInt32.t] *)
  let maxTextureDimension1D = Ctypes.field t "maxTextureDimension1D" Ctypes.uint32_t

  (** [WGPULimits maxTextureDimension2D] : [Unsigned.UInt32.t] *)
  let maxTextureDimension2D = Ctypes.field t "maxTextureDimension2D" Ctypes.uint32_t

  (** [WGPULimits maxTextureDimension3D] : [Unsigned.UInt32.t] *)
  let maxTextureDimension3D = Ctypes.field t "maxTextureDimension3D" Ctypes.uint32_t

  (** [WGPULimits maxTextureArrayLayers] : [Unsigned.UInt32.t] *)
  let maxTextureArrayLayers = Ctypes.field t "maxTextureArrayLayers" Ctypes.uint32_t

  (** [WGPULimits maxBindGroups] : [Unsigned.UInt32.t] *)
  let maxBindGroups = Ctypes.field t "maxBindGroups" Ctypes.uint32_t

  (** [WGPULimits maxBindGroupsPlusVertexBuffers] : [Unsigned.UInt32.t] *)
  let maxBindGroupsPlusVertexBuffers = Ctypes.field t "maxBindGroupsPlusVertexBuffers" Ctypes.uint32_t

  (** [WGPULimits maxBindingsPerBindGroup] : [Unsigned.UInt32.t] *)
  let maxBindingsPerBindGroup = Ctypes.field t "maxBindingsPerBindGroup" Ctypes.uint32_t

  (** [WGPULimits maxDynamicUniformBuffersPerPipelineLayout] : [Unsigned.UInt32.t] *)
  let maxDynamicUniformBuffersPerPipelineLayout = Ctypes.field t "maxDynamicUniformBuffersPerPipelineLayout" Ctypes.uint32_t

  (** [WGPULimits maxDynamicStorageBuffersPerPipelineLayout] : [Unsigned.UInt32.t] *)
  let maxDynamicStorageBuffersPerPipelineLayout = Ctypes.field t "maxDynamicStorageBuffersPerPipelineLayout" Ctypes.uint32_t

  (** [WGPULimits maxSampledTexturesPerShaderStage] : [Unsigned.UInt32.t] *)
  let maxSampledTexturesPerShaderStage = Ctypes.field t "maxSampledTexturesPerShaderStage" Ctypes.uint32_t

  (** [WGPULimits maxSamplersPerShaderStage] : [Unsigned.UInt32.t] *)
  let maxSamplersPerShaderStage = Ctypes.field t "maxSamplersPerShaderStage" Ctypes.uint32_t

  (** [WGPULimits maxStorageBuffersPerShaderStage] : [Unsigned.UInt32.t] *)
  let maxStorageBuffersPerShaderStage = Ctypes.field t "maxStorageBuffersPerShaderStage" Ctypes.uint32_t

  (** [WGPULimits maxStorageTexturesPerShaderStage] : [Unsigned.UInt32.t] *)
  let maxStorageTexturesPerShaderStage = Ctypes.field t "maxStorageTexturesPerShaderStage" Ctypes.uint32_t

  (** [WGPULimits maxUniformBuffersPerShaderStage] : [Unsigned.UInt32.t] *)
  let maxUniformBuffersPerShaderStage = Ctypes.field t "maxUniformBuffersPerShaderStage" Ctypes.uint32_t

  (** [WGPULimits maxUniformBufferBindingSize] : [Unsigned.UInt64.t] *)
  let maxUniformBufferBindingSize = Ctypes.field t "maxUniformBufferBindingSize" Ctypes.uint64_t

  (** [WGPULimits maxStorageBufferBindingSize] : [Unsigned.UInt64.t] *)
  let maxStorageBufferBindingSize = Ctypes.field t "maxStorageBufferBindingSize" Ctypes.uint64_t

  (** [WGPULimits minUniformBufferOffsetAlignment] : [Unsigned.UInt32.t] *)
  let minUniformBufferOffsetAlignment = Ctypes.field t "minUniformBufferOffsetAlignment" Ctypes.uint32_t

  (** [WGPULimits minStorageBufferOffsetAlignment] : [Unsigned.UInt32.t] *)
  let minStorageBufferOffsetAlignment = Ctypes.field t "minStorageBufferOffsetAlignment" Ctypes.uint32_t

  (** [WGPULimits maxVertexBuffers] : [Unsigned.UInt32.t] *)
  let maxVertexBuffers = Ctypes.field t "maxVertexBuffers" Ctypes.uint32_t

  (** [WGPULimits maxBufferSize] : [Unsigned.UInt64.t] *)
  let maxBufferSize = Ctypes.field t "maxBufferSize" Ctypes.uint64_t

  (** [WGPULimits maxVertexAttributes] : [Unsigned.UInt32.t] *)
  let maxVertexAttributes = Ctypes.field t "maxVertexAttributes" Ctypes.uint32_t

  (** [WGPULimits maxVertexBufferArrayStride] : [Unsigned.UInt32.t] *)
  let maxVertexBufferArrayStride = Ctypes.field t "maxVertexBufferArrayStride" Ctypes.uint32_t

  (** [WGPULimits maxInterStageShaderVariables] : [Unsigned.UInt32.t] *)
  let maxInterStageShaderVariables = Ctypes.field t "maxInterStageShaderVariables" Ctypes.uint32_t

  (** [WGPULimits maxColorAttachments] : [Unsigned.UInt32.t] *)
  let maxColorAttachments = Ctypes.field t "maxColorAttachments" Ctypes.uint32_t

  (** [WGPULimits maxColorAttachmentBytesPerSample] : [Unsigned.UInt32.t] *)
  let maxColorAttachmentBytesPerSample = Ctypes.field t "maxColorAttachmentBytesPerSample" Ctypes.uint32_t

  (** [WGPULimits maxComputeWorkgroupStorageSize] : [Unsigned.UInt32.t] *)
  let maxComputeWorkgroupStorageSize = Ctypes.field t "maxComputeWorkgroupStorageSize" Ctypes.uint32_t

  (** [WGPULimits maxComputeInvocationsPerWorkgroup] : [Unsigned.UInt32.t] *)
  let maxComputeInvocationsPerWorkgroup = Ctypes.field t "maxComputeInvocationsPerWorkgroup" Ctypes.uint32_t

  (** [WGPULimits maxComputeWorkgroupSizeX] : [Unsigned.UInt32.t] *)
  let maxComputeWorkgroupSizeX = Ctypes.field t "maxComputeWorkgroupSizeX" Ctypes.uint32_t

  (** [WGPULimits maxComputeWorkgroupSizeY] : [Unsigned.UInt32.t] *)
  let maxComputeWorkgroupSizeY = Ctypes.field t "maxComputeWorkgroupSizeY" Ctypes.uint32_t

  (** [WGPULimits maxComputeWorkgroupSizeZ] : [Unsigned.UInt32.t] *)
  let maxComputeWorkgroupSizeZ = Ctypes.field t "maxComputeWorkgroupSizeZ" Ctypes.uint32_t

  (** [WGPULimits maxComputeWorkgroupsPerDimension] : [Unsigned.UInt32.t] *)
  let maxComputeWorkgroupsPerDimension = Ctypes.field t "maxComputeWorkgroupsPerDimension" Ctypes.uint32_t

  (** [WGPULimits maxImmediateSize] : [Unsigned.UInt32.t] *)
  let maxImmediateSize = Ctypes.field t "maxImmediateSize" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "maxTextureDimension1D"; "maxTextureDimension2D"; "maxTextureDimension3D"; "maxTextureArrayLayers"; "maxBindGroups"; "maxBindGroupsPlusVertexBuffers"; "maxBindingsPerBindGroup"; "maxDynamicUniformBuffersPerPipelineLayout"; "maxDynamicStorageBuffersPerPipelineLayout"; "maxSampledTexturesPerShaderStage"; "maxSamplersPerShaderStage"; "maxStorageBuffersPerShaderStage"; "maxStorageTexturesPerShaderStage"; "maxUniformBuffersPerShaderStage"; "maxUniformBufferBindingSize"; "maxStorageBufferBindingSize"; "minUniformBufferOffsetAlignment"; "minStorageBufferOffsetAlignment"; "maxVertexBuffers"; "maxBufferSize"; "maxVertexAttributes"; "maxVertexBufferArrayStride"; "maxInterStageShaderVariables"; "maxColorAttachments"; "maxColorAttachmentBytesPerSample"; "maxComputeWorkgroupStorageSize"; "maxComputeInvocationsPerWorkgroup"; "maxComputeWorkgroupSizeX"; "maxComputeWorkgroupSizeY"; "maxComputeWorkgroupSizeZ"; "maxComputeWorkgroupsPerDimension"; "maxImmediateSize"; ]

  (** A fresh value carrying the defaults of the header's [LIMITS_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v maxTextureDimension1D (Constants.limit_u32_undefined);
    Ctypes.setf v maxTextureDimension2D (Constants.limit_u32_undefined);
    Ctypes.setf v maxTextureDimension3D (Constants.limit_u32_undefined);
    Ctypes.setf v maxTextureArrayLayers (Constants.limit_u32_undefined);
    Ctypes.setf v maxBindGroups (Constants.limit_u32_undefined);
    Ctypes.setf v maxBindGroupsPlusVertexBuffers (Constants.limit_u32_undefined);
    Ctypes.setf v maxBindingsPerBindGroup (Constants.limit_u32_undefined);
    Ctypes.setf v maxDynamicUniformBuffersPerPipelineLayout (Constants.limit_u32_undefined);
    Ctypes.setf v maxDynamicStorageBuffersPerPipelineLayout (Constants.limit_u32_undefined);
    Ctypes.setf v maxSampledTexturesPerShaderStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxSamplersPerShaderStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxStorageBuffersPerShaderStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxStorageTexturesPerShaderStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxUniformBuffersPerShaderStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxUniformBufferBindingSize (Constants.limit_u64_undefined);
    Ctypes.setf v maxStorageBufferBindingSize (Constants.limit_u64_undefined);
    Ctypes.setf v minUniformBufferOffsetAlignment (Constants.limit_u32_undefined);
    Ctypes.setf v minStorageBufferOffsetAlignment (Constants.limit_u32_undefined);
    Ctypes.setf v maxVertexBuffers (Constants.limit_u32_undefined);
    Ctypes.setf v maxBufferSize (Constants.limit_u64_undefined);
    Ctypes.setf v maxVertexAttributes (Constants.limit_u32_undefined);
    Ctypes.setf v maxVertexBufferArrayStride (Constants.limit_u32_undefined);
    Ctypes.setf v maxInterStageShaderVariables (Constants.limit_u32_undefined);
    Ctypes.setf v maxColorAttachments (Constants.limit_u32_undefined);
    Ctypes.setf v maxColorAttachmentBytesPerSample (Constants.limit_u32_undefined);
    Ctypes.setf v maxComputeWorkgroupStorageSize (Constants.limit_u32_undefined);
    Ctypes.setf v maxComputeInvocationsPerWorkgroup (Constants.limit_u32_undefined);
    Ctypes.setf v maxComputeWorkgroupSizeX (Constants.limit_u32_undefined);
    Ctypes.setf v maxComputeWorkgroupSizeY (Constants.limit_u32_undefined);
    Ctypes.setf v maxComputeWorkgroupSizeZ (Constants.limit_u32_undefined);
    Ctypes.setf v maxComputeWorkgroupsPerDimension (Constants.limit_u32_undefined);
    Ctypes.setf v maxImmediateSize (Constants.limit_u32_undefined);
    v
end

(** [WGPURenderPassColorAttachment] (from webgpu.h) *)
module RenderPassColorAttachment = struct
  let c_name = "WGPURenderPassColorAttachment"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURenderPassColorAttachment"

  (** [WGPURenderPassColorAttachment nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURenderPassColorAttachment view] : [TextureView.t] *)
  let view = Ctypes.field t "view" TextureView.t

  (** [WGPURenderPassColorAttachment depthSlice] : [Unsigned.UInt32.t] *)
  let depthSlice = Ctypes.field t "depthSlice" Ctypes.uint32_t

  (** [WGPURenderPassColorAttachment resolveTarget] : [TextureView.t] *)
  let resolveTarget = Ctypes.field t "resolveTarget" TextureView.t

  (** [WGPURenderPassColorAttachment loadOp] : [LoadOp.t] *)
  let loadOp = Ctypes.field t "loadOp" LoadOp.t

  (** [WGPURenderPassColorAttachment storeOp] : [StoreOp.t] *)
  let storeOp = Ctypes.field t "storeOp" StoreOp.t

  (** [WGPURenderPassColorAttachment clearValue] : [Color.t] *)
  let clearValue = Ctypes.field t "clearValue" Color.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "view"; "depthSlice"; "resolveTarget"; "loadOp"; "storeOp"; "clearValue"; ]

  (** A fresh value carrying the defaults of the header's [RENDER_PASS_COLOR_ATTACHMENT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v depthSlice (Constants.depth_slice_undefined);
    Ctypes.setf v loadOp (LoadOp.undefined);
    Ctypes.setf v storeOp (StoreOp.undefined);
    Ctypes.setf v clearValue (Color.init ());
    v
end

(** [WGPURequestAdapterOptions] (from webgpu.h) *)
module RequestAdapterOptions = struct
  let c_name = "WGPURequestAdapterOptions"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURequestAdapterOptions"

  (** [WGPURequestAdapterOptions nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURequestAdapterOptions featureLevel] : [FeatureLevel.t] *)
  let featureLevel = Ctypes.field t "featureLevel" FeatureLevel.t

  (** [WGPURequestAdapterOptions powerPreference] : [PowerPreference.t] *)
  let powerPreference = Ctypes.field t "powerPreference" PowerPreference.t

  (** [WGPURequestAdapterOptions forceFallbackAdapter] : [Unsigned.UInt32.t] *)
  let forceFallbackAdapter = Ctypes.field t "forceFallbackAdapter" Ctypes.uint32_t

  (** [WGPURequestAdapterOptions backendType] : [BackendType.t] *)
  let backendType = Ctypes.field t "backendType" BackendType.t

  (** [WGPURequestAdapterOptions compatibleSurface] : [Surface.t] *)
  let compatibleSurface = Ctypes.field t "compatibleSurface" Surface.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "featureLevel"; "powerPreference"; "forceFallbackAdapter"; "backendType"; "compatibleSurface"; ]

  (** A fresh value carrying the defaults of the header's [REQUEST_ADAPTER_OPTIONS_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v featureLevel (FeatureLevel.undefined);
    Ctypes.setf v powerPreference (PowerPreference.undefined);
    Ctypes.setf v forceFallbackAdapter (Constants.false_);
    Ctypes.setf v backendType (BackendType.undefined);
    v
end

(** [WGPUShaderModuleDescriptor] (from webgpu.h) *)
module ShaderModuleDescriptor = struct
  let c_name = "WGPUShaderModuleDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUShaderModuleDescriptor"

  (** [WGPUShaderModuleDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUShaderModuleDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; ]

  (** A fresh value carrying the defaults of the header's [SHADER_MODULE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUSurfaceDescriptor] (from webgpu.h) *)
module SurfaceDescriptor = struct
  let c_name = "WGPUSurfaceDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceDescriptor"

  (** [WGPUSurfaceDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUSurfaceDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; ]

  (** A fresh value carrying the defaults of the header's [SURFACE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUTexelCopyBufferInfo] (from webgpu.h) *)
module TexelCopyBufferInfo = struct
  let c_name = "WGPUTexelCopyBufferInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTexelCopyBufferInfo"

  (** [WGPUTexelCopyBufferInfo layout] : [TexelCopyBufferLayout.t] *)
  let layout = Ctypes.field t "layout" TexelCopyBufferLayout.t

  (** [WGPUTexelCopyBufferInfo buffer] : [Buffer.t] *)
  let buffer = Ctypes.field t "buffer" Buffer.t

  let () = Ctypes.seal t

  let field_names = [ "layout"; "buffer"; ]

  (** A fresh value carrying the defaults of the header's [TEXEL_COPY_BUFFER_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v layout (TexelCopyBufferLayout.init ());
    v
end

(** [WGPUTexelCopyTextureInfo] (from webgpu.h) *)
module TexelCopyTextureInfo = struct
  let c_name = "WGPUTexelCopyTextureInfo"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTexelCopyTextureInfo"

  (** [WGPUTexelCopyTextureInfo texture] : [Texture.t] *)
  let texture = Ctypes.field t "texture" Texture.t

  (** [WGPUTexelCopyTextureInfo mipLevel] : [Unsigned.UInt32.t] *)
  let mipLevel = Ctypes.field t "mipLevel" Ctypes.uint32_t

  (** [WGPUTexelCopyTextureInfo origin] : [Origin3D.t] *)
  let origin = Ctypes.field t "origin" Origin3D.t

  (** [WGPUTexelCopyTextureInfo aspect] : [TextureAspect.t] *)
  let aspect = Ctypes.field t "aspect" TextureAspect.t

  let () = Ctypes.seal t

  let field_names = [ "texture"; "mipLevel"; "origin"; "aspect"; ]

  (** A fresh value carrying the defaults of the header's [TEXEL_COPY_TEXTURE_INFO_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v origin (Origin3D.init ());
    Ctypes.setf v aspect (TextureAspect.undefined);
    v
end

(** [WGPUTextureComponentSwizzleDescriptor] (from webgpu.h) *)
module TextureComponentSwizzleDescriptor = struct
  let c_name = "WGPUTextureComponentSwizzleDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTextureComponentSwizzleDescriptor"

  (** [WGPUTextureComponentSwizzleDescriptor chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUTextureComponentSwizzleDescriptor swizzle] : [TextureComponentSwizzle.t] *)
  let swizzle = Ctypes.field t "swizzle" TextureComponentSwizzle.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "swizzle"; ]

  (** A fresh value carrying the defaults of the header's [TEXTURE_COMPONENT_SWIZZLE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (SType.texture_component_swizzle_descriptor);  s);
    Ctypes.setf v swizzle (TextureComponentSwizzle.init ());
    v
end

(** [WGPUTextureDescriptor] (from webgpu.h) *)
module TextureDescriptor = struct
  let c_name = "WGPUTextureDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTextureDescriptor"

  (** [WGPUTextureDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUTextureDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUTextureDescriptor usage] : [TextureUsage.t] *)
  let usage = Ctypes.field t "usage" TextureUsage.t

  (** [WGPUTextureDescriptor dimension] : [TextureDimension.t] *)
  let dimension = Ctypes.field t "dimension" TextureDimension.t

  (** [WGPUTextureDescriptor size] : [Extent3D.t] *)
  let size = Ctypes.field t "size" Extent3D.t

  (** [WGPUTextureDescriptor format] : [TextureFormat.t] *)
  let format = Ctypes.field t "format" TextureFormat.t

  (** [WGPUTextureDescriptor mipLevelCount] : [Unsigned.UInt32.t] *)
  let mipLevelCount = Ctypes.field t "mipLevelCount" Ctypes.uint32_t

  (** [WGPUTextureDescriptor sampleCount] : [Unsigned.UInt32.t] *)
  let sampleCount = Ctypes.field t "sampleCount" Ctypes.uint32_t

  (** [WGPUTextureDescriptor viewFormatCount] : [Unsigned.Size_t.t] *)
  let viewFormatCount = Ctypes.field t "viewFormatCount" Ctypes.size_t

  (** [WGPUTextureDescriptor viewFormats] : [TextureFormat.t Ctypes.ptr] *)
  let viewFormats = Ctypes.field t "viewFormats" (Ctypes.ptr TextureFormat.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "usage"; "dimension"; "size"; "format"; "mipLevelCount"; "sampleCount"; "viewFormatCount"; "viewFormats"; ]

  (** A fresh value carrying the defaults of the header's [TEXTURE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    Ctypes.setf v usage (TextureUsage.none);
    Ctypes.setf v dimension (TextureDimension.undefined);
    Ctypes.setf v size (Extent3D.init ());
    Ctypes.setf v format (TextureFormat.undefined);
    Ctypes.setf v mipLevelCount (Unsigned.UInt32.of_int 1);
    Ctypes.setf v sampleCount (Unsigned.UInt32.of_int 1);
    v
end

(** [WGPUVertexBufferLayout] (from webgpu.h) *)
module VertexBufferLayout = struct
  let c_name = "WGPUVertexBufferLayout"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUVertexBufferLayout"

  (** [WGPUVertexBufferLayout nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUVertexBufferLayout stepMode] : [VertexStepMode.t] *)
  let stepMode = Ctypes.field t "stepMode" VertexStepMode.t

  (** [WGPUVertexBufferLayout arrayStride] : [Unsigned.UInt64.t] *)
  let arrayStride = Ctypes.field t "arrayStride" Ctypes.uint64_t

  (** [WGPUVertexBufferLayout attributeCount] : [Unsigned.Size_t.t] *)
  let attributeCount = Ctypes.field t "attributeCount" Ctypes.size_t

  (** [WGPUVertexBufferLayout attributes] : [VertexAttribute.t Ctypes.ptr] *)
  let attributes = Ctypes.field t "attributes" (Ctypes.ptr VertexAttribute.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "stepMode"; "arrayStride"; "attributeCount"; "attributes"; ]

  (** A fresh value carrying the defaults of the header's [VERTEX_BUFFER_LAYOUT_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v stepMode (VertexStepMode.undefined);
    v
end

(** [WGPUBindGroupDescriptor] (from webgpu.h) *)
module BindGroupDescriptor = struct
  let c_name = "WGPUBindGroupDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBindGroupDescriptor"

  (** [WGPUBindGroupDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUBindGroupDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUBindGroupDescriptor layout] : [BindGroupLayout.t] *)
  let layout = Ctypes.field t "layout" BindGroupLayout.t

  (** [WGPUBindGroupDescriptor entryCount] : [Unsigned.Size_t.t] *)
  let entryCount = Ctypes.field t "entryCount" Ctypes.size_t

  (** [WGPUBindGroupDescriptor entries] : [BindGroupEntry.t Ctypes.ptr] *)
  let entries = Ctypes.field t "entries" (Ctypes.ptr BindGroupEntry.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "layout"; "entryCount"; "entries"; ]

  (** A fresh value carrying the defaults of the header's [BIND_GROUP_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUBindGroupLayoutDescriptor] (from webgpu.h) *)
module BindGroupLayoutDescriptor = struct
  let c_name = "WGPUBindGroupLayoutDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBindGroupLayoutDescriptor"

  (** [WGPUBindGroupLayoutDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUBindGroupLayoutDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUBindGroupLayoutDescriptor entryCount] : [Unsigned.Size_t.t] *)
  let entryCount = Ctypes.field t "entryCount" Ctypes.size_t

  (** [WGPUBindGroupLayoutDescriptor entries] : [BindGroupLayoutEntry.t Ctypes.ptr] *)
  let entries = Ctypes.field t "entries" (Ctypes.ptr BindGroupLayoutEntry.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "entryCount"; "entries"; ]

  (** A fresh value carrying the defaults of the header's [BIND_GROUP_LAYOUT_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUColorTargetState] (from webgpu.h) *)
module ColorTargetState = struct
  let c_name = "WGPUColorTargetState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUColorTargetState"

  (** [WGPUColorTargetState nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUColorTargetState format] : [TextureFormat.t] *)
  let format = Ctypes.field t "format" TextureFormat.t

  (** [WGPUColorTargetState blend] : [BlendState.t Ctypes.ptr] *)
  let blend = Ctypes.field t "blend" (Ctypes.ptr BlendState.t)

  (** [WGPUColorTargetState writeMask] : [ColorWriteMask.t] *)
  let writeMask = Ctypes.field t "writeMask" ColorWriteMask.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "format"; "blend"; "writeMask"; ]

  (** A fresh value carrying the defaults of the header's [COLOR_TARGET_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v format (TextureFormat.undefined);
    Ctypes.setf v writeMask (ColorWriteMask.all);
    v
end

(** [WGPUComputePipelineDescriptor] (from webgpu.h) *)
module ComputePipelineDescriptor = struct
  let c_name = "WGPUComputePipelineDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUComputePipelineDescriptor"

  (** [WGPUComputePipelineDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUComputePipelineDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUComputePipelineDescriptor layout] : [PipelineLayout.t] *)
  let layout = Ctypes.field t "layout" PipelineLayout.t

  (** [WGPUComputePipelineDescriptor compute] : [ComputeState.t] *)
  let compute = Ctypes.field t "compute" ComputeState.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "layout"; "compute"; ]

  (** A fresh value carrying the defaults of the header's [COMPUTE_PIPELINE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    Ctypes.setf v compute (ComputeState.init ());
    v
end

(** [WGPUDeviceDescriptor] (from webgpu.h) *)
module DeviceDescriptor = struct
  let c_name = "WGPUDeviceDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUDeviceDescriptor"

  (** [WGPUDeviceDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUDeviceDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUDeviceDescriptor requiredFeatureCount] : [Unsigned.Size_t.t] *)
  let requiredFeatureCount = Ctypes.field t "requiredFeatureCount" Ctypes.size_t

  (** [WGPUDeviceDescriptor requiredFeatures] : [FeatureName.t Ctypes.ptr] *)
  let requiredFeatures = Ctypes.field t "requiredFeatures" (Ctypes.ptr FeatureName.t)

  (** [WGPUDeviceDescriptor requiredLimits] : [Limits.t Ctypes.ptr] *)
  let requiredLimits = Ctypes.field t "requiredLimits" (Ctypes.ptr Limits.t)

  (** [WGPUDeviceDescriptor defaultQueue] : [QueueDescriptor.t] *)
  let defaultQueue = Ctypes.field t "defaultQueue" QueueDescriptor.t

  (** [WGPUDeviceDescriptor deviceLostCallbackInfo] : [DeviceLostCallbackInfo.t] *)
  let deviceLostCallbackInfo = Ctypes.field t "deviceLostCallbackInfo" DeviceLostCallbackInfo.t

  (** [WGPUDeviceDescriptor uncapturedErrorCallbackInfo] : [UncapturedErrorCallbackInfo.t] *)
  let uncapturedErrorCallbackInfo = Ctypes.field t "uncapturedErrorCallbackInfo" UncapturedErrorCallbackInfo.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "requiredFeatureCount"; "requiredFeatures"; "requiredLimits"; "defaultQueue"; "deviceLostCallbackInfo"; "uncapturedErrorCallbackInfo"; ]

  (** A fresh value carrying the defaults of the header's [DEVICE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    Ctypes.setf v defaultQueue (QueueDescriptor.init ());
    Ctypes.setf v deviceLostCallbackInfo (DeviceLostCallbackInfo.init ());
    Ctypes.setf v uncapturedErrorCallbackInfo (UncapturedErrorCallbackInfo.init ());
    v
end

(** [WGPURenderPassDescriptor] (from webgpu.h) *)
module RenderPassDescriptor = struct
  let c_name = "WGPURenderPassDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURenderPassDescriptor"

  (** [WGPURenderPassDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURenderPassDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPURenderPassDescriptor colorAttachmentCount] : [Unsigned.Size_t.t] *)
  let colorAttachmentCount = Ctypes.field t "colorAttachmentCount" Ctypes.size_t

  (** [WGPURenderPassDescriptor colorAttachments] : [RenderPassColorAttachment.t Ctypes.ptr] *)
  let colorAttachments = Ctypes.field t "colorAttachments" (Ctypes.ptr RenderPassColorAttachment.t)

  (** [WGPURenderPassDescriptor depthStencilAttachment] : [RenderPassDepthStencilAttachment.t Ctypes.ptr] *)
  let depthStencilAttachment = Ctypes.field t "depthStencilAttachment" (Ctypes.ptr RenderPassDepthStencilAttachment.t)

  (** [WGPURenderPassDescriptor occlusionQuerySet] : [QuerySet.t] *)
  let occlusionQuerySet = Ctypes.field t "occlusionQuerySet" QuerySet.t

  (** [WGPURenderPassDescriptor timestampWrites] : [PassTimestampWrites.t Ctypes.ptr] *)
  let timestampWrites = Ctypes.field t "timestampWrites" (Ctypes.ptr PassTimestampWrites.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "colorAttachmentCount"; "colorAttachments"; "depthStencilAttachment"; "occlusionQuerySet"; "timestampWrites"; ]

  (** A fresh value carrying the defaults of the header's [RENDER_PASS_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    v
end

(** [WGPUTextureViewDescriptor] (from webgpu.h) *)
module TextureViewDescriptor = struct
  let c_name = "WGPUTextureViewDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUTextureViewDescriptor"

  (** [WGPUTextureViewDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUTextureViewDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUTextureViewDescriptor format] : [TextureFormat.t] *)
  let format = Ctypes.field t "format" TextureFormat.t

  (** [WGPUTextureViewDescriptor dimension] : [TextureViewDimension.t] *)
  let dimension = Ctypes.field t "dimension" TextureViewDimension.t

  (** [WGPUTextureViewDescriptor baseMipLevel] : [Unsigned.UInt32.t] *)
  let baseMipLevel = Ctypes.field t "baseMipLevel" Ctypes.uint32_t

  (** [WGPUTextureViewDescriptor mipLevelCount] : [Unsigned.UInt32.t] *)
  let mipLevelCount = Ctypes.field t "mipLevelCount" Ctypes.uint32_t

  (** [WGPUTextureViewDescriptor baseArrayLayer] : [Unsigned.UInt32.t] *)
  let baseArrayLayer = Ctypes.field t "baseArrayLayer" Ctypes.uint32_t

  (** [WGPUTextureViewDescriptor arrayLayerCount] : [Unsigned.UInt32.t] *)
  let arrayLayerCount = Ctypes.field t "arrayLayerCount" Ctypes.uint32_t

  (** [WGPUTextureViewDescriptor aspect] : [TextureAspect.t] *)
  let aspect = Ctypes.field t "aspect" TextureAspect.t

  (** [WGPUTextureViewDescriptor usage] : [TextureUsage.t] *)
  let usage = Ctypes.field t "usage" TextureUsage.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "format"; "dimension"; "baseMipLevel"; "mipLevelCount"; "baseArrayLayer"; "arrayLayerCount"; "aspect"; "usage"; ]

  (** A fresh value carrying the defaults of the header's [TEXTURE_VIEW_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    Ctypes.setf v format (TextureFormat.undefined);
    Ctypes.setf v dimension (TextureViewDimension.undefined);
    Ctypes.setf v mipLevelCount (Constants.mip_level_count_undefined);
    Ctypes.setf v arrayLayerCount (Constants.array_layer_count_undefined);
    Ctypes.setf v aspect (TextureAspect.undefined);
    Ctypes.setf v usage (TextureUsage.none);
    v
end

(** [WGPUVertexState] (from webgpu.h) *)
module VertexState = struct
  let c_name = "WGPUVertexState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUVertexState"

  (** [WGPUVertexState nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUVertexState module] : [ShaderModule.t] *)
  let module_ = Ctypes.field t "module" ShaderModule.t

  (** [WGPUVertexState entryPoint] : [StringView.t] *)
  let entryPoint = Ctypes.field t "entryPoint" StringView.t

  (** [WGPUVertexState constantCount] : [Unsigned.Size_t.t] *)
  let constantCount = Ctypes.field t "constantCount" Ctypes.size_t

  (** [WGPUVertexState constants] : [ConstantEntry.t Ctypes.ptr] *)
  let constants = Ctypes.field t "constants" (Ctypes.ptr ConstantEntry.t)

  (** [WGPUVertexState bufferCount] : [Unsigned.Size_t.t] *)
  let bufferCount = Ctypes.field t "bufferCount" Ctypes.size_t

  (** [WGPUVertexState buffers] : [VertexBufferLayout.t Ctypes.ptr] *)
  let buffers = Ctypes.field t "buffers" (Ctypes.ptr VertexBufferLayout.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "module"; "entryPoint"; "constantCount"; "constants"; "bufferCount"; "buffers"; ]

  (** A fresh value carrying the defaults of the header's [VERTEX_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v entryPoint (StringView.init ());
    v
end

(** [WGPUFragmentState] (from webgpu.h) *)
module FragmentState = struct
  let c_name = "WGPUFragmentState"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUFragmentState"

  (** [WGPUFragmentState nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUFragmentState module] : [ShaderModule.t] *)
  let module_ = Ctypes.field t "module" ShaderModule.t

  (** [WGPUFragmentState entryPoint] : [StringView.t] *)
  let entryPoint = Ctypes.field t "entryPoint" StringView.t

  (** [WGPUFragmentState constantCount] : [Unsigned.Size_t.t] *)
  let constantCount = Ctypes.field t "constantCount" Ctypes.size_t

  (** [WGPUFragmentState constants] : [ConstantEntry.t Ctypes.ptr] *)
  let constants = Ctypes.field t "constants" (Ctypes.ptr ConstantEntry.t)

  (** [WGPUFragmentState targetCount] : [Unsigned.Size_t.t] *)
  let targetCount = Ctypes.field t "targetCount" Ctypes.size_t

  (** [WGPUFragmentState targets] : [ColorTargetState.t Ctypes.ptr] *)
  let targets = Ctypes.field t "targets" (Ctypes.ptr ColorTargetState.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "module"; "entryPoint"; "constantCount"; "constants"; "targetCount"; "targets"; ]

  (** A fresh value carrying the defaults of the header's [FRAGMENT_STATE_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v entryPoint (StringView.init ());
    v
end

(** [WGPURenderPipelineDescriptor] (from webgpu.h) *)
module RenderPipelineDescriptor = struct
  let c_name = "WGPURenderPipelineDescriptor"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURenderPipelineDescriptor"

  (** [WGPURenderPipelineDescriptor nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPURenderPipelineDescriptor label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPURenderPipelineDescriptor layout] : [PipelineLayout.t] *)
  let layout = Ctypes.field t "layout" PipelineLayout.t

  (** [WGPURenderPipelineDescriptor vertex] : [VertexState.t] *)
  let vertex = Ctypes.field t "vertex" VertexState.t

  (** [WGPURenderPipelineDescriptor primitive] : [PrimitiveState.t] *)
  let primitive = Ctypes.field t "primitive" PrimitiveState.t

  (** [WGPURenderPipelineDescriptor depthStencil] : [DepthStencilState.t Ctypes.ptr] *)
  let depthStencil = Ctypes.field t "depthStencil" (Ctypes.ptr DepthStencilState.t)

  (** [WGPURenderPipelineDescriptor multisample] : [MultisampleState.t] *)
  let multisample = Ctypes.field t "multisample" MultisampleState.t

  (** [WGPURenderPipelineDescriptor fragment] : [FragmentState.t Ctypes.ptr] *)
  let fragment = Ctypes.field t "fragment" (Ctypes.ptr FragmentState.t)

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "label"; "layout"; "vertex"; "primitive"; "depthStencil"; "multisample"; "fragment"; ]

  (** A fresh value carrying the defaults of the header's [RENDER_PIPELINE_DESCRIPTOR_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v label (StringView.init ());
    Ctypes.setf v vertex (VertexState.init ());
    Ctypes.setf v primitive (PrimitiveState.init ());
    Ctypes.setf v multisample (MultisampleState.init ());
    v
end

(** [WGPUXlibDisplayHandle] (from wgpu.h) *)
module XlibDisplayHandle = struct
  let c_name = "WGPUXlibDisplayHandle"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUXlibDisplayHandle"

  (** [WGPUXlibDisplayHandle display] : [unit Ctypes.ptr] *)
  let display = Ctypes.field t "display" (Ctypes.ptr Ctypes.void)

  (** [WGPUXlibDisplayHandle screen] : [int] *)
  let screen = Ctypes.field t "screen" Ctypes.int

  let () = Ctypes.seal t

  let field_names = [ "display"; "screen"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUXcbDisplayHandle] (from wgpu.h) *)
module XcbDisplayHandle = struct
  let c_name = "WGPUXcbDisplayHandle"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUXcbDisplayHandle"

  (** [WGPUXcbDisplayHandle connection] : [unit Ctypes.ptr] *)
  let connection = Ctypes.field t "connection" (Ctypes.ptr Ctypes.void)

  (** [WGPUXcbDisplayHandle screen] : [int] *)
  let screen = Ctypes.field t "screen" Ctypes.int

  let () = Ctypes.seal t

  let field_names = [ "connection"; "screen"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUWaylandDisplayHandle] (from wgpu.h) *)
module WaylandDisplayHandle = struct
  let c_name = "WGPUWaylandDisplayHandle"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUWaylandDisplayHandle"

  (** [WGPUWaylandDisplayHandle display] : [unit Ctypes.ptr] *)
  let display = Ctypes.field t "display" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "display"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUNativeDisplayHandle] (from wgpu.h) *)
module NativeDisplayHandle = struct
  let c_name = "WGPUNativeDisplayHandle"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUNativeDisplayHandle"

  (** Anonymous union [WGPUNativeDisplayHandle.data]. *)
  module NativeDisplayHandle_data = struct
    let c_name = "WGPUNativeDisplayHandle_data"

    type s

    type t = s Ctypes.union

    let t : t Ctypes.typ = Ctypes.union "WGPUNativeDisplayHandle_data"

    let xlib = Ctypes.field t "xlib" XlibDisplayHandle.t
    let xcb = Ctypes.field t "xcb" XcbDisplayHandle.t
    let wayland = Ctypes.field t "wayland" WaylandDisplayHandle.t

    let () = Ctypes.seal t

    let field_names = [ "xlib"; "xcb"; "wayland"; ]
  end

  (** [WGPUNativeDisplayHandle type] : [NativeDisplayHandleType.t] *)
  let type_ = Ctypes.field t "type" NativeDisplayHandleType.t

  (** [WGPUNativeDisplayHandle data] : [NativeDisplayHandle_data.t] *)
  let data = Ctypes.field t "data" NativeDisplayHandle_data.t

  let () = Ctypes.seal t

  let field_names = [ "type"; "data"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUInstanceExtras] (from wgpu.h) *)
module InstanceExtras = struct
  let c_name = "WGPUInstanceExtras"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUInstanceExtras"

  (** [WGPUInstanceExtras chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUInstanceExtras backends] : [InstanceBackend.t] *)
  let backends = Ctypes.field t "backends" InstanceBackend.t

  (** [WGPUInstanceExtras flags] : [InstanceFlag.t] *)
  let flags = Ctypes.field t "flags" InstanceFlag.t

  (** [WGPUInstanceExtras dx12ShaderCompiler] : [Dx12Compiler.t] *)
  let dx12ShaderCompiler = Ctypes.field t "dx12ShaderCompiler" Dx12Compiler.t

  (** [WGPUInstanceExtras gles3MinorVersion] : [Gles3MinorVersion.t] *)
  let gles3MinorVersion = Ctypes.field t "gles3MinorVersion" Gles3MinorVersion.t

  (** [WGPUInstanceExtras glFenceBehaviour] : [GLFenceBehaviour.t] *)
  let glFenceBehaviour = Ctypes.field t "glFenceBehaviour" GLFenceBehaviour.t

  (** [WGPUInstanceExtras dxcPath] : [StringView.t] *)
  let dxcPath = Ctypes.field t "dxcPath" StringView.t

  (** [WGPUInstanceExtras dxcMaxShaderModel] : [DxcMaxShaderModel.t] *)
  let dxcMaxShaderModel = Ctypes.field t "dxcMaxShaderModel" DxcMaxShaderModel.t

  (** [WGPUInstanceExtras dx12PresentationSystem] : [Dx12SwapchainKind.t] *)
  let dx12PresentationSystem = Ctypes.field t "dx12PresentationSystem" Dx12SwapchainKind.t

  (** [WGPUInstanceExtras budgetForDeviceCreation] : [Unsigned.UInt8.t Ctypes.ptr] *)
  let budgetForDeviceCreation = Ctypes.field t "budgetForDeviceCreation" (Ctypes.ptr Ctypes.uint8_t)

  (** [WGPUInstanceExtras budgetForDeviceLoss] : [Unsigned.UInt8.t Ctypes.ptr] *)
  let budgetForDeviceLoss = Ctypes.field t "budgetForDeviceLoss" (Ctypes.ptr Ctypes.uint8_t)

  (** [WGPUInstanceExtras displayHandle] : [NativeDisplayHandle.t] *)
  let displayHandle = Ctypes.field t "displayHandle" NativeDisplayHandle.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "backends"; "flags"; "dx12ShaderCompiler"; "gles3MinorVersion"; "glFenceBehaviour"; "dxcPath"; "dxcMaxShaderModel"; "dx12PresentationSystem"; "budgetForDeviceCreation"; "budgetForDeviceLoss"; "displayHandle"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUDeviceExtras] (from wgpu.h) *)
module DeviceExtras = struct
  let c_name = "WGPUDeviceExtras"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUDeviceExtras"

  (** [WGPUDeviceExtras chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUDeviceExtras tracePath] : [StringView.t] *)
  let tracePath = Ctypes.field t "tracePath" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "tracePath"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUNativeLimits] (from wgpu.h) *)
module NativeLimits = struct
  let c_name = "WGPUNativeLimits"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUNativeLimits"

  (** [WGPUNativeLimits chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUNativeLimits maxNonSamplerBindings] : [Unsigned.UInt32.t] *)
  let maxNonSamplerBindings = Ctypes.field t "maxNonSamplerBindings" Ctypes.uint32_t

  (** [WGPUNativeLimits maxBindingArrayElementsPerShaderStage] : [Unsigned.UInt32.t] *)
  let maxBindingArrayElementsPerShaderStage = Ctypes.field t "maxBindingArrayElementsPerShaderStage" Ctypes.uint32_t

  (** [WGPUNativeLimits maxBindingArraySamplerElementsPerShaderStage] : [Unsigned.UInt32.t] *)
  let maxBindingArraySamplerElementsPerShaderStage = Ctypes.field t "maxBindingArraySamplerElementsPerShaderStage" Ctypes.uint32_t

  (** [WGPUNativeLimits maxMultiviewViewCount] : [Unsigned.UInt32.t] *)
  let maxMultiviewViewCount = Ctypes.field t "maxMultiviewViewCount" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "maxNonSamplerBindings"; "maxBindingArrayElementsPerShaderStage"; "maxBindingArraySamplerElementsPerShaderStage"; "maxMultiviewViewCount"; ]

  (** A fresh value carrying the defaults of the header's [NATIVE_LIMITS_INIT]
      macro.  Zero is *not* a valid default for every WebGPU struct, so
      always start from this. *)
  let init () : t =
    let v = zeroed t in
    Ctypes.setf v chain (let s = ChainedStruct.init () in Ctypes.setf s ChainedStruct.sType (NativeSType.native_limits);  s);
    Ctypes.setf v maxNonSamplerBindings (Constants.limit_u32_undefined);
    Ctypes.setf v maxBindingArrayElementsPerShaderStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxBindingArraySamplerElementsPerShaderStage (Constants.limit_u32_undefined);
    Ctypes.setf v maxMultiviewViewCount (Constants.limit_u32_undefined);
    v
end

(** [WGPUShaderDefine] (from wgpu.h) *)
module ShaderDefine = struct
  let c_name = "WGPUShaderDefine"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUShaderDefine"

  (** [WGPUShaderDefine name] : [StringView.t] *)
  let name = Ctypes.field t "name" StringView.t

  (** [WGPUShaderDefine value] : [StringView.t] *)
  let value = Ctypes.field t "value" StringView.t

  let () = Ctypes.seal t

  let field_names = [ "name"; "value"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUShaderSourceGLSL] (from wgpu.h) *)
module ShaderSourceGLSL = struct
  let c_name = "WGPUShaderSourceGLSL"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUShaderSourceGLSL"

  (** [WGPUShaderSourceGLSL chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUShaderSourceGLSL stage] : [ShaderStage.t] *)
  let stage = Ctypes.field t "stage" ShaderStage.t

  (** [WGPUShaderSourceGLSL code] : [StringView.t] *)
  let code = Ctypes.field t "code" StringView.t

  (** [WGPUShaderSourceGLSL defineCount] : [Unsigned.UInt32.t] *)
  let defineCount = Ctypes.field t "defineCount" Ctypes.uint32_t

  (** [WGPUShaderSourceGLSL defines] : [ShaderDefine.t Ctypes.ptr] *)
  let defines = Ctypes.field t "defines" (Ctypes.ptr ShaderDefine.t)

  let () = Ctypes.seal t

  let field_names = [ "chain"; "stage"; "code"; "defineCount"; "defines"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUShaderModuleDescriptorSpirV] (from wgpu.h) *)
module ShaderModuleDescriptorSpirV = struct
  let c_name = "WGPUShaderModuleDescriptorSpirV"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUShaderModuleDescriptorSpirV"

  (** [WGPUShaderModuleDescriptorSpirV label] : [StringView.t] *)
  let label = Ctypes.field t "label" StringView.t

  (** [WGPUShaderModuleDescriptorSpirV sourceSize] : [Unsigned.UInt32.t] *)
  let sourceSize = Ctypes.field t "sourceSize" Ctypes.uint32_t

  (** [WGPUShaderModuleDescriptorSpirV source] : [Unsigned.UInt32.t Ctypes.ptr] *)
  let source = Ctypes.field t "source" (Ctypes.ptr Ctypes.uint32_t)

  let () = Ctypes.seal t

  let field_names = [ "label"; "sourceSize"; "source"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPURegistryReport] (from wgpu.h) *)
module RegistryReport = struct
  let c_name = "WGPURegistryReport"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPURegistryReport"

  (** [WGPURegistryReport numAllocated] : [Unsigned.Size_t.t] *)
  let numAllocated = Ctypes.field t "numAllocated" Ctypes.size_t

  (** [WGPURegistryReport numKeptFromUser] : [Unsigned.Size_t.t] *)
  let numKeptFromUser = Ctypes.field t "numKeptFromUser" Ctypes.size_t

  (** [WGPURegistryReport numReleasedFromUser] : [Unsigned.Size_t.t] *)
  let numReleasedFromUser = Ctypes.field t "numReleasedFromUser" Ctypes.size_t

  (** [WGPURegistryReport elementSize] : [Unsigned.Size_t.t] *)
  let elementSize = Ctypes.field t "elementSize" Ctypes.size_t

  let () = Ctypes.seal t

  let field_names = [ "numAllocated"; "numKeptFromUser"; "numReleasedFromUser"; "elementSize"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUHubReport] (from wgpu.h) *)
module HubReport = struct
  let c_name = "WGPUHubReport"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUHubReport"

  (** [WGPUHubReport adapters] : [RegistryReport.t] *)
  let adapters = Ctypes.field t "adapters" RegistryReport.t

  (** [WGPUHubReport devices] : [RegistryReport.t] *)
  let devices = Ctypes.field t "devices" RegistryReport.t

  (** [WGPUHubReport queues] : [RegistryReport.t] *)
  let queues = Ctypes.field t "queues" RegistryReport.t

  (** [WGPUHubReport pipelineLayouts] : [RegistryReport.t] *)
  let pipelineLayouts = Ctypes.field t "pipelineLayouts" RegistryReport.t

  (** [WGPUHubReport shaderModules] : [RegistryReport.t] *)
  let shaderModules = Ctypes.field t "shaderModules" RegistryReport.t

  (** [WGPUHubReport bindGroupLayouts] : [RegistryReport.t] *)
  let bindGroupLayouts = Ctypes.field t "bindGroupLayouts" RegistryReport.t

  (** [WGPUHubReport bindGroups] : [RegistryReport.t] *)
  let bindGroups = Ctypes.field t "bindGroups" RegistryReport.t

  (** [WGPUHubReport commandBuffers] : [RegistryReport.t] *)
  let commandBuffers = Ctypes.field t "commandBuffers" RegistryReport.t

  (** [WGPUHubReport renderBundles] : [RegistryReport.t] *)
  let renderBundles = Ctypes.field t "renderBundles" RegistryReport.t

  (** [WGPUHubReport renderPipelines] : [RegistryReport.t] *)
  let renderPipelines = Ctypes.field t "renderPipelines" RegistryReport.t

  (** [WGPUHubReport computePipelines] : [RegistryReport.t] *)
  let computePipelines = Ctypes.field t "computePipelines" RegistryReport.t

  (** [WGPUHubReport pipelineCaches] : [RegistryReport.t] *)
  let pipelineCaches = Ctypes.field t "pipelineCaches" RegistryReport.t

  (** [WGPUHubReport querySets] : [RegistryReport.t] *)
  let querySets = Ctypes.field t "querySets" RegistryReport.t

  (** [WGPUHubReport buffers] : [RegistryReport.t] *)
  let buffers = Ctypes.field t "buffers" RegistryReport.t

  (** [WGPUHubReport textures] : [RegistryReport.t] *)
  let textures = Ctypes.field t "textures" RegistryReport.t

  (** [WGPUHubReport textureViews] : [RegistryReport.t] *)
  let textureViews = Ctypes.field t "textureViews" RegistryReport.t

  (** [WGPUHubReport samplers] : [RegistryReport.t] *)
  let samplers = Ctypes.field t "samplers" RegistryReport.t

  let () = Ctypes.seal t

  let field_names = [ "adapters"; "devices"; "queues"; "pipelineLayouts"; "shaderModules"; "bindGroupLayouts"; "bindGroups"; "commandBuffers"; "renderBundles"; "renderPipelines"; "computePipelines"; "pipelineCaches"; "querySets"; "buffers"; "textures"; "textureViews"; "samplers"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUGlobalReport] (from wgpu.h) *)
module GlobalReport = struct
  let c_name = "WGPUGlobalReport"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUGlobalReport"

  (** [WGPUGlobalReport surfaces] : [RegistryReport.t] *)
  let surfaces = Ctypes.field t "surfaces" RegistryReport.t

  (** [WGPUGlobalReport hub] : [HubReport.t] *)
  let hub = Ctypes.field t "hub" HubReport.t

  let () = Ctypes.seal t

  let field_names = [ "surfaces"; "hub"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUInstanceEnumerateAdapterOptions] (from wgpu.h) *)
module InstanceEnumerateAdapterOptions = struct
  let c_name = "WGPUInstanceEnumerateAdapterOptions"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUInstanceEnumerateAdapterOptions"

  (** [WGPUInstanceEnumerateAdapterOptions nextInChain] : [ChainedStruct.t Ctypes.ptr] *)
  let nextInChain = Ctypes.field t "nextInChain" (Ctypes.ptr ChainedStruct.t)

  (** [WGPUInstanceEnumerateAdapterOptions backends] : [InstanceBackend.t] *)
  let backends = Ctypes.field t "backends" InstanceBackend.t

  let () = Ctypes.seal t

  let field_names = [ "nextInChain"; "backends"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUBindGroupEntryExtras] (from wgpu.h) *)
module BindGroupEntryExtras = struct
  let c_name = "WGPUBindGroupEntryExtras"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBindGroupEntryExtras"

  (** [WGPUBindGroupEntryExtras chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUBindGroupEntryExtras buffers] : [Buffer.t Ctypes.ptr] *)
  let buffers = Ctypes.field t "buffers" (Ctypes.ptr Buffer.t)

  (** [WGPUBindGroupEntryExtras bufferCount] : [Unsigned.Size_t.t] *)
  let bufferCount = Ctypes.field t "bufferCount" Ctypes.size_t

  (** [WGPUBindGroupEntryExtras samplers] : [Sampler.t Ctypes.ptr] *)
  let samplers = Ctypes.field t "samplers" (Ctypes.ptr Sampler.t)

  (** [WGPUBindGroupEntryExtras samplerCount] : [Unsigned.Size_t.t] *)
  let samplerCount = Ctypes.field t "samplerCount" Ctypes.size_t

  (** [WGPUBindGroupEntryExtras textureViews] : [TextureView.t Ctypes.ptr] *)
  let textureViews = Ctypes.field t "textureViews" (Ctypes.ptr TextureView.t)

  (** [WGPUBindGroupEntryExtras textureViewCount] : [Unsigned.Size_t.t] *)
  let textureViewCount = Ctypes.field t "textureViewCount" Ctypes.size_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "buffers"; "bufferCount"; "samplers"; "samplerCount"; "textureViews"; "textureViewCount"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUBindGroupLayoutEntryExtras] (from wgpu.h) *)
module BindGroupLayoutEntryExtras = struct
  let c_name = "WGPUBindGroupLayoutEntryExtras"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUBindGroupLayoutEntryExtras"

  (** [WGPUBindGroupLayoutEntryExtras chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUBindGroupLayoutEntryExtras count] : [Unsigned.UInt32.t] *)
  let count = Ctypes.field t "count" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "count"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUQuerySetDescriptorExtras] (from wgpu.h) *)
module QuerySetDescriptorExtras = struct
  let c_name = "WGPUQuerySetDescriptorExtras"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUQuerySetDescriptorExtras"

  (** [WGPUQuerySetDescriptorExtras chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUQuerySetDescriptorExtras pipelineStatistics] : [PipelineStatisticName.t Ctypes.ptr] *)
  let pipelineStatistics = Ctypes.field t "pipelineStatistics" (Ctypes.ptr PipelineStatisticName.t)

  (** [WGPUQuerySetDescriptorExtras pipelineStatisticCount] : [Unsigned.Size_t.t] *)
  let pipelineStatisticCount = Ctypes.field t "pipelineStatisticCount" Ctypes.size_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "pipelineStatistics"; "pipelineStatisticCount"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUSurfaceConfigurationExtras] (from wgpu.h) *)
module SurfaceConfigurationExtras = struct
  let c_name = "WGPUSurfaceConfigurationExtras"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceConfigurationExtras"

  (** [WGPUSurfaceConfigurationExtras chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceConfigurationExtras desiredMaximumFrameLatency] : [Unsigned.UInt32.t] *)
  let desiredMaximumFrameLatency = Ctypes.field t "desiredMaximumFrameLatency" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "desiredMaximumFrameLatency"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUSurfaceSourceSwapChainPanel] (from wgpu.h) *)
module SurfaceSourceSwapChainPanel = struct
  let c_name = "WGPUSurfaceSourceSwapChainPanel"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSurfaceSourceSwapChainPanel"

  (** [WGPUSurfaceSourceSwapChainPanel chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSurfaceSourceSwapChainPanel panelNative] : [unit Ctypes.ptr] *)
  let panelNative = Ctypes.field t "panelNative" (Ctypes.ptr Ctypes.void)

  let () = Ctypes.seal t

  let field_names = [ "chain"; "panelNative"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUPrimitiveStateExtras] (from wgpu.h) *)
module PrimitiveStateExtras = struct
  let c_name = "WGPUPrimitiveStateExtras"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUPrimitiveStateExtras"

  (** [WGPUPrimitiveStateExtras chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUPrimitiveStateExtras polygonMode] : [PolygonMode.t] *)
  let polygonMode = Ctypes.field t "polygonMode" PolygonMode.t

  (** [WGPUPrimitiveStateExtras conservative] : [Unsigned.UInt32.t] *)
  let conservative = Ctypes.field t "conservative" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "polygonMode"; "conservative"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUImageSubresourceRange] (from wgpu.h) *)
module ImageSubresourceRange = struct
  let c_name = "WGPUImageSubresourceRange"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUImageSubresourceRange"

  (** [WGPUImageSubresourceRange aspect] : [TextureAspect.t] *)
  let aspect = Ctypes.field t "aspect" TextureAspect.t

  (** [WGPUImageSubresourceRange baseMipLevel] : [Unsigned.UInt32.t] *)
  let baseMipLevel = Ctypes.field t "baseMipLevel" Ctypes.uint32_t

  (** [WGPUImageSubresourceRange mipLevelCount] : [Unsigned.UInt32.t] *)
  let mipLevelCount = Ctypes.field t "mipLevelCount" Ctypes.uint32_t

  (** [WGPUImageSubresourceRange baseArrayLayer] : [Unsigned.UInt32.t] *)
  let baseArrayLayer = Ctypes.field t "baseArrayLayer" Ctypes.uint32_t

  (** [WGPUImageSubresourceRange arrayLayerCount] : [Unsigned.UInt32.t] *)
  let arrayLayerCount = Ctypes.field t "arrayLayerCount" Ctypes.uint32_t

  let () = Ctypes.seal t

  let field_names = [ "aspect"; "baseMipLevel"; "mipLevelCount"; "baseArrayLayer"; "arrayLayerCount"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUSamplerDescriptorExtras] (from wgpu.h) *)
module SamplerDescriptorExtras = struct
  let c_name = "WGPUSamplerDescriptorExtras"

  type s

  type t = s Ctypes.structure

  let t : t Ctypes.typ = Ctypes.structure "WGPUSamplerDescriptorExtras"

  (** [WGPUSamplerDescriptorExtras chain] : [ChainedStruct.t] *)
  let chain = Ctypes.field t "chain" ChainedStruct.t

  (** [WGPUSamplerDescriptorExtras samplerBorderColor] : [SamplerBorderColor.t] *)
  let samplerBorderColor = Ctypes.field t "samplerBorderColor" SamplerBorderColor.t

  let () = Ctypes.seal t

  let field_names = [ "chain"; "samplerBorderColor"; ]

  (* The header has no WGPU_*_INIT macro for this struct: all-zero it is. *)
  let init () : t = zeroed t
end

(** [WGPUProc] (from webgpu.h) *)
module Proc = struct
  let c_name = "WGPUProc"

  (** The C signature, as a ctypes function type. *)
  let fn : (unit -> unit) Ctypes.fn = Ctypes.(Ctypes.void @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (unit -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCreateInstance] (from webgpu.h) *)
module ProcCreateInstance = struct
  let c_name = "WGPUProcCreateInstance"

  (** The C signature, as a ctypes function type. *)
  let fn : (InstanceDescriptor.t Ctypes.ptr -> Instance.t) Ctypes.fn = Ctypes.((Ctypes.ptr InstanceDescriptor.t) @-> Ctypes.returning Instance.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (InstanceDescriptor.t Ctypes.ptr -> Instance.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcGetInstanceFeatures] (from webgpu.h) *)
module ProcGetInstanceFeatures = struct
  let c_name = "WGPUProcGetInstanceFeatures"

  (** The C signature, as a ctypes function type. *)
  let fn : (SupportedInstanceFeatures.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.((Ctypes.ptr SupportedInstanceFeatures.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (SupportedInstanceFeatures.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcGetInstanceLimits] (from webgpu.h) *)
module ProcGetInstanceLimits = struct
  let c_name = "WGPUProcGetInstanceLimits"

  (** The C signature, as a ctypes function type. *)
  let fn : (InstanceLimits.t Ctypes.ptr -> Status.t) Ctypes.fn = Ctypes.((Ctypes.ptr InstanceLimits.t) @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (InstanceLimits.t Ctypes.ptr -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcHasInstanceFeature] (from webgpu.h) *)
module ProcHasInstanceFeature = struct
  let c_name = "WGPUProcHasInstanceFeature"

  (** The C signature, as a ctypes function type. *)
  let fn : (InstanceFeatureName.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(InstanceFeatureName.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (InstanceFeatureName.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcGetProcAddress] (from webgpu.h) *)
module ProcGetProcAddress = struct
  let c_name = "WGPUProcGetProcAddress"

  (** The C signature, as a ctypes function type. *)
  let fn : (StringView.t -> Proc.t) Ctypes.fn = Ctypes.(StringView.t @-> Ctypes.returning Proc.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (StringView.t -> Proc.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcAdapterGetFeatures] (from webgpu.h) *)
module ProcAdapterGetFeatures = struct
  let c_name = "WGPUProcAdapterGetFeatures"

  (** The C signature, as a ctypes function type. *)
  let fn : (Adapter.t -> SupportedFeatures.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(Adapter.t @-> (Ctypes.ptr SupportedFeatures.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Adapter.t -> SupportedFeatures.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcAdapterGetInfo] (from webgpu.h) *)
module ProcAdapterGetInfo = struct
  let c_name = "WGPUProcAdapterGetInfo"

  (** The C signature, as a ctypes function type. *)
  let fn : (Adapter.t -> AdapterInfo.t Ctypes.ptr -> Status.t) Ctypes.fn = Ctypes.(Adapter.t @-> (Ctypes.ptr AdapterInfo.t) @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Adapter.t -> AdapterInfo.t Ctypes.ptr -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcAdapterGetLimits] (from webgpu.h) *)
module ProcAdapterGetLimits = struct
  let c_name = "WGPUProcAdapterGetLimits"

  (** The C signature, as a ctypes function type. *)
  let fn : (Adapter.t -> Limits.t Ctypes.ptr -> Status.t) Ctypes.fn = Ctypes.(Adapter.t @-> (Ctypes.ptr Limits.t) @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Adapter.t -> Limits.t Ctypes.ptr -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcAdapterHasFeature] (from webgpu.h) *)
module ProcAdapterHasFeature = struct
  let c_name = "WGPUProcAdapterHasFeature"

  (** The C signature, as a ctypes function type. *)
  let fn : (Adapter.t -> FeatureName.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(Adapter.t @-> FeatureName.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Adapter.t -> FeatureName.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcAdapterRequestDevice] (from webgpu.h) *)
module ProcAdapterRequestDevice = struct
  let c_name = "WGPUProcAdapterRequestDevice"

  (** The C signature, as a ctypes function type. *)
  let fn : (Adapter.t -> DeviceDescriptor.t Ctypes.ptr -> RequestDeviceCallbackInfo.t -> Future.t) Ctypes.fn = Ctypes.(Adapter.t @-> (Ctypes.ptr DeviceDescriptor.t) @-> RequestDeviceCallbackInfo.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Adapter.t -> DeviceDescriptor.t Ctypes.ptr -> RequestDeviceCallbackInfo.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcAdapterAddRef] (from webgpu.h) *)
module ProcAdapterAddRef = struct
  let c_name = "WGPUProcAdapterAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (Adapter.t -> unit) Ctypes.fn = Ctypes.(Adapter.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Adapter.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcAdapterRelease] (from webgpu.h) *)
module ProcAdapterRelease = struct
  let c_name = "WGPUProcAdapterRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (Adapter.t -> unit) Ctypes.fn = Ctypes.(Adapter.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Adapter.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcAdapterInfoFreeMembers] (from webgpu.h) *)
module ProcAdapterInfoFreeMembers = struct
  let c_name = "WGPUProcAdapterInfoFreeMembers"

  (** The C signature, as a ctypes function type. *)
  let fn : (AdapterInfo.t -> unit) Ctypes.fn = Ctypes.(AdapterInfo.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (AdapterInfo.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBindGroupSetLabel] (from webgpu.h) *)
module ProcBindGroupSetLabel = struct
  let c_name = "WGPUProcBindGroupSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (BindGroup.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(BindGroup.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (BindGroup.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBindGroupAddRef] (from webgpu.h) *)
module ProcBindGroupAddRef = struct
  let c_name = "WGPUProcBindGroupAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (BindGroup.t -> unit) Ctypes.fn = Ctypes.(BindGroup.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (BindGroup.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBindGroupRelease] (from webgpu.h) *)
module ProcBindGroupRelease = struct
  let c_name = "WGPUProcBindGroupRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (BindGroup.t -> unit) Ctypes.fn = Ctypes.(BindGroup.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (BindGroup.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBindGroupLayoutSetLabel] (from webgpu.h) *)
module ProcBindGroupLayoutSetLabel = struct
  let c_name = "WGPUProcBindGroupLayoutSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (BindGroupLayout.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(BindGroupLayout.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (BindGroupLayout.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBindGroupLayoutAddRef] (from webgpu.h) *)
module ProcBindGroupLayoutAddRef = struct
  let c_name = "WGPUProcBindGroupLayoutAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (BindGroupLayout.t -> unit) Ctypes.fn = Ctypes.(BindGroupLayout.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (BindGroupLayout.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBindGroupLayoutRelease] (from webgpu.h) *)
module ProcBindGroupLayoutRelease = struct
  let c_name = "WGPUProcBindGroupLayoutRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (BindGroupLayout.t -> unit) Ctypes.fn = Ctypes.(BindGroupLayout.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (BindGroupLayout.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferDestroy] (from webgpu.h) *)
module ProcBufferDestroy = struct
  let c_name = "WGPUProcBufferDestroy"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> unit) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferGetConstMappedRange] (from webgpu.h) *)
module ProcBufferGetConstMappedRange = struct
  let c_name = "WGPUProcBufferGetConstMappedRange"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> Unsigned.Size_t.t -> Unsigned.Size_t.t -> unit Ctypes.ptr) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.size_t @-> Ctypes.size_t @-> Ctypes.returning (Ctypes.ptr Ctypes.void))

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> Unsigned.Size_t.t -> Unsigned.Size_t.t -> unit Ctypes.ptr) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferGetMappedRange] (from webgpu.h) *)
module ProcBufferGetMappedRange = struct
  let c_name = "WGPUProcBufferGetMappedRange"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> Unsigned.Size_t.t -> Unsigned.Size_t.t -> unit Ctypes.ptr) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.size_t @-> Ctypes.size_t @-> Ctypes.returning (Ctypes.ptr Ctypes.void))

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> Unsigned.Size_t.t -> Unsigned.Size_t.t -> unit Ctypes.ptr) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferGetMapState] (from webgpu.h) *)
module ProcBufferGetMapState = struct
  let c_name = "WGPUProcBufferGetMapState"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> BufferMapState.t) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.returning BufferMapState.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> BufferMapState.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferGetSize] (from webgpu.h) *)
module ProcBufferGetSize = struct
  let c_name = "WGPUProcBufferGetSize"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> Unsigned.UInt64.t) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.uint64_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> Unsigned.UInt64.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferGetUsage] (from webgpu.h) *)
module ProcBufferGetUsage = struct
  let c_name = "WGPUProcBufferGetUsage"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> BufferUsage.t) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.returning BufferUsage.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> BufferUsage.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferMapAsync] (from webgpu.h) *)
module ProcBufferMapAsync = struct
  let c_name = "WGPUProcBufferMapAsync"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> MapMode.t -> Unsigned.Size_t.t -> Unsigned.Size_t.t -> BufferMapCallbackInfo.t -> Future.t) Ctypes.fn = Ctypes.(Buffer.t @-> MapMode.t @-> Ctypes.size_t @-> Ctypes.size_t @-> BufferMapCallbackInfo.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> MapMode.t -> Unsigned.Size_t.t -> Unsigned.Size_t.t -> BufferMapCallbackInfo.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferReadMappedRange] (from webgpu.h) *)
module ProcBufferReadMappedRange = struct
  let c_name = "WGPUProcBufferReadMappedRange"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> Unsigned.Size_t.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> Status.t) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> Unsigned.Size_t.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferSetLabel] (from webgpu.h) *)
module ProcBufferSetLabel = struct
  let c_name = "WGPUProcBufferSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(Buffer.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferUnmap] (from webgpu.h) *)
module ProcBufferUnmap = struct
  let c_name = "WGPUProcBufferUnmap"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> unit) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferWriteMappedRange] (from webgpu.h) *)
module ProcBufferWriteMappedRange = struct
  let c_name = "WGPUProcBufferWriteMappedRange"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> Unsigned.Size_t.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> Status.t) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> Unsigned.Size_t.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferAddRef] (from webgpu.h) *)
module ProcBufferAddRef = struct
  let c_name = "WGPUProcBufferAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> unit) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcBufferRelease] (from webgpu.h) *)
module ProcBufferRelease = struct
  let c_name = "WGPUProcBufferRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (Buffer.t -> unit) Ctypes.fn = Ctypes.(Buffer.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Buffer.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandBufferSetLabel] (from webgpu.h) *)
module ProcCommandBufferSetLabel = struct
  let c_name = "WGPUProcCommandBufferSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandBuffer.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(CommandBuffer.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandBuffer.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandBufferAddRef] (from webgpu.h) *)
module ProcCommandBufferAddRef = struct
  let c_name = "WGPUProcCommandBufferAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandBuffer.t -> unit) Ctypes.fn = Ctypes.(CommandBuffer.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandBuffer.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandBufferRelease] (from webgpu.h) *)
module ProcCommandBufferRelease = struct
  let c_name = "WGPUProcCommandBufferRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandBuffer.t -> unit) Ctypes.fn = Ctypes.(CommandBuffer.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandBuffer.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderBeginComputePass] (from webgpu.h) *)
module ProcCommandEncoderBeginComputePass = struct
  let c_name = "WGPUProcCommandEncoderBeginComputePass"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> ComputePassDescriptor.t Ctypes.ptr -> ComputePassEncoder.t) Ctypes.fn = Ctypes.(CommandEncoder.t @-> (Ctypes.ptr ComputePassDescriptor.t) @-> Ctypes.returning ComputePassEncoder.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> ComputePassDescriptor.t Ctypes.ptr -> ComputePassEncoder.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderBeginRenderPass] (from webgpu.h) *)
module ProcCommandEncoderBeginRenderPass = struct
  let c_name = "WGPUProcCommandEncoderBeginRenderPass"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> RenderPassDescriptor.t Ctypes.ptr -> RenderPassEncoder.t) Ctypes.fn = Ctypes.(CommandEncoder.t @-> (Ctypes.ptr RenderPassDescriptor.t) @-> Ctypes.returning RenderPassEncoder.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> RenderPassDescriptor.t Ctypes.ptr -> RenderPassEncoder.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderClearBuffer] (from webgpu.h) *)
module ProcCommandEncoderClearBuffer = struct
  let c_name = "WGPUProcCommandEncoderClearBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderCopyBufferToBuffer] (from webgpu.h) *)
module ProcCommandEncoderCopyBufferToBuffer = struct
  let c_name = "WGPUProcCommandEncoderCopyBufferToBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> Buffer.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> Buffer.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderCopyBufferToTexture] (from webgpu.h) *)
module ProcCommandEncoderCopyBufferToTexture = struct
  let c_name = "WGPUProcCommandEncoderCopyBufferToTexture"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> TexelCopyBufferInfo.t Ctypes.ptr -> TexelCopyTextureInfo.t Ctypes.ptr -> Extent3D.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> (Ctypes.ptr TexelCopyBufferInfo.t) @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr Extent3D.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> TexelCopyBufferInfo.t Ctypes.ptr -> TexelCopyTextureInfo.t Ctypes.ptr -> Extent3D.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderCopyTextureToBuffer] (from webgpu.h) *)
module ProcCommandEncoderCopyTextureToBuffer = struct
  let c_name = "WGPUProcCommandEncoderCopyTextureToBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> TexelCopyTextureInfo.t Ctypes.ptr -> TexelCopyBufferInfo.t Ctypes.ptr -> Extent3D.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr TexelCopyBufferInfo.t) @-> (Ctypes.ptr Extent3D.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> TexelCopyTextureInfo.t Ctypes.ptr -> TexelCopyBufferInfo.t Ctypes.ptr -> Extent3D.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderCopyTextureToTexture] (from webgpu.h) *)
module ProcCommandEncoderCopyTextureToTexture = struct
  let c_name = "WGPUProcCommandEncoderCopyTextureToTexture"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> TexelCopyTextureInfo.t Ctypes.ptr -> TexelCopyTextureInfo.t Ctypes.ptr -> Extent3D.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr Extent3D.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> TexelCopyTextureInfo.t Ctypes.ptr -> TexelCopyTextureInfo.t Ctypes.ptr -> Extent3D.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderFinish] (from webgpu.h) *)
module ProcCommandEncoderFinish = struct
  let c_name = "WGPUProcCommandEncoderFinish"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> CommandBufferDescriptor.t Ctypes.ptr -> CommandBuffer.t) Ctypes.fn = Ctypes.(CommandEncoder.t @-> (Ctypes.ptr CommandBufferDescriptor.t) @-> Ctypes.returning CommandBuffer.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> CommandBufferDescriptor.t Ctypes.ptr -> CommandBuffer.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderInsertDebugMarker] (from webgpu.h) *)
module ProcCommandEncoderInsertDebugMarker = struct
  let c_name = "WGPUProcCommandEncoderInsertDebugMarker"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderPopDebugGroup] (from webgpu.h) *)
module ProcCommandEncoderPopDebugGroup = struct
  let c_name = "WGPUProcCommandEncoderPopDebugGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderPushDebugGroup] (from webgpu.h) *)
module ProcCommandEncoderPushDebugGroup = struct
  let c_name = "WGPUProcCommandEncoderPushDebugGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderResolveQuerySet] (from webgpu.h) *)
module ProcCommandEncoderResolveQuerySet = struct
  let c_name = "WGPUProcCommandEncoderResolveQuerySet"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> QuerySet.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> QuerySet.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> QuerySet.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderSetLabel] (from webgpu.h) *)
module ProcCommandEncoderSetLabel = struct
  let c_name = "WGPUProcCommandEncoderSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderWriteTimestamp] (from webgpu.h) *)
module ProcCommandEncoderWriteTimestamp = struct
  let c_name = "WGPUProcCommandEncoderWriteTimestamp"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> QuerySet.t -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> QuerySet.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> QuerySet.t -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderAddRef] (from webgpu.h) *)
module ProcCommandEncoderAddRef = struct
  let c_name = "WGPUProcCommandEncoderAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcCommandEncoderRelease] (from webgpu.h) *)
module ProcCommandEncoderRelease = struct
  let c_name = "WGPUProcCommandEncoderRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (CommandEncoder.t -> unit) Ctypes.fn = Ctypes.(CommandEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (CommandEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderDispatchWorkgroups] (from webgpu.h) *)
module ProcComputePassEncoderDispatchWorkgroups = struct
  let c_name = "WGPUProcComputePassEncoderDispatchWorkgroups"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderDispatchWorkgroupsIndirect] (from webgpu.h) *)
module ProcComputePassEncoderDispatchWorkgroupsIndirect = struct
  let c_name = "WGPUProcComputePassEncoderDispatchWorkgroupsIndirect"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderEnd] (from webgpu.h) *)
module ProcComputePassEncoderEnd = struct
  let c_name = "WGPUProcComputePassEncoderEnd"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderInsertDebugMarker] (from webgpu.h) *)
module ProcComputePassEncoderInsertDebugMarker = struct
  let c_name = "WGPUProcComputePassEncoderInsertDebugMarker"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderPopDebugGroup] (from webgpu.h) *)
module ProcComputePassEncoderPopDebugGroup = struct
  let c_name = "WGPUProcComputePassEncoderPopDebugGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderPushDebugGroup] (from webgpu.h) *)
module ProcComputePassEncoderPushDebugGroup = struct
  let c_name = "WGPUProcComputePassEncoderPushDebugGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderSetBindGroup] (from webgpu.h) *)
module ProcComputePassEncoderSetBindGroup = struct
  let c_name = "WGPUProcComputePassEncoderSetBindGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> Unsigned.UInt32.t -> BindGroup.t -> Unsigned.Size_t.t -> Unsigned.UInt32.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> Ctypes.uint32_t @-> BindGroup.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.uint32_t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> Unsigned.UInt32.t -> BindGroup.t -> Unsigned.Size_t.t -> Unsigned.UInt32.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderSetImmediates] (from webgpu.h) *)
module ProcComputePassEncoderSetImmediates = struct
  let c_name = "WGPUProcComputePassEncoderSetImmediates"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> Unsigned.UInt32.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> Ctypes.uint32_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> Unsigned.UInt32.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderSetLabel] (from webgpu.h) *)
module ProcComputePassEncoderSetLabel = struct
  let c_name = "WGPUProcComputePassEncoderSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderSetPipeline] (from webgpu.h) *)
module ProcComputePassEncoderSetPipeline = struct
  let c_name = "WGPUProcComputePassEncoderSetPipeline"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> ComputePipeline.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> ComputePipeline.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> ComputePipeline.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderAddRef] (from webgpu.h) *)
module ProcComputePassEncoderAddRef = struct
  let c_name = "WGPUProcComputePassEncoderAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePassEncoderRelease] (from webgpu.h) *)
module ProcComputePassEncoderRelease = struct
  let c_name = "WGPUProcComputePassEncoderRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePassEncoder.t -> unit) Ctypes.fn = Ctypes.(ComputePassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePipelineGetBindGroupLayout] (from webgpu.h) *)
module ProcComputePipelineGetBindGroupLayout = struct
  let c_name = "WGPUProcComputePipelineGetBindGroupLayout"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePipeline.t -> Unsigned.UInt32.t -> BindGroupLayout.t) Ctypes.fn = Ctypes.(ComputePipeline.t @-> Ctypes.uint32_t @-> Ctypes.returning BindGroupLayout.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePipeline.t -> Unsigned.UInt32.t -> BindGroupLayout.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePipelineSetLabel] (from webgpu.h) *)
module ProcComputePipelineSetLabel = struct
  let c_name = "WGPUProcComputePipelineSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePipeline.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(ComputePipeline.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePipeline.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePipelineAddRef] (from webgpu.h) *)
module ProcComputePipelineAddRef = struct
  let c_name = "WGPUProcComputePipelineAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePipeline.t -> unit) Ctypes.fn = Ctypes.(ComputePipeline.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePipeline.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcComputePipelineRelease] (from webgpu.h) *)
module ProcComputePipelineRelease = struct
  let c_name = "WGPUProcComputePipelineRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (ComputePipeline.t -> unit) Ctypes.fn = Ctypes.(ComputePipeline.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ComputePipeline.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateBindGroup] (from webgpu.h) *)
module ProcDeviceCreateBindGroup = struct
  let c_name = "WGPUProcDeviceCreateBindGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> BindGroupDescriptor.t Ctypes.ptr -> BindGroup.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr BindGroupDescriptor.t) @-> Ctypes.returning BindGroup.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> BindGroupDescriptor.t Ctypes.ptr -> BindGroup.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateBindGroupLayout] (from webgpu.h) *)
module ProcDeviceCreateBindGroupLayout = struct
  let c_name = "WGPUProcDeviceCreateBindGroupLayout"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> BindGroupLayoutDescriptor.t Ctypes.ptr -> BindGroupLayout.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr BindGroupLayoutDescriptor.t) @-> Ctypes.returning BindGroupLayout.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> BindGroupLayoutDescriptor.t Ctypes.ptr -> BindGroupLayout.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateBuffer] (from webgpu.h) *)
module ProcDeviceCreateBuffer = struct
  let c_name = "WGPUProcDeviceCreateBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> BufferDescriptor.t Ctypes.ptr -> Buffer.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr BufferDescriptor.t) @-> Ctypes.returning Buffer.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> BufferDescriptor.t Ctypes.ptr -> Buffer.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateCommandEncoder] (from webgpu.h) *)
module ProcDeviceCreateCommandEncoder = struct
  let c_name = "WGPUProcDeviceCreateCommandEncoder"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> CommandEncoderDescriptor.t Ctypes.ptr -> CommandEncoder.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr CommandEncoderDescriptor.t) @-> Ctypes.returning CommandEncoder.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> CommandEncoderDescriptor.t Ctypes.ptr -> CommandEncoder.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateComputePipeline] (from webgpu.h) *)
module ProcDeviceCreateComputePipeline = struct
  let c_name = "WGPUProcDeviceCreateComputePipeline"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> ComputePipelineDescriptor.t Ctypes.ptr -> ComputePipeline.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr ComputePipelineDescriptor.t) @-> Ctypes.returning ComputePipeline.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> ComputePipelineDescriptor.t Ctypes.ptr -> ComputePipeline.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateComputePipelineAsync] (from webgpu.h) *)
module ProcDeviceCreateComputePipelineAsync = struct
  let c_name = "WGPUProcDeviceCreateComputePipelineAsync"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> ComputePipelineDescriptor.t Ctypes.ptr -> CreateComputePipelineAsyncCallbackInfo.t -> Future.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr ComputePipelineDescriptor.t) @-> CreateComputePipelineAsyncCallbackInfo.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> ComputePipelineDescriptor.t Ctypes.ptr -> CreateComputePipelineAsyncCallbackInfo.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreatePipelineLayout] (from webgpu.h) *)
module ProcDeviceCreatePipelineLayout = struct
  let c_name = "WGPUProcDeviceCreatePipelineLayout"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> PipelineLayoutDescriptor.t Ctypes.ptr -> PipelineLayout.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr PipelineLayoutDescriptor.t) @-> Ctypes.returning PipelineLayout.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> PipelineLayoutDescriptor.t Ctypes.ptr -> PipelineLayout.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateQuerySet] (from webgpu.h) *)
module ProcDeviceCreateQuerySet = struct
  let c_name = "WGPUProcDeviceCreateQuerySet"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> QuerySetDescriptor.t Ctypes.ptr -> QuerySet.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr QuerySetDescriptor.t) @-> Ctypes.returning QuerySet.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> QuerySetDescriptor.t Ctypes.ptr -> QuerySet.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateRenderBundleEncoder] (from webgpu.h) *)
module ProcDeviceCreateRenderBundleEncoder = struct
  let c_name = "WGPUProcDeviceCreateRenderBundleEncoder"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> RenderBundleEncoderDescriptor.t Ctypes.ptr -> RenderBundleEncoder.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr RenderBundleEncoderDescriptor.t) @-> Ctypes.returning RenderBundleEncoder.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> RenderBundleEncoderDescriptor.t Ctypes.ptr -> RenderBundleEncoder.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateRenderPipeline] (from webgpu.h) *)
module ProcDeviceCreateRenderPipeline = struct
  let c_name = "WGPUProcDeviceCreateRenderPipeline"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> RenderPipelineDescriptor.t Ctypes.ptr -> RenderPipeline.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr RenderPipelineDescriptor.t) @-> Ctypes.returning RenderPipeline.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> RenderPipelineDescriptor.t Ctypes.ptr -> RenderPipeline.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateRenderPipelineAsync] (from webgpu.h) *)
module ProcDeviceCreateRenderPipelineAsync = struct
  let c_name = "WGPUProcDeviceCreateRenderPipelineAsync"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> RenderPipelineDescriptor.t Ctypes.ptr -> CreateRenderPipelineAsyncCallbackInfo.t -> Future.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr RenderPipelineDescriptor.t) @-> CreateRenderPipelineAsyncCallbackInfo.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> RenderPipelineDescriptor.t Ctypes.ptr -> CreateRenderPipelineAsyncCallbackInfo.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateSampler] (from webgpu.h) *)
module ProcDeviceCreateSampler = struct
  let c_name = "WGPUProcDeviceCreateSampler"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> SamplerDescriptor.t Ctypes.ptr -> Sampler.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr SamplerDescriptor.t) @-> Ctypes.returning Sampler.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> SamplerDescriptor.t Ctypes.ptr -> Sampler.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateShaderModule] (from webgpu.h) *)
module ProcDeviceCreateShaderModule = struct
  let c_name = "WGPUProcDeviceCreateShaderModule"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> ShaderModuleDescriptor.t Ctypes.ptr -> ShaderModule.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr ShaderModuleDescriptor.t) @-> Ctypes.returning ShaderModule.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> ShaderModuleDescriptor.t Ctypes.ptr -> ShaderModule.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceCreateTexture] (from webgpu.h) *)
module ProcDeviceCreateTexture = struct
  let c_name = "WGPUProcDeviceCreateTexture"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> TextureDescriptor.t Ctypes.ptr -> Texture.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr TextureDescriptor.t) @-> Ctypes.returning Texture.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> TextureDescriptor.t Ctypes.ptr -> Texture.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceDestroy] (from webgpu.h) *)
module ProcDeviceDestroy = struct
  let c_name = "WGPUProcDeviceDestroy"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> unit) Ctypes.fn = Ctypes.(Device.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceGetAdapterInfo] (from webgpu.h) *)
module ProcDeviceGetAdapterInfo = struct
  let c_name = "WGPUProcDeviceGetAdapterInfo"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> AdapterInfo.t Ctypes.ptr -> Status.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr AdapterInfo.t) @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> AdapterInfo.t Ctypes.ptr -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceGetFeatures] (from webgpu.h) *)
module ProcDeviceGetFeatures = struct
  let c_name = "WGPUProcDeviceGetFeatures"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> SupportedFeatures.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr SupportedFeatures.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> SupportedFeatures.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceGetLimits] (from webgpu.h) *)
module ProcDeviceGetLimits = struct
  let c_name = "WGPUProcDeviceGetLimits"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> Limits.t Ctypes.ptr -> Status.t) Ctypes.fn = Ctypes.(Device.t @-> (Ctypes.ptr Limits.t) @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> Limits.t Ctypes.ptr -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceGetLostFuture] (from webgpu.h) *)
module ProcDeviceGetLostFuture = struct
  let c_name = "WGPUProcDeviceGetLostFuture"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> Future.t) Ctypes.fn = Ctypes.(Device.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceGetQueue] (from webgpu.h) *)
module ProcDeviceGetQueue = struct
  let c_name = "WGPUProcDeviceGetQueue"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> Queue.t) Ctypes.fn = Ctypes.(Device.t @-> Ctypes.returning Queue.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> Queue.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceHasFeature] (from webgpu.h) *)
module ProcDeviceHasFeature = struct
  let c_name = "WGPUProcDeviceHasFeature"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> FeatureName.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(Device.t @-> FeatureName.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> FeatureName.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDevicePopErrorScope] (from webgpu.h) *)
module ProcDevicePopErrorScope = struct
  let c_name = "WGPUProcDevicePopErrorScope"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> PopErrorScopeCallbackInfo.t -> Future.t) Ctypes.fn = Ctypes.(Device.t @-> PopErrorScopeCallbackInfo.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> PopErrorScopeCallbackInfo.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDevicePushErrorScope] (from webgpu.h) *)
module ProcDevicePushErrorScope = struct
  let c_name = "WGPUProcDevicePushErrorScope"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> ErrorFilter.t -> unit) Ctypes.fn = Ctypes.(Device.t @-> ErrorFilter.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> ErrorFilter.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceSetLabel] (from webgpu.h) *)
module ProcDeviceSetLabel = struct
  let c_name = "WGPUProcDeviceSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(Device.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceAddRef] (from webgpu.h) *)
module ProcDeviceAddRef = struct
  let c_name = "WGPUProcDeviceAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> unit) Ctypes.fn = Ctypes.(Device.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcDeviceRelease] (from webgpu.h) *)
module ProcDeviceRelease = struct
  let c_name = "WGPUProcDeviceRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (Device.t -> unit) Ctypes.fn = Ctypes.(Device.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Device.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcExternalTextureSetLabel] (from webgpu.h) *)
module ProcExternalTextureSetLabel = struct
  let c_name = "WGPUProcExternalTextureSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (ExternalTexture.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(ExternalTexture.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ExternalTexture.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcExternalTextureAddRef] (from webgpu.h) *)
module ProcExternalTextureAddRef = struct
  let c_name = "WGPUProcExternalTextureAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (ExternalTexture.t -> unit) Ctypes.fn = Ctypes.(ExternalTexture.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ExternalTexture.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcExternalTextureRelease] (from webgpu.h) *)
module ProcExternalTextureRelease = struct
  let c_name = "WGPUProcExternalTextureRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (ExternalTexture.t -> unit) Ctypes.fn = Ctypes.(ExternalTexture.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ExternalTexture.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcInstanceCreateSurface] (from webgpu.h) *)
module ProcInstanceCreateSurface = struct
  let c_name = "WGPUProcInstanceCreateSurface"

  (** The C signature, as a ctypes function type. *)
  let fn : (Instance.t -> SurfaceDescriptor.t Ctypes.ptr -> Surface.t) Ctypes.fn = Ctypes.(Instance.t @-> (Ctypes.ptr SurfaceDescriptor.t) @-> Ctypes.returning Surface.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Instance.t -> SurfaceDescriptor.t Ctypes.ptr -> Surface.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcInstanceGetWGSLLanguageFeatures] (from webgpu.h) *)
module ProcInstanceGetWGSLLanguageFeatures = struct
  let c_name = "WGPUProcInstanceGetWGSLLanguageFeatures"

  (** The C signature, as a ctypes function type. *)
  let fn : (Instance.t -> SupportedWGSLLanguageFeatures.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(Instance.t @-> (Ctypes.ptr SupportedWGSLLanguageFeatures.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Instance.t -> SupportedWGSLLanguageFeatures.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcInstanceHasWGSLLanguageFeature] (from webgpu.h) *)
module ProcInstanceHasWGSLLanguageFeature = struct
  let c_name = "WGPUProcInstanceHasWGSLLanguageFeature"

  (** The C signature, as a ctypes function type. *)
  let fn : (Instance.t -> WGSLLanguageFeatureName.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(Instance.t @-> WGSLLanguageFeatureName.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Instance.t -> WGSLLanguageFeatureName.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcInstanceProcessEvents] (from webgpu.h) *)
module ProcInstanceProcessEvents = struct
  let c_name = "WGPUProcInstanceProcessEvents"

  (** The C signature, as a ctypes function type. *)
  let fn : (Instance.t -> unit) Ctypes.fn = Ctypes.(Instance.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Instance.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcInstanceRequestAdapter] (from webgpu.h) *)
module ProcInstanceRequestAdapter = struct
  let c_name = "WGPUProcInstanceRequestAdapter"

  (** The C signature, as a ctypes function type. *)
  let fn : (Instance.t -> RequestAdapterOptions.t Ctypes.ptr -> RequestAdapterCallbackInfo.t -> Future.t) Ctypes.fn = Ctypes.(Instance.t @-> (Ctypes.ptr RequestAdapterOptions.t) @-> RequestAdapterCallbackInfo.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Instance.t -> RequestAdapterOptions.t Ctypes.ptr -> RequestAdapterCallbackInfo.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcInstanceWaitAny] (from webgpu.h) *)
module ProcInstanceWaitAny = struct
  let c_name = "WGPUProcInstanceWaitAny"

  (** The C signature, as a ctypes function type. *)
  let fn : (Instance.t -> Unsigned.Size_t.t -> FutureWaitInfo.t Ctypes.ptr -> Unsigned.UInt64.t -> WaitStatus.t) Ctypes.fn = Ctypes.(Instance.t @-> Ctypes.size_t @-> (Ctypes.ptr FutureWaitInfo.t) @-> Ctypes.uint64_t @-> Ctypes.returning WaitStatus.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Instance.t -> Unsigned.Size_t.t -> FutureWaitInfo.t Ctypes.ptr -> Unsigned.UInt64.t -> WaitStatus.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcInstanceAddRef] (from webgpu.h) *)
module ProcInstanceAddRef = struct
  let c_name = "WGPUProcInstanceAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (Instance.t -> unit) Ctypes.fn = Ctypes.(Instance.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Instance.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcInstanceRelease] (from webgpu.h) *)
module ProcInstanceRelease = struct
  let c_name = "WGPUProcInstanceRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (Instance.t -> unit) Ctypes.fn = Ctypes.(Instance.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Instance.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcPipelineLayoutSetLabel] (from webgpu.h) *)
module ProcPipelineLayoutSetLabel = struct
  let c_name = "WGPUProcPipelineLayoutSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (PipelineLayout.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(PipelineLayout.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (PipelineLayout.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcPipelineLayoutAddRef] (from webgpu.h) *)
module ProcPipelineLayoutAddRef = struct
  let c_name = "WGPUProcPipelineLayoutAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (PipelineLayout.t -> unit) Ctypes.fn = Ctypes.(PipelineLayout.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (PipelineLayout.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcPipelineLayoutRelease] (from webgpu.h) *)
module ProcPipelineLayoutRelease = struct
  let c_name = "WGPUProcPipelineLayoutRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (PipelineLayout.t -> unit) Ctypes.fn = Ctypes.(PipelineLayout.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (PipelineLayout.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQuerySetDestroy] (from webgpu.h) *)
module ProcQuerySetDestroy = struct
  let c_name = "WGPUProcQuerySetDestroy"

  (** The C signature, as a ctypes function type. *)
  let fn : (QuerySet.t -> unit) Ctypes.fn = Ctypes.(QuerySet.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (QuerySet.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQuerySetGetCount] (from webgpu.h) *)
module ProcQuerySetGetCount = struct
  let c_name = "WGPUProcQuerySetGetCount"

  (** The C signature, as a ctypes function type. *)
  let fn : (QuerySet.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(QuerySet.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (QuerySet.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQuerySetGetType] (from webgpu.h) *)
module ProcQuerySetGetType = struct
  let c_name = "WGPUProcQuerySetGetType"

  (** The C signature, as a ctypes function type. *)
  let fn : (QuerySet.t -> QueryType.t) Ctypes.fn = Ctypes.(QuerySet.t @-> Ctypes.returning QueryType.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (QuerySet.t -> QueryType.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQuerySetSetLabel] (from webgpu.h) *)
module ProcQuerySetSetLabel = struct
  let c_name = "WGPUProcQuerySetSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (QuerySet.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(QuerySet.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (QuerySet.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQuerySetAddRef] (from webgpu.h) *)
module ProcQuerySetAddRef = struct
  let c_name = "WGPUProcQuerySetAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (QuerySet.t -> unit) Ctypes.fn = Ctypes.(QuerySet.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (QuerySet.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQuerySetRelease] (from webgpu.h) *)
module ProcQuerySetRelease = struct
  let c_name = "WGPUProcQuerySetRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (QuerySet.t -> unit) Ctypes.fn = Ctypes.(QuerySet.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (QuerySet.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQueueOnSubmittedWorkDone] (from webgpu.h) *)
module ProcQueueOnSubmittedWorkDone = struct
  let c_name = "WGPUProcQueueOnSubmittedWorkDone"

  (** The C signature, as a ctypes function type. *)
  let fn : (Queue.t -> QueueWorkDoneCallbackInfo.t -> Future.t) Ctypes.fn = Ctypes.(Queue.t @-> QueueWorkDoneCallbackInfo.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Queue.t -> QueueWorkDoneCallbackInfo.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQueueSetLabel] (from webgpu.h) *)
module ProcQueueSetLabel = struct
  let c_name = "WGPUProcQueueSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (Queue.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(Queue.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Queue.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQueueSubmit] (from webgpu.h) *)
module ProcQueueSubmit = struct
  let c_name = "WGPUProcQueueSubmit"

  (** The C signature, as a ctypes function type. *)
  let fn : (Queue.t -> Unsigned.Size_t.t -> CommandBuffer.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(Queue.t @-> Ctypes.size_t @-> (Ctypes.ptr CommandBuffer.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Queue.t -> Unsigned.Size_t.t -> CommandBuffer.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQueueWriteBuffer] (from webgpu.h) *)
module ProcQueueWriteBuffer = struct
  let c_name = "WGPUProcQueueWriteBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (Queue.t -> Buffer.t -> Unsigned.UInt64.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> unit) Ctypes.fn = Ctypes.(Queue.t @-> Buffer.t @-> Ctypes.uint64_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Queue.t -> Buffer.t -> Unsigned.UInt64.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQueueWriteTexture] (from webgpu.h) *)
module ProcQueueWriteTexture = struct
  let c_name = "WGPUProcQueueWriteTexture"

  (** The C signature, as a ctypes function type. *)
  let fn : (Queue.t -> TexelCopyTextureInfo.t Ctypes.ptr -> unit Ctypes.ptr -> Unsigned.Size_t.t -> TexelCopyBufferLayout.t Ctypes.ptr -> Extent3D.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(Queue.t @-> (Ctypes.ptr TexelCopyTextureInfo.t) @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> (Ctypes.ptr TexelCopyBufferLayout.t) @-> (Ctypes.ptr Extent3D.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Queue.t -> TexelCopyTextureInfo.t Ctypes.ptr -> unit Ctypes.ptr -> Unsigned.Size_t.t -> TexelCopyBufferLayout.t Ctypes.ptr -> Extent3D.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQueueAddRef] (from webgpu.h) *)
module ProcQueueAddRef = struct
  let c_name = "WGPUProcQueueAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (Queue.t -> unit) Ctypes.fn = Ctypes.(Queue.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Queue.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcQueueRelease] (from webgpu.h) *)
module ProcQueueRelease = struct
  let c_name = "WGPUProcQueueRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (Queue.t -> unit) Ctypes.fn = Ctypes.(Queue.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Queue.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleSetLabel] (from webgpu.h) *)
module ProcRenderBundleSetLabel = struct
  let c_name = "WGPUProcRenderBundleSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundle.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(RenderBundle.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundle.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleAddRef] (from webgpu.h) *)
module ProcRenderBundleAddRef = struct
  let c_name = "WGPUProcRenderBundleAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundle.t -> unit) Ctypes.fn = Ctypes.(RenderBundle.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundle.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleRelease] (from webgpu.h) *)
module ProcRenderBundleRelease = struct
  let c_name = "WGPUProcRenderBundleRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundle.t -> unit) Ctypes.fn = Ctypes.(RenderBundle.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundle.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderDraw] (from webgpu.h) *)
module ProcRenderBundleEncoderDraw = struct
  let c_name = "WGPUProcRenderBundleEncoderDraw"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderDrawIndexed] (from webgpu.h) *)
module ProcRenderBundleEncoderDrawIndexed = struct
  let c_name = "WGPUProcRenderBundleEncoderDrawIndexed"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> int32 -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.int32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> int32 -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderDrawIndexedIndirect] (from webgpu.h) *)
module ProcRenderBundleEncoderDrawIndexedIndirect = struct
  let c_name = "WGPUProcRenderBundleEncoderDrawIndexedIndirect"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderDrawIndirect] (from webgpu.h) *)
module ProcRenderBundleEncoderDrawIndirect = struct
  let c_name = "WGPUProcRenderBundleEncoderDrawIndirect"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderFinish] (from webgpu.h) *)
module ProcRenderBundleEncoderFinish = struct
  let c_name = "WGPUProcRenderBundleEncoderFinish"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> RenderBundleDescriptor.t Ctypes.ptr -> RenderBundle.t) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> (Ctypes.ptr RenderBundleDescriptor.t) @-> Ctypes.returning RenderBundle.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> RenderBundleDescriptor.t Ctypes.ptr -> RenderBundle.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderInsertDebugMarker] (from webgpu.h) *)
module ProcRenderBundleEncoderInsertDebugMarker = struct
  let c_name = "WGPUProcRenderBundleEncoderInsertDebugMarker"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderPopDebugGroup] (from webgpu.h) *)
module ProcRenderBundleEncoderPopDebugGroup = struct
  let c_name = "WGPUProcRenderBundleEncoderPopDebugGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderPushDebugGroup] (from webgpu.h) *)
module ProcRenderBundleEncoderPushDebugGroup = struct
  let c_name = "WGPUProcRenderBundleEncoderPushDebugGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderSetBindGroup] (from webgpu.h) *)
module ProcRenderBundleEncoderSetBindGroup = struct
  let c_name = "WGPUProcRenderBundleEncoderSetBindGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> Unsigned.UInt32.t -> BindGroup.t -> Unsigned.Size_t.t -> Unsigned.UInt32.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> BindGroup.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.uint32_t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> Unsigned.UInt32.t -> BindGroup.t -> Unsigned.Size_t.t -> Unsigned.UInt32.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderSetImmediates] (from webgpu.h) *)
module ProcRenderBundleEncoderSetImmediates = struct
  let c_name = "WGPUProcRenderBundleEncoderSetImmediates"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> Unsigned.UInt32.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> Unsigned.UInt32.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderSetIndexBuffer] (from webgpu.h) *)
module ProcRenderBundleEncoderSetIndexBuffer = struct
  let c_name = "WGPUProcRenderBundleEncoderSetIndexBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> Buffer.t -> IndexFormat.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Buffer.t @-> IndexFormat.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> Buffer.t -> IndexFormat.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderSetLabel] (from webgpu.h) *)
module ProcRenderBundleEncoderSetLabel = struct
  let c_name = "WGPUProcRenderBundleEncoderSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderSetPipeline] (from webgpu.h) *)
module ProcRenderBundleEncoderSetPipeline = struct
  let c_name = "WGPUProcRenderBundleEncoderSetPipeline"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> RenderPipeline.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> RenderPipeline.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> RenderPipeline.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderSetVertexBuffer] (from webgpu.h) *)
module ProcRenderBundleEncoderSetVertexBuffer = struct
  let c_name = "WGPUProcRenderBundleEncoderSetVertexBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> Unsigned.UInt32.t -> Buffer.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Ctypes.uint32_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> Unsigned.UInt32.t -> Buffer.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderAddRef] (from webgpu.h) *)
module ProcRenderBundleEncoderAddRef = struct
  let c_name = "WGPUProcRenderBundleEncoderAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderBundleEncoderRelease] (from webgpu.h) *)
module ProcRenderBundleEncoderRelease = struct
  let c_name = "WGPUProcRenderBundleEncoderRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderBundleEncoder.t -> unit) Ctypes.fn = Ctypes.(RenderBundleEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderBundleEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderBeginOcclusionQuery] (from webgpu.h) *)
module ProcRenderPassEncoderBeginOcclusionQuery = struct
  let c_name = "WGPUProcRenderPassEncoderBeginOcclusionQuery"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderDraw] (from webgpu.h) *)
module ProcRenderPassEncoderDraw = struct
  let c_name = "WGPUProcRenderPassEncoderDraw"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderDrawIndexed] (from webgpu.h) *)
module ProcRenderPassEncoderDrawIndexed = struct
  let c_name = "WGPUProcRenderPassEncoderDrawIndexed"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> int32 -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.int32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> int32 -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderDrawIndexedIndirect] (from webgpu.h) *)
module ProcRenderPassEncoderDrawIndexedIndirect = struct
  let c_name = "WGPUProcRenderPassEncoderDrawIndexedIndirect"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderDrawIndirect] (from webgpu.h) *)
module ProcRenderPassEncoderDrawIndirect = struct
  let c_name = "WGPUProcRenderPassEncoderDrawIndirect"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Buffer.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderEnd] (from webgpu.h) *)
module ProcRenderPassEncoderEnd = struct
  let c_name = "WGPUProcRenderPassEncoderEnd"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderEndOcclusionQuery] (from webgpu.h) *)
module ProcRenderPassEncoderEndOcclusionQuery = struct
  let c_name = "WGPUProcRenderPassEncoderEndOcclusionQuery"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderExecuteBundles] (from webgpu.h) *)
module ProcRenderPassEncoderExecuteBundles = struct
  let c_name = "WGPUProcRenderPassEncoderExecuteBundles"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.Size_t.t -> RenderBundle.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.size_t @-> (Ctypes.ptr RenderBundle.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.Size_t.t -> RenderBundle.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderInsertDebugMarker] (from webgpu.h) *)
module ProcRenderPassEncoderInsertDebugMarker = struct
  let c_name = "WGPUProcRenderPassEncoderInsertDebugMarker"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderPopDebugGroup] (from webgpu.h) *)
module ProcRenderPassEncoderPopDebugGroup = struct
  let c_name = "WGPUProcRenderPassEncoderPopDebugGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderPushDebugGroup] (from webgpu.h) *)
module ProcRenderPassEncoderPushDebugGroup = struct
  let c_name = "WGPUProcRenderPassEncoderPushDebugGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetBindGroup] (from webgpu.h) *)
module ProcRenderPassEncoderSetBindGroup = struct
  let c_name = "WGPUProcRenderPassEncoderSetBindGroup"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.UInt32.t -> BindGroup.t -> Unsigned.Size_t.t -> Unsigned.UInt32.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> BindGroup.t @-> Ctypes.size_t @-> (Ctypes.ptr Ctypes.uint32_t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.UInt32.t -> BindGroup.t -> Unsigned.Size_t.t -> Unsigned.UInt32.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetBlendConstant] (from webgpu.h) *)
module ProcRenderPassEncoderSetBlendConstant = struct
  let c_name = "WGPUProcRenderPassEncoderSetBlendConstant"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Color.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> (Ctypes.ptr Color.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Color.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetImmediates] (from webgpu.h) *)
module ProcRenderPassEncoderSetImmediates = struct
  let c_name = "WGPUProcRenderPassEncoderSetImmediates"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.UInt32.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.size_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.UInt32.t -> unit Ctypes.ptr -> Unsigned.Size_t.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetIndexBuffer] (from webgpu.h) *)
module ProcRenderPassEncoderSetIndexBuffer = struct
  let c_name = "WGPUProcRenderPassEncoderSetIndexBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Buffer.t -> IndexFormat.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Buffer.t @-> IndexFormat.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Buffer.t -> IndexFormat.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetLabel] (from webgpu.h) *)
module ProcRenderPassEncoderSetLabel = struct
  let c_name = "WGPUProcRenderPassEncoderSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetPipeline] (from webgpu.h) *)
module ProcRenderPassEncoderSetPipeline = struct
  let c_name = "WGPUProcRenderPassEncoderSetPipeline"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> RenderPipeline.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> RenderPipeline.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> RenderPipeline.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetScissorRect] (from webgpu.h) *)
module ProcRenderPassEncoderSetScissorRect = struct
  let c_name = "WGPUProcRenderPassEncoderSetScissorRect"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetStencilReference] (from webgpu.h) *)
module ProcRenderPassEncoderSetStencilReference = struct
  let c_name = "WGPUProcRenderPassEncoderSetStencilReference"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.UInt32.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.UInt32.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetVertexBuffer] (from webgpu.h) *)
module ProcRenderPassEncoderSetVertexBuffer = struct
  let c_name = "WGPUProcRenderPassEncoderSetVertexBuffer"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> Unsigned.UInt32.t -> Buffer.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.uint32_t @-> Buffer.t @-> Ctypes.uint64_t @-> Ctypes.uint64_t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> Unsigned.UInt32.t -> Buffer.t -> Unsigned.UInt64.t -> Unsigned.UInt64.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderSetViewport] (from webgpu.h) *)
module ProcRenderPassEncoderSetViewport = struct
  let c_name = "WGPUProcRenderPassEncoderSetViewport"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> float -> float -> float -> float -> float -> float -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.float @-> Ctypes.float @-> Ctypes.float @-> Ctypes.float @-> Ctypes.float @-> Ctypes.float @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> float -> float -> float -> float -> float -> float -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderAddRef] (from webgpu.h) *)
module ProcRenderPassEncoderAddRef = struct
  let c_name = "WGPUProcRenderPassEncoderAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPassEncoderRelease] (from webgpu.h) *)
module ProcRenderPassEncoderRelease = struct
  let c_name = "WGPUProcRenderPassEncoderRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPassEncoder.t -> unit) Ctypes.fn = Ctypes.(RenderPassEncoder.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPassEncoder.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPipelineGetBindGroupLayout] (from webgpu.h) *)
module ProcRenderPipelineGetBindGroupLayout = struct
  let c_name = "WGPUProcRenderPipelineGetBindGroupLayout"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPipeline.t -> Unsigned.UInt32.t -> BindGroupLayout.t) Ctypes.fn = Ctypes.(RenderPipeline.t @-> Ctypes.uint32_t @-> Ctypes.returning BindGroupLayout.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPipeline.t -> Unsigned.UInt32.t -> BindGroupLayout.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPipelineSetLabel] (from webgpu.h) *)
module ProcRenderPipelineSetLabel = struct
  let c_name = "WGPUProcRenderPipelineSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPipeline.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(RenderPipeline.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPipeline.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPipelineAddRef] (from webgpu.h) *)
module ProcRenderPipelineAddRef = struct
  let c_name = "WGPUProcRenderPipelineAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPipeline.t -> unit) Ctypes.fn = Ctypes.(RenderPipeline.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPipeline.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcRenderPipelineRelease] (from webgpu.h) *)
module ProcRenderPipelineRelease = struct
  let c_name = "WGPUProcRenderPipelineRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (RenderPipeline.t -> unit) Ctypes.fn = Ctypes.(RenderPipeline.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (RenderPipeline.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSamplerSetLabel] (from webgpu.h) *)
module ProcSamplerSetLabel = struct
  let c_name = "WGPUProcSamplerSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (Sampler.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(Sampler.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Sampler.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSamplerAddRef] (from webgpu.h) *)
module ProcSamplerAddRef = struct
  let c_name = "WGPUProcSamplerAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (Sampler.t -> unit) Ctypes.fn = Ctypes.(Sampler.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Sampler.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSamplerRelease] (from webgpu.h) *)
module ProcSamplerRelease = struct
  let c_name = "WGPUProcSamplerRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (Sampler.t -> unit) Ctypes.fn = Ctypes.(Sampler.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Sampler.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcShaderModuleGetCompilationInfo] (from webgpu.h) *)
module ProcShaderModuleGetCompilationInfo = struct
  let c_name = "WGPUProcShaderModuleGetCompilationInfo"

  (** The C signature, as a ctypes function type. *)
  let fn : (ShaderModule.t -> CompilationInfoCallbackInfo.t -> Future.t) Ctypes.fn = Ctypes.(ShaderModule.t @-> CompilationInfoCallbackInfo.t @-> Ctypes.returning Future.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ShaderModule.t -> CompilationInfoCallbackInfo.t -> Future.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcShaderModuleSetLabel] (from webgpu.h) *)
module ProcShaderModuleSetLabel = struct
  let c_name = "WGPUProcShaderModuleSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (ShaderModule.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(ShaderModule.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ShaderModule.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcShaderModuleAddRef] (from webgpu.h) *)
module ProcShaderModuleAddRef = struct
  let c_name = "WGPUProcShaderModuleAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (ShaderModule.t -> unit) Ctypes.fn = Ctypes.(ShaderModule.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ShaderModule.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcShaderModuleRelease] (from webgpu.h) *)
module ProcShaderModuleRelease = struct
  let c_name = "WGPUProcShaderModuleRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (ShaderModule.t -> unit) Ctypes.fn = Ctypes.(ShaderModule.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (ShaderModule.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSupportedFeaturesFreeMembers] (from webgpu.h) *)
module ProcSupportedFeaturesFreeMembers = struct
  let c_name = "WGPUProcSupportedFeaturesFreeMembers"

  (** The C signature, as a ctypes function type. *)
  let fn : (SupportedFeatures.t -> unit) Ctypes.fn = Ctypes.(SupportedFeatures.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (SupportedFeatures.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSupportedInstanceFeaturesFreeMembers] (from webgpu.h) *)
module ProcSupportedInstanceFeaturesFreeMembers = struct
  let c_name = "WGPUProcSupportedInstanceFeaturesFreeMembers"

  (** The C signature, as a ctypes function type. *)
  let fn : (SupportedInstanceFeatures.t -> unit) Ctypes.fn = Ctypes.(SupportedInstanceFeatures.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (SupportedInstanceFeatures.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSupportedWGSLLanguageFeaturesFreeMembers] (from webgpu.h) *)
module ProcSupportedWGSLLanguageFeaturesFreeMembers = struct
  let c_name = "WGPUProcSupportedWGSLLanguageFeaturesFreeMembers"

  (** The C signature, as a ctypes function type. *)
  let fn : (SupportedWGSLLanguageFeatures.t -> unit) Ctypes.fn = Ctypes.(SupportedWGSLLanguageFeatures.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (SupportedWGSLLanguageFeatures.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfaceConfigure] (from webgpu.h) *)
module ProcSurfaceConfigure = struct
  let c_name = "WGPUProcSurfaceConfigure"

  (** The C signature, as a ctypes function type. *)
  let fn : (Surface.t -> SurfaceConfiguration.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(Surface.t @-> (Ctypes.ptr SurfaceConfiguration.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Surface.t -> SurfaceConfiguration.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfaceGetCapabilities] (from webgpu.h) *)
module ProcSurfaceGetCapabilities = struct
  let c_name = "WGPUProcSurfaceGetCapabilities"

  (** The C signature, as a ctypes function type. *)
  let fn : (Surface.t -> Adapter.t -> SurfaceCapabilities.t Ctypes.ptr -> Status.t) Ctypes.fn = Ctypes.(Surface.t @-> Adapter.t @-> (Ctypes.ptr SurfaceCapabilities.t) @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Surface.t -> Adapter.t -> SurfaceCapabilities.t Ctypes.ptr -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfaceGetCurrentTexture] (from webgpu.h) *)
module ProcSurfaceGetCurrentTexture = struct
  let c_name = "WGPUProcSurfaceGetCurrentTexture"

  (** The C signature, as a ctypes function type. *)
  let fn : (Surface.t -> SurfaceTexture.t Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(Surface.t @-> (Ctypes.ptr SurfaceTexture.t) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Surface.t -> SurfaceTexture.t Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfacePresent] (from webgpu.h) *)
module ProcSurfacePresent = struct
  let c_name = "WGPUProcSurfacePresent"

  (** The C signature, as a ctypes function type. *)
  let fn : (Surface.t -> Status.t) Ctypes.fn = Ctypes.(Surface.t @-> Ctypes.returning Status.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Surface.t -> Status.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfaceSetLabel] (from webgpu.h) *)
module ProcSurfaceSetLabel = struct
  let c_name = "WGPUProcSurfaceSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (Surface.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(Surface.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Surface.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfaceUnconfigure] (from webgpu.h) *)
module ProcSurfaceUnconfigure = struct
  let c_name = "WGPUProcSurfaceUnconfigure"

  (** The C signature, as a ctypes function type. *)
  let fn : (Surface.t -> unit) Ctypes.fn = Ctypes.(Surface.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Surface.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfaceAddRef] (from webgpu.h) *)
module ProcSurfaceAddRef = struct
  let c_name = "WGPUProcSurfaceAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (Surface.t -> unit) Ctypes.fn = Ctypes.(Surface.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Surface.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfaceRelease] (from webgpu.h) *)
module ProcSurfaceRelease = struct
  let c_name = "WGPUProcSurfaceRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (Surface.t -> unit) Ctypes.fn = Ctypes.(Surface.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Surface.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcSurfaceCapabilitiesFreeMembers] (from webgpu.h) *)
module ProcSurfaceCapabilitiesFreeMembers = struct
  let c_name = "WGPUProcSurfaceCapabilitiesFreeMembers"

  (** The C signature, as a ctypes function type. *)
  let fn : (SurfaceCapabilities.t -> unit) Ctypes.fn = Ctypes.(SurfaceCapabilities.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (SurfaceCapabilities.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureCreateView] (from webgpu.h) *)
module ProcTextureCreateView = struct
  let c_name = "WGPUProcTextureCreateView"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> TextureViewDescriptor.t Ctypes.ptr -> TextureView.t) Ctypes.fn = Ctypes.(Texture.t @-> (Ctypes.ptr TextureViewDescriptor.t) @-> Ctypes.returning TextureView.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> TextureViewDescriptor.t Ctypes.ptr -> TextureView.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureDestroy] (from webgpu.h) *)
module ProcTextureDestroy = struct
  let c_name = "WGPUProcTextureDestroy"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> unit) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetDepthOrArrayLayers] (from webgpu.h) *)
module ProcTextureGetDepthOrArrayLayers = struct
  let c_name = "WGPUProcTextureGetDepthOrArrayLayers"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetDimension] (from webgpu.h) *)
module ProcTextureGetDimension = struct
  let c_name = "WGPUProcTextureGetDimension"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> TextureDimension.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning TextureDimension.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> TextureDimension.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetFormat] (from webgpu.h) *)
module ProcTextureGetFormat = struct
  let c_name = "WGPUProcTextureGetFormat"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> TextureFormat.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning TextureFormat.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> TextureFormat.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetHeight] (from webgpu.h) *)
module ProcTextureGetHeight = struct
  let c_name = "WGPUProcTextureGetHeight"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetMipLevelCount] (from webgpu.h) *)
module ProcTextureGetMipLevelCount = struct
  let c_name = "WGPUProcTextureGetMipLevelCount"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetSampleCount] (from webgpu.h) *)
module ProcTextureGetSampleCount = struct
  let c_name = "WGPUProcTextureGetSampleCount"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetTextureBindingViewDimension] (from webgpu.h) *)
module ProcTextureGetTextureBindingViewDimension = struct
  let c_name = "WGPUProcTextureGetTextureBindingViewDimension"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> TextureViewDimension.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning TextureViewDimension.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> TextureViewDimension.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetUsage] (from webgpu.h) *)
module ProcTextureGetUsage = struct
  let c_name = "WGPUProcTextureGetUsage"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> TextureUsage.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning TextureUsage.t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> TextureUsage.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureGetWidth] (from webgpu.h) *)
module ProcTextureGetWidth = struct
  let c_name = "WGPUProcTextureGetWidth"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> Unsigned.UInt32.t) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning Ctypes.uint32_t)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> Unsigned.UInt32.t) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureSetLabel] (from webgpu.h) *)
module ProcTextureSetLabel = struct
  let c_name = "WGPUProcTextureSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(Texture.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureAddRef] (from webgpu.h) *)
module ProcTextureAddRef = struct
  let c_name = "WGPUProcTextureAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> unit) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureRelease] (from webgpu.h) *)
module ProcTextureRelease = struct
  let c_name = "WGPUProcTextureRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (Texture.t -> unit) Ctypes.fn = Ctypes.(Texture.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (Texture.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureViewSetLabel] (from webgpu.h) *)
module ProcTextureViewSetLabel = struct
  let c_name = "WGPUProcTextureViewSetLabel"

  (** The C signature, as a ctypes function type. *)
  let fn : (TextureView.t -> StringView.t -> unit) Ctypes.fn = Ctypes.(TextureView.t @-> StringView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (TextureView.t -> StringView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureViewAddRef] (from webgpu.h) *)
module ProcTextureViewAddRef = struct
  let c_name = "WGPUProcTextureViewAddRef"

  (** The C signature, as a ctypes function type. *)
  let fn : (TextureView.t -> unit) Ctypes.fn = Ctypes.(TextureView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (TextureView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPUProcTextureViewRelease] (from webgpu.h) *)
module ProcTextureViewRelease = struct
  let c_name = "WGPUProcTextureViewRelease"

  (** The C signature, as a ctypes function type. *)
  let fn : (TextureView.t -> unit) Ctypes.fn = Ctypes.(TextureView.t @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (TextureView.t -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** [WGPULogCallback] (from wgpu.h) *)
module LogCallback = struct
  let c_name = "WGPULogCallback"

  (** The C signature, as a ctypes function type. *)
  let fn : (LogLevel.t -> StringView.t -> unit Ctypes.ptr -> unit) Ctypes.fn = Ctypes.(LogLevel.t @-> StringView.t @-> (Ctypes.ptr Ctypes.void) @-> Ctypes.returning Ctypes.void)

  (** A raw C function pointer.  Use {!Wgpu.Callback.permanent} or
      {!Wgpu.Callback.Userdata} to obtain one from an OCaml closure with a
      controlled lifetime. *)
  type t = (LogLevel.t -> StringView.t -> unit Ctypes.ptr -> unit) Ctypes.static_funptr

  let t : t Ctypes.typ = Ctypes.static_funptr fn

  let null : t = Ctypes.coerce (Ctypes.ptr Ctypes.void) t Ctypes.null
end

(** Plain integer typedefs from the headers. *)
module Alias = struct
  (** [typedef uint64_t WGPUSubmissionIndex] *)
  let submission_index = Ctypes.uint64_t

  let () = ()
end
