(* The naming conventions of the generated raw layer, and the behaviour of the
   enum / bit-set helpers.  These are the parts users type by hand. *)

open Wgpu.Types

let () =
  (* Enum constants keep their numeric value and can be named back. *)
  Check.equal_int "LoadOp_Clear" ~expected:2 ~got:LoadOp.clear;
  Check.equal_string "LoadOp.to_string" ~expected:"WGPULoadOp_Clear"
    ~got:(LoadOp.to_string LoadOp.clear);
  Check.equal_string "unknown enum value" ~expected:"WGPULoadOp(0x0000dead)"
    ~got:(LoadOp.to_string 0xdead);
  Check.equal_string "enum c_name" ~expected:"WGPULoadOp" ~got:LoadOp.c_name;
  Check.is_true "enum values list" (List.mem_assoc "WGPULoadOp_Clear" LoadOp.values);

  (* Acronyms and digits in enum constant names. *)
  Check.equal_string "RGBA8Unorm" ~expected:"WGPUTextureFormat_RGBA8Unorm"
    ~got:(TextureFormat.to_string TextureFormat.rgba8_unorm);
  Check.equal_string "ASTC4x4Unorm" ~expected:"WGPUTextureFormat_ASTC4x4Unorm"
    ~got:(TextureFormat.to_string TextureFormat.astc4x4_unorm);
  Check.equal_string "2D texture dimension" ~expected:"WGPUTextureDimension_2D"
    ~got:(TextureDimension.to_string TextureDimension.v2_d);

  (* Bit sets. *)
  let usage = BufferUsage.(combine [ map_read; copy_dst ]) in
  Check.equal_int "combine" ~expected:(BufferUsage.map_read lor BufferUsage.copy_dst) ~got:usage;
  Check.is_true "mem" (BufferUsage.mem ~bit:BufferUsage.copy_dst usage);
  Check.is_true "not mem" (not (BufferUsage.mem ~bit:BufferUsage.storage usage));
  Check.equal_string "flags to_string" ~expected:"WGPUBufferUsage_MapRead|WGPUBufferUsage_CopyDst"
    ~got:(BufferUsage.to_string usage);
  Check.equal_string "empty flags" ~expected:"WGPUBufferUsage_None"
    ~got:(BufferUsage.to_string BufferUsage.none);

  (* Sentinels come from the headers, not from guesses. *)
  Check.equal_string "WGPU_STRLEN" ~expected:(Unsigned.Size_t.to_string Unsigned.Size_t.max_int)
    ~got:(Unsigned.Size_t.to_string Constants.strlen);
  Check.equal_string "WGPU_LIMIT_U32_UNDEFINED" ~expected:"4294967295"
    ~got:(Unsigned.UInt32.to_string Constants.limit_u32_undefined);
  Check.is_true "WGPU_DEPTH_CLEAR_VALUE_UNDEFINED is NaN"
    (Float.is_nan Constants.depth_clear_value_undefined);

  (* Struct defaults follow the header's INIT macro, not all-zero. *)
  let limits = Limits.init () in
  Check.equal_string "Limits.init maxTextureDimension1D" ~expected:"4294967295"
    ~got:(Unsigned.UInt32.to_string (Ctypes.getf limits Limits.maxTextureDimension1D));
  let wgsl = ShaderSourceWGSL.init () in
  Check.equal_int "ShaderSourceWGSL.init sets sType" ~expected:SType.shader_source_wgsl
    ~got:(Ctypes.getf (Ctypes.getf wgsl ShaderSourceWGSL.chain) ChainedStruct.sType);
  let sv = StringView.init () in
  Check.is_true "StringView.init is the null view"
    (Ctypes.is_null (Ctypes.getf sv StringView.data));

  (* Handles are typed pointers with a null value. *)
  Check.is_true "null handle" (Buffer.is_null Buffer.null);
  Check.equal_string "handle c_name" ~expected:"WGPUBuffer" ~got:Buffer.c_name;

  (* Struct field names keep their C spelling. *)
  Check.is_true "field names"
    (List.mem "mappedAtCreation" BufferDescriptor.field_names);
  Check.finish "naming"
