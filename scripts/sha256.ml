(* SHA-256 (FIPS 180-4), stdlib only.

   Used by the install helper to verify the pinned release archive and by the
   unit tests to verify the vendored headers, so that neither depends on an
   external checksum tool. *)

let k =
  [| 0x428a2f98l; 0x71374491l; 0xb5c0fbcfl; 0xe9b5dba5l; 0x3956c25bl; 0x59f111f1l; 0x923f82a4l;
     0xab1c5ed5l; 0xd807aa98l; 0x12835b01l; 0x243185bel; 0x550c7dc3l; 0x72be5d74l; 0x80deb1fel;
     0x9bdc06a7l; 0xc19bf174l; 0xe49b69c1l; 0xefbe4786l; 0x0fc19dc6l; 0x240ca1ccl; 0x2de92c6fl;
     0x4a7484aal; 0x5cb0a9dcl; 0x76f988dal; 0x983e5152l; 0xa831c66dl; 0xb00327c8l; 0xbf597fc7l;
     0xc6e00bf3l; 0xd5a79147l; 0x06ca6351l; 0x14292967l; 0x27b70a85l; 0x2e1b2138l; 0x4d2c6dfcl;
     0x53380d13l; 0x650a7354l; 0x766a0abbl; 0x81c2c92el; 0x92722c85l; 0xa2bfe8a1l; 0xa81a664bl;
     0xc24b8b70l; 0xc76c51a3l; 0xd192e819l; 0xd6990624l; 0xf40e3585l; 0x106aa070l; 0x19a4c116l;
     0x1e376c08l; 0x2748774cl; 0x34b0bcb5l; 0x391c0cb3l; 0x4ed8aa4al; 0x5b9cca4fl; 0x682e6ff3l;
     0x748f82eel; 0x78a5636fl; 0x84c87814l; 0x8cc70208l; 0x90befffal; 0xa4506cebl; 0xbef9a3f7l;
     0xc67178f2l |]

let ( &: ) = Int32.logand
let ( ^: ) = Int32.logxor
let ( +: ) = Int32.add
let lnot32 = Int32.lognot

let rotr x n = Int32.logor (Int32.shift_right_logical x n) (Int32.shift_left x (32 - n))
let shr x n = Int32.shift_right_logical x n

let digest_string (msg : string) : string =
  let h =
    [| 0x6a09e667l; 0xbb67ae85l; 0x3c6ef372l; 0xa54ff53al; 0x510e527fl; 0x9b05688cl; 0x1f83d9abl;
       0x5be0cd19l |]
  in
  let len = String.length msg in
  let bitlen = Int64.of_int (len * 8) in
  let padded_len = ((len + 9 + 63) / 64) * 64 in
  let b = Bytes.make padded_len '\000' in
  Bytes.blit_string msg 0 b 0 len;
  Bytes.set b len '\x80';
  Bytes.set_int64_be b (padded_len - 8) bitlen;
  let w = Array.make 64 0l in
  for block = 0 to (padded_len / 64) - 1 do
    for t = 0 to 15 do
      w.(t) <- Bytes.get_int32_be b ((block * 64) + (t * 4))
    done;
    for t = 16 to 63 do
      let s0 = rotr w.(t - 15) 7 ^: rotr w.(t - 15) 18 ^: shr w.(t - 15) 3 in
      let s1 = rotr w.(t - 2) 17 ^: rotr w.(t - 2) 19 ^: shr w.(t - 2) 10 in
      w.(t) <- w.(t - 16) +: s0 +: w.(t - 7) +: s1
    done;
    let a = ref h.(0) and bb = ref h.(1) and c = ref h.(2) and d = ref h.(3) in
    let e = ref h.(4) and f = ref h.(5) and g = ref h.(6) and hh = ref h.(7) in
    for t = 0 to 63 do
      let s1 = rotr !e 6 ^: rotr !e 11 ^: rotr !e 25 in
      let ch = (!e &: !f) ^: (lnot32 !e &: !g) in
      let t1 = !hh +: s1 +: ch +: k.(t) +: w.(t) in
      let s0 = rotr !a 2 ^: rotr !a 13 ^: rotr !a 22 in
      let maj = (!a &: !bb) ^: (!a &: !c) ^: (!bb &: !c) in
      let t2 = s0 +: maj in
      hh := !g;
      g := !f;
      f := !e;
      e := !d +: t1;
      d := !c;
      c := !bb;
      bb := !a;
      a := t1 +: t2
    done;
    h.(0) <- h.(0) +: !a;
    h.(1) <- h.(1) +: !bb;
    h.(2) <- h.(2) +: !c;
    h.(3) <- h.(3) +: !d;
    h.(4) <- h.(4) +: !e;
    h.(5) <- h.(5) +: !f;
    h.(6) <- h.(6) +: !g;
    h.(7) <- h.(7) +: !hh
  done;
  String.concat "" (Array.to_list (Array.map (fun x -> Printf.sprintf "%08lx" x) h))

let digest_file path =
  let ic = open_in_bin path in
  let n = in_channel_length ic in
  let s = really_input_string ic n in
  close_in ic;
  digest_string s
