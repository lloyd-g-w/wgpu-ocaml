(* Generator entry point.

   Usage: gen.exe <what> <pin.txt> <webgpu.h> <wgpu.h>
   where <what> is one of: types | fn | abi | abi-probe | summary

   The output goes to stdout so that dune can capture and diff it against the
   committed copies (see lib/dune and test/abi/dune). *)

let read_pin_lines path =
  let ic = open_in path in
  let lines = ref [] in
  (try
     while true do
       lines := input_line ic :: !lines
     done
   with End_of_file -> ());
  close_in ic;
  List.rev_map String.trim !lines

let read_pin path =
  let ic = open_in path in
  let entries = ref [] in
  (try
     while true do
       let line = String.trim (input_line ic) in
       if line <> "" && line.[0] <> '#' then
         match String.index_opt line ' ' with
         | None -> ()
         | Some i ->
             let k = String.sub line 0 i in
             let v = String.trim (String.sub line (i + 1) (String.length line - i - 1)) in
             entries := (k, v) :: !entries
     done
   with End_of_file -> ());
  close_in ic;
  List.rev !entries

let () =
  match Array.to_list Sys.argv with
  | _ :: what :: pin_path :: headers when headers <> [] ->
      let pin = read_pin pin_path in
      let h = C_header.parse headers in
      let out =
        match what with
        | "pin" -> Emit.emit_pin ~pin ~pin_lines:(read_pin_lines pin_path)
        | "types" -> Emit.emit_types ~pin ~h
        | "fn" -> Emit.emit_fn ~pin ~h
        | "abi" -> Emit.emit_abi ~pin ~h
        | "abi-probe" -> Emit.emit_abi_probe ~h
        | "summary" ->
            Printf.sprintf
              "handles: %d\nenums: %d\nflags: %d\nstructs: %d\ncallbacks: %d\nfunctions: %d\naliases: %d\nconstants: %d\ninits: %d\n"
              (List.length h.handles) (List.length h.enums) (List.length h.flags)
              (List.length h.structs) (List.length h.callbacks) (List.length h.functions)
              (List.length h.aliases) (List.length h.constants) (List.length h.inits)
        | other -> failwith (Printf.sprintf "unknown output %S" other)
      in
      print_string out
  | _ ->
      prerr_endline "usage: gen.exe types|fn|abi|abi-probe|summary <pin.txt> <header.h>...";
      exit 2
