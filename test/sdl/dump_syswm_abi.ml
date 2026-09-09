(* The same dump as syswm_probe.c, computed by ctypes from the struct
   examples/sdl_syswm.ml declares.  No SDL library is opened: the module
   resolves its entry points lazily, and this program only asks ctypes for
   sizes and offsets. *)

let line name value = Printf.printf "%s = %d\n" name value

let () =
  let open Sdl_syswm in
  line "SDL_SysWMinfo sizeof" (Ctypes.sizeof Sys_wm_info.t);
  line "SDL_SysWMinfo alignof" (Ctypes.alignment Sys_wm_info.t);
  line "SDL_SysWMinfo.version offset" (Ctypes.offsetof Sys_wm_info.version);
  line "SDL_SysWMinfo.version sizeof" (Ctypes.sizeof Version.t);
  line "SDL_SysWMinfo.subsystem offset" (Ctypes.offsetof Sys_wm_info.subsystem);
  line "SDL_SysWMinfo.subsystem sizeof" (Ctypes.sizeof Ctypes.uint32_t);
  let info = Ctypes.offsetof Sys_wm_info.info in
  line "SDL_SysWMinfo.info offset" info;
  line "SDL_SysWMinfo.info sizeof" (Ctypes.sizeof Info.t);
  line "SDL_SysWMinfo.info.x11.display offset" (info + Ctypes.offsetof X11.display);
  line "SDL_SysWMinfo.info.x11.window offset" (info + Ctypes.offsetof X11.window);
  line "SDL_SysWMinfo.info.x11.window sizeof" (Ctypes.sizeof Ctypes.ulong);
  line "SDL_SysWMinfo.info.wl.display offset" (info + Ctypes.offsetof Wayland.display);
  line "SDL_SysWMinfo.info.wl.surface offset" (info + Ctypes.offsetof Wayland.surface);
  line "SDL_SYSWM_WINDOWS" syswm_windows;
  line "SDL_SYSWM_X11" syswm_x11;
  line "SDL_SYSWM_COCOA" syswm_cocoa;
  line "SDL_SYSWM_WAYLAND" syswm_wayland
