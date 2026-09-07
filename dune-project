(lang dune 3.20)

(name wgpu)

(generate_opam_files true)

(source
 (github lloyd-g-w/wgpu-ocaml))

; No (license ...) on purpose: the owner has not chosen one for the original
; code yet, so wgpu.opam deliberately carries no licence field.  See the
; Licensing sections of README.md and DESIGN.md.  The vendored third-party
; headers keep their own licences under vendor/wgpu-native/licenses/.

(package
 (name wgpu)
 (synopsis "OCaml bindings to WebGPU through wgpu-native")
 (maintainers "caduc-ai <ai@caduc.co>")
 (authors "AI agents (human owner: lloyd-g-w)")
 (description
  "Bindings to the WebGPU C API (webgpu.h) and the wgpu-native extensions\n(wgpu.h), generated from the vendored upstream headers and bound with\nctypes-foreign.  libwgpu_native is loaded dynamically at run time; no C stubs\nare compiled and no headers are needed at build time.\n\nThis package is entirely AI-authored; see the README for details.")
 (depends
  (ocaml
   (>= 5.5.1))
  (dune
   (>= 3.20))
  (ctypes
   (>= 0.23.0))
  (ctypes-foreign
   (>= 0.23.0))
  (integers
   (>= 0.7.0)))
 (tags
  (webgpu wgpu graphics gpu bindings)))
