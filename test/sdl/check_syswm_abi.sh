#!/bin/sh
# Diff what SDL2's headers say about SDL_SysWMinfo against what
# examples/sdl_syswm.ml declares to ctypes.
#
#   check_syswm_abi.sh PROBE.c DUMP.exe CC [CFLAGS...]
#
# Skips cleanly (exit 0) when pkg-config cannot find sdl2: the SDL headers are
# not a dependency of this project, and examples/sdl_window.exe is optional for
# the same reason.
set -eu

probe=$1
dump=$2
shift 2
cc=$*

if ! command -v pkg-config >/dev/null 2>&1; then
  echo "test/sdl: no pkg-config, skipping the SDL_SysWMinfo ABI check"
  exit 0
fi
if ! pkg-config --exists sdl2; then
  echo "test/sdl: pkg-config cannot find sdl2, skipping the SDL_SysWMinfo ABI check"
  exit 0
fi

# The X11 union member is only readable with Xlib's types in scope.
x11_flags=
if pkg-config --exists x11; then
  x11_flags="-DWGPU_OCAML_PROBE_X11=1 $(pkg-config --cflags x11)"
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# shellcheck disable=SC2086  # the compiler and the pkg-config flags are lists
$cc -std=c11 $(pkg-config --cflags sdl2) $x11_flags -o "$work/probe" "$probe"
"$work/probe" > "$work/from_c.txt"
"$dump" > "$work/from_ocaml.txt"

# The probe reports a union member only when the SDL build's headers allow it
# to be read at all, so compare on the keys it did report.
awk -F' = ' 'NR == FNR { key[$1]; next } ($1 in key)' \
  "$work/from_c.txt" "$work/from_ocaml.txt" > "$work/from_ocaml_common.txt"

if ! diff -u "$work/from_c.txt" "$work/from_ocaml_common.txt"; then
  echo "test/sdl: examples/sdl_syswm.ml disagrees with SDL2's headers" >&2
  exit 1
fi

echo "test/sdl: SDL_SysWMinfo matches SDL $(pkg-config --modversion sdl2) headers in $(wc -l < "$work/from_c.txt" | tr -d ' ') places"
