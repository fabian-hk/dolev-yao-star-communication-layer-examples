module DY.Example.SingleAuthMessage.Protocol.Total

open Comparse
open DY.Core
open DY.Lib

(*
  C -> S: {sender; receiver; {secret}; sign(sk_sender, nonce, {sender; receiver; {secret}})
*)

[@@with_bytes bytes]
type single_message = {
  secret:bytes;
}

%splice [ps_single_message] (gen_parser (`single_message))
%splice [ps_single_message_is_well_formed] (gen_is_well_formed_lemma (`single_message))

instance parseable_serializeable_bytes_message: parseable_serializeable bytes single_message
  = mk_parseable_serializeable ps_single_message


(*** Protocol ***)

val compute_message: bytes -> bytes
let compute_message secret =
  let msg = {secret;} in
  serialize single_message msg

val decode_message: bytes -> option single_message
let decode_message msg_bytes =
  let? msg = parse single_message msg_bytes in
  Some msg