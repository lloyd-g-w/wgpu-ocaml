(* An independent, deliberately naive scan of the vendored headers.

   The generator has its own (strict) C parser; this scanner exists to catch the
   case where that parser silently skips a declaration.  It is written
   differently on purpose: plain substring scanning, no shared code. *)

let header_dir = "../../vendor/wgpu-native/include/webgpu"

let read path =
  let ic = open_in_bin path in
  let n = in_channel_length ic in
  let s = really_input_string ic n in
  close_in ic;
  s

let strip_comments src =
  let b = Buffer.create (String.length src) in
  let n = String.length src in
  let i = ref 0 in
  while !i < n do
    if !i + 1 < n && src.[!i] = '/' && src.[!i + 1] = '*' then begin
      i := !i + 2;
      while !i + 1 < n && not (src.[!i] = '*' && src.[!i + 1] = '/') do incr i done;
      i := !i + 2
    end
    else if !i + 1 < n && src.[!i] = '/' && src.[!i + 1] = '/' then
      while !i < n && src.[!i] <> '\n' do incr i done
    else begin
      Buffer.add_char b src.[!i];
      incr i
    end
  done;
  Buffer.contents b

let sources () =
  List.map
    (fun f -> strip_comments (read (Filename.concat header_dir f)))
    [ "webgpu.h"; "wgpu.h" ]

let is_ident_char c =
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c = '_'

(* Every identifier matching [prefix] that is directly followed by [next]. *)
let idents_followed_by ~prefix ~next src =
  let out = ref [] in
  let n = String.length src in
  let plen = String.length prefix in
  let i = ref 0 in
  while !i + plen <= n do
    let boundary = !i = 0 || not (is_ident_char src.[!i - 1]) in
    if boundary && String.sub src !i plen = prefix then begin
      let j = ref (!i + plen) in
      while !j < n && is_ident_char src.[!j] do incr j done;
      let name = String.sub src !i (!j - !i) in
      (* skip whitespace before the expected character *)
      let k = ref !j in
      while !k < n && (src.[!k] = ' ' || src.[!k] = '\n' || src.[!k] = '\t' || src.[!k] = '\r') do
        incr k
      done;
      if !k < n && src.[!k] = next then out := name :: !out;
      i := !j
    end
    else incr i
  done;
  List.rev !out

(* For every "<keyword> <ident>" occurrence, the identifier and the first
   non-blank character after it, e.g. ("WGPUAdapterInfo", '{'). *)
let names_after_with_next ~keyword src =
  let out = ref [] in
  let n = String.length src in
  let klen = String.length keyword in
  let i = ref 0 in
  while !i + klen <= n do
    if String.sub src !i klen = keyword && (!i = 0 || not (is_ident_char src.[!i - 1])) then begin
      let j = ref (!i + klen) in
      while !j < n && (src.[!j] = ' ' || src.[!j] = '\n' || src.[!j] = '\t') do incr j done;
      let s = !j in
      while !j < n && is_ident_char src.[!j] do incr j done;
      if !j > s then begin
        let k = ref !j in
        while !k < n && (src.[!k] = ' ' || src.[!k] = '\n' || src.[!k] = '\t' || src.[!k] = '\r') do
          incr k
        done;
        out := (String.sub src s (!j - s), if !k < n then src.[!k] else ' ') :: !out
      end;
      i := !j
    end
    else incr i
  done;
  List.rev !out

let names_after ~keyword src = List.map fst (names_after_with_next ~keyword src)

let all f = List.concat_map f (sources ())

(** Entry points: [wgpuFoo(] in a declaration (never in a typedef, where the
    name is [WGPUProcFoo]). *)
let functions () = all (fun src -> idents_followed_by ~prefix:"wgpu" ~next:'(' src)

(** [typedef struct WGPUFoo {] -- a struct with a body. *)
let structs () =
  all (fun src ->
      names_after_with_next ~keyword:"typedef struct" src
      |> List.filter_map (fun (name, next) -> if next = '{' then Some name else None))

(** [typedef struct WGPUFooImpl*] -- an opaque handle. *)
let handles () =
  all (fun src ->
      names_after_with_next ~keyword:"typedef struct" src
      |> List.filter_map (fun (name, next) ->
             let n = String.length name in
             if next = '*' && n > 4 && String.sub name (n - 4) 4 = "Impl" then
               Some (String.sub name 0 (n - 4))
             else None))

let enums () = all (fun src -> names_after ~keyword:"typedef enum" src)

let init_macros () =
  all (fun src ->
      names_after ~keyword:"#define" src
      |> List.filter (fun n ->
             String.length n > 10
             && String.sub n 0 5 = "WGPU_"
             && String.sub n (String.length n - 5) 5 = "_INIT"))
