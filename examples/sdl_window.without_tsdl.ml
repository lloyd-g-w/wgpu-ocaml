(* What examples/sdl_window.exe is when tsdl is not installed.

   dune picks between this file and sdl_window.with_tsdl.ml with the (select)
   in examples/dune, so that `dune build` works whether or not tsdl is there;
   tsdl is deliberately not a dependency of this package. *)

let () =
  prerr_endline
    "examples/sdl_window.exe needs tsdl: run `opam install tsdl` (SDL2 comes \
     with `nix develop`, or from libsdl2-dev), then build again.";
  exit 1
