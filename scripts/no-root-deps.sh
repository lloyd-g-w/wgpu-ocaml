#!/usr/bin/env bash
# Build-time dependencies for machines where you cannot install packages.
#
# ctypes-foreign needs libffi's headers and pkg-config.  On a normal machine:
#
#     sudo apt-get install libffi-dev pkg-config   # Debian/Ubuntu
#     brew install libffi pkg-config               # macOS
#
# Without root, this script downloads the Debian/Ubuntu packages into a
# throw-away prefix under /tmp and prints the environment to use.  It is a
# development convenience only; nothing in the repository depends on it.
#
#     source scripts/no-root-deps.sh
#     opam install --assume-depexts ctypes-foreign

set -euo pipefail

prefix="${WGPU_OCAML_SYSROOT:-/tmp/wgpu-ocaml-sysroot}"
mkdir -p "$prefix/debs" "$prefix/prefix/include" "$prefix/prefix/lib/pkgconfig"

if [ ! -f "$prefix/prefix/include/ffi.h" ]; then
  (cd "$prefix/debs" && for p in libffi-dev pkgconf pkgconf-bin libpkgconf3 pkg-config; do
    apt-get download "$p"
  done)
  for d in "$prefix"/debs/*.deb; do dpkg-deb -x "$d" "$prefix/root"; done
  cp "$prefix"/root/usr/include/*/ffi*.h "$prefix/prefix/include/"
  ln -sf /usr/lib/x86_64-linux-gnu/libffi.so.8 "$prefix/prefix/lib/libffi.so"
  cat > "$prefix/prefix/lib/pkgconfig/libffi.pc" <<EOF
prefix=$prefix/prefix
includedir=\${prefix}/include
libdir=\${prefix}/lib

Name: libffi
Description: Library supporting Foreign Function Interfaces
Version: 3.4.6
Libs: -L\${libdir} -lffi
Cflags: -I\${includedir}
EOF
fi

export PATH="$prefix/root/usr/bin:$PATH"
export LD_LIBRARY_PATH="$prefix/root/usr/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH:-}"
export PKG_CONFIG_PATH="$prefix/prefix/lib/pkgconfig"

echo "libffi + pkg-config available from $prefix"
echo "PKG_CONFIG_PATH=$PKG_CONFIG_PATH"
