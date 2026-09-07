(* Turning OCaml closures into C function pointers, safely.

   ctypes frees the libffi closure behind a [Foreign.funptr] when the OCaml
   value that owns it becomes unreachable.  A raw [static_funptr] stored in a C
   struct does *not* keep that value alive, so a naive
   [coerce (Foreign.funptr fn) (static_funptr fn) f] is a use-after-free waiting
   to happen.

   This module therefore offers exactly three mechanisms:

   - {!permanent}: a closure that is retained for the lifetime of the process.
     Used for trampolines a program installs once, such as the uncaptured-error
     handler or the ones in [wgpu.utils].
   - {!Userdata}: a table mapping the [userdata1] pointer that WebGPU passes
     back to the OCaml value it stands for, so that a *single* permanent
     trampoline can serve an unbounded number of per-call closures.
   - {!protect}: the exception barrier every trampoline body must run inside.

   {2 Threading}

   [webgpu.h] states that the uncaptured-error callback "may be called at any
   time ... from any thread", and [wgpuSetLogCallback] installs a *process
   global* Rust [log] sink that any thread inside wgpu / wgpu-hal / naga can
   reach.  These bindings therefore support callbacks arriving on threads the
   OCaml runtime has never seen:

   - every entry point is bound with [~release_runtime_lock:true]
     ({!Wgpu_loader.foreign}), so a wgpu call never keeps the OCaml domain lock
     while native code runs — without that, a foreign thread trying to call
     back into OCaml would deadlock against the thread sitting in the call;
   - every closure is created with [~runtime_lock:true ~thread_registration:true],
     so ctypes registers the calling thread with the OCaml runtime
     ([caml_c_thread_register], which attaches it to domain 0) and acquires the
     domain lock for the duration of the callback.

   Consequences, all of which the tests exercise:

   - OCaml code inside a callback may allocate and may trigger a GC;
   - only one thread runs OCaml at a time, but a callback on a foreign thread
     and OCaml code on the main thread are *interleaved*, so the state this
     module owns is protected by {!with_lock};
   - a callback must not call back into wgpu-native (upstream documents that as
     unsafe for the uncaptured-error callback), and must not raise: see
     {!protect};
   - the library still assumes a single OCaml domain drives wgpu.

   {2 Exceptions}

   An OCaml exception escaping a libffi closure would unwind through Rust
   frames that hold locks, which is undefined behaviour.  {!protect} catches
   everything, records it (see {!take_failures}) and returns normally; the
   caller collects the recorded failures with {!take_failures}, so nothing is
   silently swallowed. *)

(* One mutex for every piece of mutable state this library shares with
   callbacks.  A single lock cannot deadlock against itself, and OCaml's
   [Mutex.lock] releases the domain lock while it waits, so a foreign callback
   blocking here never stops the main thread from making progress. *)
let lock = Mutex.create ()

let with_lock : type a. (unit -> a) -> a =
 fun f ->
  Mutex.lock lock;
  Fun.protect ~finally:(fun () -> Mutex.unlock lock) f

(* ------------------------------------------------------------------ *)
(* Failures recorded inside callbacks                                  *)
(* ------------------------------------------------------------------ *)

type failure = { where : string; exn : exn; backtrace : string }

(* Newest first, bounded: a misbehaving callback must not grow the heap without
   limit, but the failures must survive until the OCaml side collects them. *)
let max_failures = 64
let failures : failure list ref = ref []
let dropped_failures = ref 0

let string_of_failure f =
  let bt = String.trim f.backtrace in
  Printf.sprintf "%s: %s%s" f.where (Printexc.to_string f.exn)
    (if bt = "" then "" else "\n" ^ bt)

(** Record a failure that happened inside a callback.  Never raises. *)
let record_failure where exn backtrace =
  try
    with_lock (fun () ->
        if List.length !failures >= max_failures then incr dropped_failures
        else failures := { where; exn; backtrace } :: !failures)
  with _ -> ()

(** Collect and clear the failures recorded so far, oldest first. *)
let take_failures () =
  with_lock (fun () ->
      let l = List.rev !failures in
      let extra = !dropped_failures in
      failures := [];
      dropped_failures := 0;
      if extra = 0 then l
      else
        l
        @ [ { where = "wgpu callback";
              exn = Failure (Printf.sprintf "%d further callback failure(s) were dropped" extra);
              backtrace = "" } ])

(** Number of failures waiting to be collected. *)
let pending_failures () = with_lock (fun () -> List.length !failures)

(** [protect ~where f] runs [f] as the body of a C callback: it never raises,
    and an exception is recorded for {!take_failures} instead of unwinding into
    the Rust frames that called us. *)
let protect ~where f =
  try f () with
  | e ->
      let bt = Printexc.get_backtrace () in
      record_failure where e bt

(* ------------------------------------------------------------------ *)
(* Permanent closures                                                  *)
(* ------------------------------------------------------------------ *)

let retained : Obj.t list ref = ref []

(** [permanent fn f] returns a C function pointer for [f] that stays valid
    forever.  [f] and the libffi closure are rooted in a global list.

    The closure acquires the OCaml domain lock and registers the calling thread
    if wgpu-native invokes it from a thread the runtime has not seen; see the
    threading notes above.  The body of [f] must not raise: wrap it in
    {!protect}. *)
let permanent : type a b. (a -> b) Ctypes.fn -> (a -> b) -> (a -> b) Ctypes.static_funptr =
 fun fn f ->
  let funptr_typ = Foreign.funptr ~runtime_lock:true ~thread_registration:true fn in
  let p = Ctypes.coerce funptr_typ (Ctypes.static_funptr fn) f in
  with_lock (fun () -> retained := Obj.repr f :: Obj.repr p :: !retained);
  p

(** Number of closures retained by {!permanent}; used by the lifetime tests. *)
let retained_count () = with_lock (fun () -> List.length !retained)

(* ------------------------------------------------------------------ *)
(* Userdata tokens                                                     *)
(* ------------------------------------------------------------------ *)

(** A registry of OCaml values addressable by the [void *userdata] that WebGPU
    hands back to callbacks. *)
module Userdata = struct
  type 'a t = { id : int; value : 'a }

  let table : (int, Obj.t) Hashtbl.t = Hashtbl.create 16
  let next_id = ref 1
  let abandoned = ref 0

  (** Register [v] and return an opaque token.  The token must be released with
      {!release} once the callback is known to have fired, or given up with
      {!abandon} when it may still fire. *)
  let register (v : 'a) : 'a t =
    with_lock (fun () ->
        let id = !next_id in
        incr next_id;
        Hashtbl.replace table id (Obj.repr v);
        { id; value = v })

  (** The [void *] to pass as [userdata1]. *)
  let pointer (t : 'a t) : unit Ctypes.ptr = Ctypes.ptr_of_raw_address (Nativeint.of_int t.id)

  (** Recover a registered value inside a callback.  Raises [Not_found] if the
      token has already been released, which would otherwise be a silent
      use-after-free; {!protect} turns that into a recorded failure. *)
  let lookup (p : unit Ctypes.ptr) : 'a =
    let id = Nativeint.to_int (Ctypes.raw_address_of_ptr p) in
    match with_lock (fun () -> Hashtbl.find_opt table id) with
    | Some o -> Obj.obj o
    | None -> raise Not_found

  (** Free a token.  Only correct once the callback has demonstrably fired (or
      can no longer fire): wgpu-native still holds the raw [userdata] pointer. *)
  let release (t : 'a t) = with_lock (fun () -> Hashtbl.remove table t.id)

  (** Give up on a token whose callback may still fire.  The entry is kept
      forever — leaking a few words is the only safe outcome when native code
      retains a pointer we cannot revoke — and counted so that tests and users
      can see it happened. *)
  let abandon (t : 'a t) =
    with_lock (fun () -> if Hashtbl.mem table t.id then incr abandoned)

  (** Number of live tokens; used by the lifetime tests. *)
  let live_count () = with_lock (fun () -> Hashtbl.length table)

  (** Number of tokens given up with {!abandon}; should stay 0. *)
  let abandoned_count () = with_lock (fun () -> !abandoned)
end
