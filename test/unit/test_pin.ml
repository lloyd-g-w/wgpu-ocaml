(* The pinned release metadata and its derived encodings. *)

let () =
  Check.equal_string "version" ~expected:"29.0.1.1" ~got:Wgpu.Pin.version;
  Check.equal_string "tag" ~expected:"v29.0.1.1" ~got:Wgpu.Pin.tag;
  Check.equal_int "commit length" ~expected:40 ~got:(String.length Wgpu.Pin.commit);
  Check.equal_int "webgpu-headers commit length" ~expected:40
    ~got:(String.length Wgpu.Pin.webgpu_headers_commit);
  (* wgpuGetVersion packs one byte per component. *)
  Check.equal_string "version_u32"
    ~expected:"0x1d000101"
    ~got:(Printf.sprintf "0x%08lx" Wgpu.Pin.version_u32);
  Check.equal_string "string_of_version_u32" ~expected:"29.0.1.1"
    ~got:(Wgpu.Pin.string_of_version_u32 Wgpu.Pin.version_u32);
  Check.is_true "archives are pinned" (List.length Wgpu.Pin.archives >= 4);
  List.iter
    (fun (platform, asset, sha, lib) ->
      Check.equal_int (platform ^ " sha256 length") ~expected:64 ~got:(String.length sha);
      Check.is_true (platform ^ " asset name") (String.length asset > 0);
      Check.is_true (platform ^ " library path") (String.length lib > 0))
    Wgpu.Pin.archives;
  (* Every entry point wgpu-native declares but does not implement must still be
     bound, so that callers can see (and avoid) it. *)
  let bound = List.sort compare Wgpu.Fn.names in
  List.iter
    (fun n ->
      Check.is_true ("unimplemented entry point is bound: " ^ n)
        (List.exists (fun m -> m = n) bound))
    Wgpu.Pin.unimplemented;
  Check.is_true "unimplemented list is non-empty" (Wgpu.Pin.unimplemented <> []);
  Check.finish "pin"
