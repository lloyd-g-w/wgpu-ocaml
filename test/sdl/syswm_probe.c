/* What the C compiler thinks SDL_SysWMinfo looks like, read out of SDL2's own
   headers.  examples/sdl_syswm.ml declares the same struct to ctypes without
   ever seeing those headers; check_syswm_abi.sh diffs the two dumps.

   The union members are guarded in SDL_syswm.h by the SDL_VIDEO_DRIVER_*
   macros of the SDL build, and some SDL2 distributions (sdl2-compat, for one)
   ship an SDL_config.h that defines none of them, so the members would be
   invisible here.  Defining them ourselves cannot change the layout: SDL pads
   the union with `Uint8 dummy[64]` precisely so that its size does not depend
   on which drivers are compiled in, and no member is larger than that.  The
   Wayland member only needs incomplete pointer types; the X11 member needs
   Xlib, so it is only requested when check_syswm_abi.sh found the X11 headers
   (-DWGPU_OCAML_PROBE_X11). */

#include <SDL2/SDL.h>

#ifndef SDL_VIDEO_DRIVER_WAYLAND
#define SDL_VIDEO_DRIVER_WAYLAND 1
#endif

#ifdef WGPU_OCAML_PROBE_X11
#ifndef SDL_VIDEO_DRIVER_X11
#define SDL_VIDEO_DRIVER_X11 1
#endif
#endif

#include <SDL2/SDL_syswm.h>

#include <stddef.h>
#include <stdio.h>

int main(void) {
  printf("SDL_SysWMinfo sizeof = %zu\n", sizeof(SDL_SysWMinfo));
  printf("SDL_SysWMinfo alignof = %zu\n", (size_t)_Alignof(SDL_SysWMinfo));
  printf("SDL_SysWMinfo.version offset = %zu\n",
         offsetof(SDL_SysWMinfo, version));
  printf("SDL_SysWMinfo.version sizeof = %zu\n", sizeof(SDL_version));
  printf("SDL_SysWMinfo.subsystem offset = %zu\n",
         offsetof(SDL_SysWMinfo, subsystem));
  printf("SDL_SysWMinfo.subsystem sizeof = %zu\n", sizeof(SDL_SYSWM_TYPE));
  printf("SDL_SysWMinfo.info offset = %zu\n", offsetof(SDL_SysWMinfo, info));
  printf("SDL_SysWMinfo.info sizeof = %zu\n",
         sizeof(((SDL_SysWMinfo *)0)->info));
#if defined(SDL_VIDEO_DRIVER_X11) && !defined(SDL2COMPAT_DISABLE_X11)
  printf("SDL_SysWMinfo.info.x11.display offset = %zu\n",
         offsetof(SDL_SysWMinfo, info.x11.display));
  printf("SDL_SysWMinfo.info.x11.window offset = %zu\n",
         offsetof(SDL_SysWMinfo, info.x11.window));
  printf("SDL_SysWMinfo.info.x11.window sizeof = %zu\n",
         sizeof(((SDL_SysWMinfo *)0)->info.x11.window));
#endif
#if defined(SDL_VIDEO_DRIVER_WAYLAND)
  printf("SDL_SysWMinfo.info.wl.display offset = %zu\n",
         offsetof(SDL_SysWMinfo, info.wl.display));
  printf("SDL_SysWMinfo.info.wl.surface offset = %zu\n",
         offsetof(SDL_SysWMinfo, info.wl.surface));
#endif
  printf("SDL_SYSWM_WINDOWS = %d\n", (int)SDL_SYSWM_WINDOWS);
  printf("SDL_SYSWM_X11 = %d\n", (int)SDL_SYSWM_X11);
  printf("SDL_SYSWM_COCOA = %d\n", (int)SDL_SYSWM_COCOA);
  printf("SDL_SYSWM_WAYLAND = %d\n", (int)SDL_SYSWM_WAYLAND);
  return 0;
}
