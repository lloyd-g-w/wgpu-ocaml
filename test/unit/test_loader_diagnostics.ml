(* Loading must fail with an actionable message, and an explicit
   WGPU_NATIVE_LIB must never silently fall back to another copy. *)

let contains haystack needle =
  let n = String.length haystack and m = String.length needle in
  let rec go i = i + m <= n && (String.sub haystack i m = needle || go (i + 1)) in
  go 0

let () =
  let bogus = Filename.concat (Filename.get_temp_dir_name ()) "no-such-libwgpu_native.so" in
  Unix.putenv "WGPU_NATIVE_LIB" bogus;
  let e =
    Check.raises "loading a missing library raises" (fun () ->
        ignore (Wgpu.Loader.runtime_version ()))
  in
  (match e with
  | Wgpu.Loader.Not_found_ msg ->
      Check.is_true "diagnostic names the path tried" (contains msg bogus);
      Check.is_true "diagnostic names the env var" (contains msg "$WGPU_NATIVE_LIB");
      Check.is_true "diagnostic suggests the fetch script"
        (contains msg "fetch_wgpu_native");
      Check.is_true "diagnostic names the pinned release" (contains msg Wgpu.Pin.tag)
  | e -> Check.is_true ("unexpected exception: " ^ Printexc.to_string e) false);
  Check.is_true "no library was loaded" (Wgpu.Loader.loaded_path () = None);
  Check.finish "loader diagnostics"
