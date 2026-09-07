(* The vendored headers must be exactly the ones the pin claims: the generated
   bindings are only valid for those bytes. *)

let () =
  List.iter
    (fun (name, expected) ->
      let path = Filename.concat Header_scan.header_dir name in
      Check.equal_string ("sha256 of " ^ name) ~expected
        ~got:(Wgpu_scripts.Sha256.digest_file path))
    Wgpu.Pin.header_sha256;
  (* Self-check of the SHA-256 implementation against the published vectors. *)
  Check.equal_string "sha256 of empty string"
    ~expected:"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    ~got:(Wgpu_scripts.Sha256.digest_string "");
  Check.equal_string "sha256 of abc"
    ~expected:"ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
    ~got:(Wgpu_scripts.Sha256.digest_string "abc");
  Check.equal_string "sha256 of a million a's"
    ~expected:"cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0"
    ~got:(Wgpu_scripts.Sha256.digest_string (String.make 1_000_000 'a'));
  Check.finish "vendor headers"
