(*
 * Copyright (c) 2013-2017 Thomas Gazagnaire <thomas@gazagnaire.org>
 * and Romain Calascibetta <romain.calascibetta@gmail.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)

module type S =
sig
  include Minimal.S

  val read_inflated : t -> Hash.t -> ([ `Commit | `Tag | `Blob | `Tree ] * string) option Lwt.t
  val write_inflated : t -> kind:[ `Commit | `Tree | `Blob | `Tag ] -> Cstruct.t -> Hash.t Lwt.t
end

module Make
    (H : S.HASH with type Digest.buffer = Cstruct.t
                 and type hex = string)
    (P : Path.S)
    (L : S.LOCK with type key = P.t
                 and type +'a io = 'a Lwt.t)
    (* XXX(dinosaure): we constraint +'a io to use Lwt but the goal is
       to cut the Lwt dependence with the memory back-end. *)
    (I : S.INFLATE)
    (D : S.DEFLATE)
    (B : Value.BUFFER with type raw = string
                       and type fixe = Cstruct.t)
  : S with module Hash = H
       and module Path = P
       and module Lock = L
       and module Inflate = I
       and module Deflate = D
