(* Assembles the GitHub Pages site for wgpu-ocaml.

   The site is three Markdown pages plus the odoc API reference:

     index.html   <- README.md
     guide.html   <- docs/GUIDE.md
     design.html  <- DESIGN.md
     api/         <- the output of `dune build @doc`

   Everything except odoc itself is done here, in OCaml with the stdlib only:
   the Markdown subset used by those three files is rendered directly, so the
   documentation job needs no pandoc, no GPU, no Rust toolchain and no
   libwgpu_native — only OCaml, dune and odoc.

   Usage:
     dune build @doc
     dune exec doc/site/build_site.exe -- --out _site

   Options:
     --root DIR   repository root (default: the current directory)
     --out DIR    output directory, erased first (default: _site)
     --api DIR    odoc HTML to copy to <out>/api
                  (default: _build/default/_doc/_html)
     --no-api     skip the API reference (the nav link is then not checked)

   Every internal link produced by the Markdown pages is checked against the
   files and heading anchors that were actually generated; a dangling one is a
   build failure. *)

let repo_url = "https://github.com/lloyd-g-w/wgpu-ocaml"
let blob_url = repo_url ^ "/blob/main/"
let site_url = "https://lloyd-g-w.github.io/wgpu-ocaml/"

(* ------------------------------------------------------------------ *)
(* Small string helpers                                                *)
(* ------------------------------------------------------------------ *)

let is_blank s = String.for_all (fun c -> c = ' ' || c = '\t' || c = '\r') s
let starts_with p s = String.length s >= String.length p && String.sub s 0 (String.length p) = p

let indent_of s =
  let n = String.length s in
  let rec go i = if i < n && s.[i] = ' ' then go (i + 1) else i in
  go 0

let drop_indent k s =
  let n = String.length s in
  let rec go i = if i < n && i < k && s.[i] = ' ' then go (i + 1) else i in
  let i = go 0 in
  String.sub s i (n - i)

let add_escaped b s =
  String.iter
    (function
      | '&' -> Buffer.add_string b "&amp;"
      | '<' -> Buffer.add_string b "&lt;"
      | '>' -> Buffer.add_string b "&gt;"
      | '"' -> Buffer.add_string b "&quot;"
      | c -> Buffer.add_char b c)
    s

let escaped s =
  let b = Buffer.create (String.length s + 8) in
  add_escaped b s;
  Buffer.contents b

(* Plain text of an inline span, used for heading anchors and the table of
   contents: markup characters are dropped, link texts are kept. *)
let plain_text s =
  let b = Buffer.create (String.length s) in
  let n = String.length s in
  let rec go i =
    if i < n then
      match s.[i] with
      | '`' | '*' -> go (i + 1)
      | '[' -> go (i + 1)
      | ']' ->
          (* skip the "(...)" target of a link *)
          if i + 1 < n && s.[i + 1] = '(' then begin
            let rec skip j = if j < n && s.[j] <> ')' then skip (j + 1) else j + 1 in
            go (skip (i + 2))
          end
          else go (i + 1)
      | c ->
          Buffer.add_char b c;
          go (i + 1)
  in
  go 0;
  String.trim (Buffer.contents b)

(* GitHub-style heading anchors, so that a "#section" link written for the
   Markdown source keeps working on the site. *)
let slug text =
  let b = Buffer.create 32 in
  String.iter
    (fun c ->
      if (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') then Buffer.add_char b c
      else if c >= 'A' && c <= 'Z' then Buffer.add_char b (Char.lowercase_ascii c)
      else if c = ' ' || c = '-' then Buffer.add_char b '-'
      else if c = '_' then Buffer.add_char b '_')
    (plain_text text);
  Buffer.contents b

(* ------------------------------------------------------------------ *)
(* Pages and link rewriting                                            *)
(* ------------------------------------------------------------------ *)

type page = { src : string; out : string; title : string; nav : string }

let pages =
  [ { src = "README.md"; out = "index.html"; title = "wgpu-ocaml"; nav = "Home" };
    { src = "docs/GUIDE.md"; out = "guide.html"; title = "wgpu-ocaml — guide"; nav = "Guide" };
    { src = "DESIGN.md"; out = "design.html"; title = "wgpu-ocaml — design"; nav = "Design" } ]

type state = {
  page : page;
  mutable headings : (int * string * string) list; (* level, id, text; reversed *)
  mutable ids : string list;
  mutable hrefs : string list; (* reversed *)
}

let unique_id st base =
  let base = if base = "" then "section" else base in
  let rec go n =
    let candidate = if n = 0 then base else Printf.sprintf "%s-%d" base n in
    if List.mem candidate st.ids then go (n + 1) else candidate
  in
  let id = go 0 in
  st.ids <- id :: st.ids;
  id

(* Repository-relative links become site links for the pages that are part of
   the site, and GitHub links for everything else. *)
let rewrite_href href =
  let split_fragment h =
    match String.index_opt h '#' with
    | Some i -> (String.sub h 0 i, String.sub h i (String.length h - i))
    | None -> (h, "")
  in
  if
    starts_with "http://" href || starts_with "https://" href || starts_with "mailto:" href
    || starts_with "#" href
  then href
  else begin
    let path, fragment = split_fragment href in
    let rec strip p =
      if starts_with "./" p then strip (String.sub p 2 (String.length p - 2))
      else if starts_with "../" p then strip (String.sub p 3 (String.length p - 3))
      else p
    in
    let path = strip path in
    match path with
    | "" -> fragment
    | "README.md" -> "index.html" ^ fragment
    | "GUIDE.md" | "docs/GUIDE.md" -> "guide.html" ^ fragment
    | "DESIGN.md" -> "design.html" ^ fragment
    | p -> blob_url ^ p ^ fragment
  end

let record_href st href = st.hrefs <- href :: st.hrefs

(* ------------------------------------------------------------------ *)
(* Inline Markdown                                                     *)
(* ------------------------------------------------------------------ *)

let find_from s i c =
  let n = String.length s in
  let rec go j = if j >= n then None else if s.[j] = c then Some j else go (j + 1) in
  go i

let find_sub s i sub =
  let n = String.length s and m = String.length sub in
  let rec go j = if j + m > n then None else if String.sub s j m = sub then Some j else go (j + 1) in
  go i

let rec inline st b s =
  let n = String.length s in
  let rec go i =
    if i >= n then ()
    else
      match s.[i] with
      | '\\' when i + 1 < n ->
          add_escaped b (String.make 1 s.[i + 1]);
          go (i + 2)
      | '`' ->
          let rec run j = if j < n && s.[j] = '`' then run (j + 1) else j in
          let start = run i in
          let len = start - i in
          let ticks = String.make len '`' in
          (match find_sub s start ticks with
          | Some close ->
              let code = String.sub s start (close - start) in
              let code =
                if String.length code >= 2 && code.[0] = ' ' && code.[String.length code - 1] = ' '
                then String.sub code 1 (String.length code - 2)
                else code
              in
              Buffer.add_string b "<code>";
              add_escaped b code;
              Buffer.add_string b "</code>";
              go (close + len)
          | None ->
              add_escaped b ticks;
              go start)
      | '!' when i + 1 < n && s.[i + 1] = '[' -> (
          match link_at s (i + 1) with
          | Some (text, href, next) ->
              Buffer.add_string b
                (Printf.sprintf "<img src=\"%s\" alt=\"%s\">" (escaped href)
                   (escaped (plain_text text)));
              go next
          | None ->
              Buffer.add_char b '!';
              go (i + 1))
      | '[' -> (
          match link_at s i with
          | Some (text, href, next) ->
              let target = rewrite_href href in
              record_href st target;
              Buffer.add_string b (Printf.sprintf "<a href=\"%s\">" (escaped target));
              inline st b text;
              Buffer.add_string b "</a>";
              go next
          | None ->
              Buffer.add_char b '[';
              go (i + 1))
      | '*' when i + 1 < n && s.[i + 1] = '*' -> (
          match find_sub s (i + 2) "**" with
          | Some close when close > i + 2 ->
              Buffer.add_string b "<strong>";
              inline st b (String.sub s (i + 2) (close - i - 2));
              Buffer.add_string b "</strong>";
              go (close + 2)
          | _ ->
              Buffer.add_string b "**";
              go (i + 2))
      | '*' -> (
          match find_from s (i + 1) '*' with
          | Some close when close > i + 1 ->
              Buffer.add_string b "<em>";
              inline st b (String.sub s (i + 1) (close - i - 1));
              Buffer.add_string b "</em>";
              go (close + 1)
          | _ ->
              Buffer.add_char b '*';
              go (i + 1))
      | '<' when starts_with "<http" (String.sub s i (min 5 (n - i))) -> (
          match find_from s i '>' with
          | Some close ->
              let url = String.sub s (i + 1) (close - i - 1) in
              record_href st url;
              Buffer.add_string b
                (Printf.sprintf "<a href=\"%s\">%s</a>" (escaped url) (escaped url));
              go (close + 1)
          | None ->
              Buffer.add_string b "&lt;";
              go (i + 1))
      | c ->
          add_escaped b (String.make 1 c);
          go (i + 1)
  in
  go 0

(* [link_at s i] parses "[text](href)" starting at the '[' in position [i]. *)
and link_at s i =
  let n = String.length s in
  let rec close_bracket j depth =
    if j >= n then None
    else
      match s.[j] with
      | '[' -> close_bracket (j + 1) (depth + 1)
      | ']' -> if depth = 0 then Some j else close_bracket (j + 1) (depth - 1)
      | _ -> close_bracket (j + 1) depth
  in
  match close_bracket (i + 1) 0 with
  | Some rb when rb + 1 < n && s.[rb + 1] = '(' -> (
      match find_from s (rb + 2) ')' with
      | Some rp ->
          let text = String.sub s (i + 1) (rb - i - 1) in
          let href = String.trim (String.sub s (rb + 2) (rp - rb - 2)) in
          Some (text, href, rp + 1)
      | None -> None)
  | _ -> None

let inline_string st s =
  let b = Buffer.create (String.length s + 16) in
  inline st b s;
  Buffer.contents b

(* ------------------------------------------------------------------ *)
(* Block Markdown                                                      *)
(* ------------------------------------------------------------------ *)

let is_fence l = starts_with "```" (String.trim l)
let is_heading l = starts_with "#" l && String.contains l ' '
let is_hr l = String.trim l = "---" || String.trim l = "***"
let is_quote l = starts_with ">" (String.trim l)

(* [list_marker l] recognises "- ", "* " and "1. " and returns
   (indent, marker width, ordered?). *)
let list_marker l =
  let d = indent_of l in
  let n = String.length l in
  if d + 1 < n && (l.[d] = '-' || l.[d] = '*') && l.[d + 1] = ' ' then Some (d, 2, false)
  else begin
    let rec digits j = if j < n && l.[j] >= '0' && l.[j] <= '9' then digits (j + 1) else j in
    let e = digits d in
    if e > d && e + 1 < n && l.[e] = '.' && l.[e + 1] = ' ' then Some (d, e - d + 2, true) else None
  end

(* Table cells are split on '|' outside inline code spans. *)
let split_row l =
  let cells = ref [] and cur = Buffer.create 32 and code = ref false in
  String.iter
    (fun c ->
      if c = '`' then begin
        code := not !code;
        Buffer.add_char cur c
      end
      else if c = '|' && not !code then begin
        cells := Buffer.contents cur :: !cells;
        Buffer.clear cur
      end
      else Buffer.add_char cur c)
    l;
  cells := Buffer.contents cur :: !cells;
  (* [cells] is accumulated in reverse; [rev_map] puts it back in order.  A row
     that starts and ends with '|' yields an empty cell at each edge. *)
  let cells = List.rev_map String.trim !cells in
  let drop_edge = function "" :: rest -> rest | c -> c in
  List.rev (drop_edge (List.rev (drop_edge cells)))

let is_delimiter_row l =
  let t = String.trim l in
  t <> ""
  && String.exists (fun c -> c = '-') t
  && String.for_all (fun c -> c = '-' || c = ':' || c = '|' || c = ' ') t

let alignment cell =
  let c = String.trim cell in
  let left = starts_with ":" c and right = String.length c > 0 && c.[String.length c - 1] = ':' in
  match (left, right) with
  | true, true -> Some "center"
  | false, true -> Some "right"
  | true, false -> Some "left"
  | false, false -> None

let starts_block a i =
  let l = a.(i) in
  is_fence l || is_heading l || is_hr l || is_quote l
  || list_marker l <> None
  || (String.contains l '|' && i + 1 < Array.length a && is_delimiter_row a.(i + 1))

(* Renders a list of lines to HTML.  [unwrap] strips the enclosing <p> when the
   whole block is a single paragraph, which is what makes list items tight. *)
let rec render_blocks ?(unwrap = false) st lines =
  let a = Array.of_list lines in
  let n = Array.length a in
  let b = Buffer.create 4096 in
  let i = ref 0 in
  let blocks = ref 0 in
  let only_paragraph = ref None in
  while !i < n do
    let line = a.(!i) in
    if is_blank line then incr i
    else if is_fence line then begin
      incr blocks;
      let info = String.trim (String.sub (String.trim line) 3 (String.length (String.trim line) - 3)) in
      let body = Buffer.create 256 in
      incr i;
      while !i < n && not (is_fence a.(!i)) do
        add_escaped body a.(!i);
        Buffer.add_char body '\n';
        incr i
      done;
      if !i < n then incr i;
      Buffer.add_string b
        (if info = "" then "<pre><code>"
         else Printf.sprintf "<pre><code class=\"language-%s\">" (escaped info));
      Buffer.add_string b (Buffer.contents body);
      Buffer.add_string b "</code></pre>\n"
    end
    else if is_heading line then begin
      incr blocks;
      let level = ref 0 in
      while !level < String.length line && line.[!level] = '#' do incr level done;
      let text = String.trim (String.sub line !level (String.length line - !level)) in
      let id = unique_id st (slug text) in
      st.headings <- (!level, id, plain_text text) :: st.headings;
      Buffer.add_string b
        (Printf.sprintf "<h%d id=\"%s\">%s</h%d>\n" !level id (inline_string st text) !level);
      incr i
    end
    else if is_hr line then begin
      incr blocks;
      Buffer.add_string b "<hr>\n";
      incr i
    end
    else if is_quote line then begin
      incr blocks;
      let inner = ref [] in
      while !i < n && is_quote a.(!i) do
        let t = String.trim a.(!i) in
        let t = String.sub t 1 (String.length t - 1) in
        inner := (if starts_with " " t then String.sub t 1 (String.length t - 1) else t) :: !inner;
        incr i
      done;
      Buffer.add_string b "<blockquote>\n";
      Buffer.add_string b (render_blocks st (List.rev !inner));
      Buffer.add_string b "</blockquote>\n"
    end
    else if String.contains line '|' && !i + 1 < n && is_delimiter_row a.(!i + 1) then begin
      incr blocks;
      let header = split_row line in
      let aligns = List.map alignment (split_row a.(!i + 1)) in
      let align k = try List.nth aligns k with _ -> None in
      let cell tag k c =
        match align k with
        | None -> Printf.sprintf "<%s>%s</%s>" tag (inline_string st c) tag
        | Some a -> Printf.sprintf "<%s style=\"text-align:%s\">%s</%s>" tag a (inline_string st c) tag
      in
      Buffer.add_string b "<table>\n<thead><tr>";
      List.iteri (fun k c -> Buffer.add_string b (cell "th" k c)) header;
      Buffer.add_string b "</tr></thead>\n<tbody>\n";
      i := !i + 2;
      while !i < n && (not (is_blank a.(!i))) && String.contains a.(!i) '|' do
        Buffer.add_string b "<tr>";
        List.iteri (fun k c -> Buffer.add_string b (cell "td" k c)) (split_row a.(!i));
        Buffer.add_string b "</tr>\n";
        incr i
      done;
      Buffer.add_string b "</tbody>\n</table>\n"
    end
    else
      match list_marker line with
      | Some (d, _, ordered) ->
          incr blocks;
          Buffer.add_string b (if ordered then "<ol>\n" else "<ul>\n");
          let continue_list = ref true in
          while !continue_list do
            match if !i < n then list_marker a.(!i) else None with
            | Some (d', w, _) when d' = d ->
                let item = ref [ drop_indent (d + w) (String.sub a.(!i) (d + w) (String.length a.(!i) - d - w)) ] in
                incr i;
                let stop = ref false in
                while (not !stop) && !i < n do
                  if is_blank a.(!i) then begin
                    (* a blank line continues the item only if what follows is
                       still indented under it *)
                    let j = ref (!i + 1) in
                    while !j < n && is_blank a.(!j) do incr j done;
                    if !j < n && indent_of a.(!j) > d then begin
                      item := "" :: !item;
                      i := !i + 1
                    end
                    else stop := true
                  end
                  else if indent_of a.(!i) > d then begin
                    item := drop_indent (d + w) a.(!i) :: !item;
                    incr i
                  end
                  else stop := true
                done;
                Buffer.add_string b "<li>";
                Buffer.add_string b (render_blocks ~unwrap:true st (List.rev !item));
                Buffer.add_string b "</li>\n"
            | _ -> continue_list := false
          done;
          Buffer.add_string b (if ordered then "</ol>\n" else "</ul>\n")
      | None ->
          incr blocks;
          let para = ref [ line ] in
          incr i;
          while (not (!i >= n)) && (not (is_blank a.(!i))) && not (starts_block a !i) do
            para := a.(!i) :: !para;
            incr i
          done;
          (* [para] is accumulated in reverse; [rev_map] puts it back in order. *)
          let text = String.concat "\n" (List.rev_map String.trim !para) in
          let html = inline_string st text in
          only_paragraph := Some html;
          Buffer.add_string b (Printf.sprintf "<p>%s</p>\n" html)
  done;
  match (unwrap, !blocks, !only_paragraph) with
  | true, 1, Some html -> html
  | _ -> Buffer.contents b

(* ------------------------------------------------------------------ *)
(* Page assembly                                                       *)
(* ------------------------------------------------------------------ *)

let nav ~api current =
  let b = Buffer.create 512 in
  Buffer.add_string b "<nav class=\"site\">\n  <span class=\"brand\">wgpu-ocaml</span>\n";
  List.iter
    (fun p ->
      let cls = if p.out = current then " class=\"here\"" else "" in
      Buffer.add_string b (Printf.sprintf "  <a href=\"%s\"%s>%s</a>\n" p.out cls p.nav))
    pages;
  if api then Buffer.add_string b "  <a href=\"api/wgpu/index.html\">API reference</a>\n";
  Buffer.add_string b (Printf.sprintf "  <a href=\"%s\">GitHub</a>\n</nav>\n" repo_url);
  Buffer.contents b

let footer =
  Printf.sprintf
    "<footer>\n  <p>wgpu-ocaml — OCaml bindings to WebGPU through wgpu-native. Everything in this\n  \
     site was written by AI; see <a href=\"index.html#authorship\">Authorship</a>.</p>\n  \
     <p>Built by <code>doc/site/build_site.ml</code> and <a \
     href=\"https://ocaml.github.io/odoc/\">odoc</a>, deployed by GitHub Actions.</p>\n</footer>\n"

let toc_html st =
  let hs = List.rev st.headings in
  let entries = List.filter (fun (l, _, _) -> l = 2 || l = 3) hs in
  if List.length entries < 3 then ""
  else begin
    let b = Buffer.create 1024 in
    Buffer.add_string b "<nav id=\"toc\">\n<p class=\"toc-title\">Contents</p>\n<ul>\n";
    (* A nested list belongs inside the <li> it refines, so the enclosing item
       is left open until its sub-list is closed. *)
    let depth = ref 2 and first = ref true in
    List.iter
      (fun (l, id, text) ->
        if l > !depth then Buffer.add_string b "\n<ul>\n"
        else if l < !depth then Buffer.add_string b "</li>\n</ul>\n</li>\n"
        else if not !first then Buffer.add_string b "</li>\n";
        first := false;
        depth := l;
        Buffer.add_string b (Printf.sprintf "<li><a href=\"#%s\">%s</a>" id (escaped text)))
      entries;
    if not !first then Buffer.add_string b "</li>\n";
    if !depth > 2 then Buffer.add_string b "</ul>\n</li>\n";
    Buffer.add_string b "</ul>\n</nav>\n";
    Buffer.contents b
  end

let read_lines path =
  let ic = open_in_bin path in
  Fun.protect
    ~finally:(fun () -> close_in ic)
    (fun () ->
      let rec go acc = match input_line ic with l -> go (l :: acc) | exception End_of_file -> List.rev acc in
      go [])

let write_file path contents =
  let oc = open_out_bin path in
  Fun.protect ~finally:(fun () -> close_out oc) (fun () -> output_string oc contents)

let render_page ~root ~api page =
  let st = { page; headings = []; ids = []; hrefs = [] } in
  let body = render_blocks st (read_lines (Filename.concat root page.src)) in
  (* The table of contents goes just under the page title. *)
  let body =
    match find_sub body 0 "</h1>" with
    | Some k ->
        let head = String.sub body 0 (k + 5) and rest = String.sub body (k + 5) (String.length body - k - 5) in
        head ^ "\n" ^ toc_html st ^ rest
    | None -> toc_html st ^ body
  in
  let html =
    Printf.sprintf
      "<!DOCTYPE html>\n\
       <html lang=\"en\">\n\
       <head>\n\
       <meta charset=\"utf-8\">\n\
       <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n\
       <title>%s</title>\n\
       <meta name=\"description\" content=\"OCaml bindings to WebGPU through wgpu-native: \
       generated from the vendored upstream headers, bound with ctypes-foreign.\">\n\
       <link rel=\"canonical\" href=\"%s%s\">\n\
       <link rel=\"stylesheet\" href=\"style.css\">\n\
       </head>\n\
       <body>\n\
       %s<main>\n\
       %s</main>\n\
       %s</body>\n\
       </html>\n"
      (escaped page.title) site_url
      (if page.out = "index.html" then "" else page.out)
      (nav ~api page.out) body footer
  in
  (st, html)

(* ------------------------------------------------------------------ *)
(* Filesystem                                                          *)
(* ------------------------------------------------------------------ *)

(* ---------------------------------------------------------------------- *)
(* Output directory safety                                                 *)
(*                                                                          *)
(* This program used to [rm -rf] whatever --out named.  It now only ever    *)
(* clears a directory it created itself, identified by a marker file, and   *)
(* it never follows a symlink while deleting.                              *)
(* ---------------------------------------------------------------------- *)

(** Written into every directory this program owns; its presence is what
    authorises clearing that directory on the next run. *)
let marker_name = ".wgpu-ocaml-site"

let marker_contents =
  "This directory is generated by doc/site/build_site.ml and is deleted and
   rebuilt on every run.  Remove this marker to protect it: build_site refuses
   to clear a non-empty directory that does not contain it.
"

let die fmt =
  Printf.ksprintf
    (fun s ->
      prerr_endline ("build_site: " ^ s);
      exit 1)
    fmt

(* Absolute, symlink-free path.  For a path that does not exist yet, the
   closest existing ancestor is resolved and the rest appended, so that
   containment checks cannot be defeated by a symlinked parent. *)
let rec resolved path =
  let path = if Filename.is_relative path then Filename.concat (Sys.getcwd ()) path else path in
  match Unix.realpath path with
  | p -> p
  | exception Unix.Unix_error _ ->
      let parent = Filename.dirname path in
      if parent = path then path else Filename.concat (resolved parent) (Filename.basename path)

(* [a] is [b] or a directory containing [b]. *)
let is_ancestor a b =
  a = b || (String.length b > String.length a && String.starts_with ~prefix:(a ^ "/") b)

let is_symlink path =
  match Unix.lstat path with
  | { Unix.st_kind = Unix.S_LNK; _ } -> true
  | _ -> false
  | exception Unix.Unix_error _ -> false

let is_real_dir path =
  match Unix.lstat path with
  | { Unix.st_kind = Unix.S_DIR; _ } -> true
  | _ -> false
  | exception Unix.Unix_error _ -> false

(* Deletes the *contents* of a directory without ever descending through a
   symlink: symlinks are unlinked, only real directories are recursed into. *)
let rec clear_dir path =
  Array.iter
    (fun e ->
      let p = Filename.concat path e in
      if is_real_dir p then begin
        clear_dir p;
        Unix.rmdir p
      end
      else Unix.unlink p)
    (Sys.readdir path)

let dir_is_empty path = Array.length (Sys.readdir path) = 0

(** Make [out] an empty directory this program owns, refusing anything that
    would destroy data it did not create.  [protected] lists the paths the run
    reads from; [out] may not contain any of them. *)
let prepare_out ~out ~protected =
  let out_abs = resolved out in
  List.iter
    (fun p ->
      let p_abs = resolved p in
      if is_ancestor out_abs p_abs then
        die
          "refusing to use %s as --out: it contains the input %s.\n           Pick an output directory outside the sources (the default is _site)."
          out_abs p_abs)
    protected;
  if Sys.file_exists out || is_symlink out then begin
    if is_symlink out then
      die
        "refusing to use %s as --out: it is a symbolic link.\n         Clearing it would delete through the link; pass a real directory."
        out;
    if not (is_real_dir out) then die "refusing to use %s as --out: it is not a directory." out;
    if not (dir_is_empty out) then
      if Sys.file_exists (Filename.concat out marker_name) then clear_dir out
      else
        die
          "refusing to erase %s: it is not empty and has no %s marker, so it was not created by \
           build_site.\n           Delete it yourself, or point --out at a new directory."
          out_abs marker_name
  end
  else Unix.mkdir out 0o755;
  (* Claim the directory before writing anything else, so an interrupted run
     can still be cleaned up automatically next time. *)
  let oc = open_out_bin (Filename.concat out marker_name) in
  output_string oc marker_contents;
  close_out oc

let rec mkdir_p path =
  if not (Sys.file_exists path) then begin
    mkdir_p (Filename.dirname path);
    try Sys.mkdir path 0o755 with Sys_error _ -> ()
  end

let copy_file src dst =
  let ic = open_in_bin src and oc = open_out_bin dst in
  Fun.protect
    ~finally:(fun () ->
      close_in ic;
      close_out oc)
    (fun () ->
      let len = 65536 in
      let buf = Bytes.create len in
      let rec go () =
        let n = input ic buf 0 len in
        if n > 0 then begin
          output oc buf 0 n;
          go ()
        end
      in
      go ())

let rec copy_dir src dst =
  mkdir_p dst;
  Array.iter
    (fun e ->
      let s = Filename.concat src e and d = Filename.concat dst e in
      if Sys.is_directory s then copy_dir s d else copy_file s d)
    (Sys.readdir src)

let rec count_files dir =
  Array.fold_left
    (fun acc e ->
      let p = Filename.concat dir e in
      if Sys.is_directory p then acc + count_files p else acc + 1)
    0 (Sys.readdir dir)

(* ------------------------------------------------------------------ *)
(* Link checking                                                       *)
(* ------------------------------------------------------------------ *)

let check_links ~root ~out states =
  let ids = List.map (fun st -> (st.page.out, st.ids)) states in
  let errors = ref [] and internal = ref 0 and external_ = ref 0 and repo = ref 0 in
  List.iter
    (fun st ->
      List.iter
        (fun href ->
          (* A link into the repository was rewritten from a relative path, so
             the file it names has to be there. *)
          if starts_with blob_url href then begin
            incr repo;
            let p = String.sub href (String.length blob_url) (String.length href - String.length blob_url) in
            let p = match String.index_opt p '#' with Some i -> String.sub p 0 i | None -> p in
            if not (Sys.file_exists (Filename.concat root p)) then
              errors := Printf.sprintf "%s: link to missing repository file %S" st.page.out p :: !errors
          end
          else if
            starts_with "http://" href || starts_with "https://" href || starts_with "mailto:" href
          then incr external_
          else begin
            incr internal;
            let path, fragment =
              match String.index_opt href '#' with
              | Some i -> (String.sub href 0 i, String.sub href (i + 1) (String.length href - i - 1))
              | None -> (href, "")
            in
            let target = if path = "" then st.page.out else path in
            if not (Sys.file_exists (Filename.concat out target)) then
              errors := Printf.sprintf "%s: link to missing file %S" st.page.out href :: !errors
            else if fragment <> "" then
              match List.assoc_opt target ids with
              | Some page_ids when not (List.mem fragment page_ids) ->
                  errors := Printf.sprintf "%s: link to unknown anchor %S" st.page.out href :: !errors
              | _ -> ()
          end)
        (List.rev st.hrefs))
    states;
  (List.rev !errors, !internal, !repo, !external_)

(* ------------------------------------------------------------------ *)
(* Main                                                                *)
(* ------------------------------------------------------------------ *)

let () =
  let root = ref "." and out = ref "_site" and api = ref "_build/default/_doc/_html" and with_api = ref true in
  let rec parse = function
    | [] -> ()
    | "--root" :: d :: r -> root := d; parse r
    | "--out" :: d :: r -> out := d; parse r
    | "--api" :: d :: r -> api := d; parse r
    | "--no-api" :: r -> with_api := false; parse r
    | "--help" :: _ ->
        print_string
          "usage: build_site.exe [--root DIR] [--out DIR] [--api DIR] [--no-api]\n";
        exit 0
    | a :: _ ->
        prerr_endline ("build_site: unexpected argument " ^ a);
        exit 2
  in
  parse (List.tl (Array.to_list Sys.argv));
  let root = !root and out = !out in
  List.iter
    (fun p ->
      if not (Sys.file_exists (Filename.concat root p.src)) then begin
        Printf.eprintf "build_site: %s not found (wrong --root %S?)\n" p.src root;
        exit 1
      end)
    pages;
  if !with_api && not (Sys.file_exists (Filename.concat !api "wgpu/index.html")) then begin
    Printf.eprintf
      "build_site: %s does not contain wgpu/index.html.\nRun `dune build @doc` first, or pass \
       --no-api.\n"
      !api;
    exit 1
  end;
  prepare_out ~out
    ~protected:
      ((root :: List.map (fun p -> Filename.concat root p.src) pages)
      @ [ Filename.concat root "doc/site/style.css" ]
      @ if !with_api then [ !api ] else []);
  let states =
    List.map
      (fun page ->
        let st, html = render_page ~root ~api:!with_api page in
        write_file (Filename.concat out page.out) html;
        st)
      pages
  in
  copy_file (Filename.concat root "doc/site/style.css") (Filename.concat out "style.css");
  (* GitHub Pages must not run Jekyll over odoc's output. *)
  write_file (Filename.concat out ".nojekyll") "";
  if !with_api then copy_dir !api (Filename.concat out "api");
  let errors, internal, repo, external_ = check_links ~root ~out states in
  List.iter (fun e -> prerr_endline ("build_site: " ^ e)) errors;
  if errors <> [] then begin
    Printf.eprintf "build_site: %d broken internal link(s)\n" (List.length errors);
    exit 1
  end;
  Printf.printf
    "site in %s: %d pages, %d files, %d site links + %d repository links checked, %d external \
     links\n"
    out (List.length pages) (count_files out) internal repo external_
