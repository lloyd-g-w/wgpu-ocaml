# Vendored third-party material — wgpu-native / webgpu-headers

Everything in this directory is **third-party code that was copied verbatim**.
It is *not* part of the AI-authored original code of this repository, and it
keeps its own upstream licences (see `licenses/`).

## Pinned upstream versions

| Item | Value |
| --- | --- |
| wgpu-native release tag | `v29.0.1.1` |
| wgpu-native commit | `6aed50955d934ac36049ba8d002034841633ae02` |
| `webgpu-headers` submodule commit | `673658bc2bd70ec39fc55ebe6bb0173cf6d0a603` |
| Upstream repository | <https://github.com/gfx-rs/wgpu-native> |
| Header upstream repository | <https://github.com/webgpu-native/webgpu-headers> |

The same values are stored in machine-readable form in [`pin.txt`](pin.txt),
which is the single source of truth used by the generator, the loader version
gate and `scripts/fetch_wgpu_native.ml`.

## Files

| Path | Origin | Licence |
| --- | --- | --- |
| `include/webgpu/webgpu.h` | `webgpu-headers@673658b`, shipped inside the `v29.0.1.1` release archives and as `ffi/webgpu-headers/webgpu.h` in the wgpu-native tree | BSD-3-Clause (`licenses/webgpu-headers-LICENSE`) |
| `include/webgpu/wgpu.h` | `wgpu-native@6aed509`, `ffi/wgpu.h` | MIT OR Apache-2.0 (`licenses/wgpu-native-LICENSE.MIT`, `licenses/wgpu-native-LICENSE.APACHE`) |
| `pin.txt` (`unimplemented` lines) | derived list, see below | MIT OR Apache-2.0 (derived from wgpu-native source) |

Both headers were taken from the official `v29.0.1.1` release archive
(`wgpu-linux-x86_64-release.zip`, `include/webgpu/*.h`) and verified byte for
byte against a fresh clone of `gfx-rs/wgpu-native` at commit `6aed509` with its
`ffi/webgpu-headers` submodule at `673658b` (`diff -q`, identical).

SHA-256 of the vendored headers (also asserted by `test/unit`):

```
a483031c3fed05ea5dd1c74082a71676c46c5b2b820ccca10da515c033efc997  include/webgpu/webgpu.h
7bd23656d394f620a804b1f174444ea17082b6d330a2fca0c0e6b1121ec4b284  include/webgpu/wgpu.h
```

## The `unimplemented` entries in `pin.txt`

wgpu-native declares the full `webgpu.h` surface but a number of entry points
are still `unimplemented!()` stubs that **abort the process** when called (Rust
`panic!` in an `extern "C"` function). The list was extracted mechanically from
`src/unimplemented.rs` of `wgpu-native@6aed509`:

```
grep -E 'pub (unsafe )?extern "C" fn ' src/unimplemented.rs \
  | sed -E 's/.*fn ([A-Za-z0-9_]+).*/\1/' | sort
```

It is stored in `pin.txt` and exposed to OCaml as `Wgpu.Pin.unimplemented` so that
callers can check before calling; it is asserted against the bound function
list by `test/unit`.

## Binary artefacts

No binaries are vendored. `scripts/fetch_wgpu_native.ml` downloads the official
release archive into a cache directory outside the repository and verifies the
SHA-256 checksums pinned in `pin.txt`.
