module F = Format

type t = Int of int

type state = 
  | S0
  | S1
  | S2

let char_to_int c = (int_of_char c) - 48 

(* lex : char list -> t *)
let lex chars = 
  (* lex_impl : state -> char list -> int -> t *)
  (* write your code *)


let pp fmt v = 
  match v with
  | Int i -> F.fprintf fmt "Int %d" i
