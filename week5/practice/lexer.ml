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
  let rec lex_impl state chars v = 
    match state with
    | S0 -> (* state 0 *)
        begin 
          match chars with
          | h :: t -> 
              begin
                match h with
                | '-' -> (* transition to state 1 *)
                    begin 
                      match lex_impl S1 t 0 with
                      | Int v -> Int (-1 * v)
                    end
                | '0' .. '9' -> (* transition to state 2 *)
                    lex_impl S2 t (v * 10 + (char_to_int h))
                | _ -> failwith "Not a valid integer"
              end
          | [] -> failwith "Not a valid integer"
        end
    | S1 -> (* state 1 *)
        begin
          match chars with 
          | h :: t -> 
              begin 
                match h with
                | '0' .. '9' -> (* transition to state 2 *)
                    lex_impl S2 t (v * 10 + (char_to_int h))
                | _ -> failwith "Not a valid integer"
              end
          | [] -> failwith "Not a valid integer"
        end
    | S2 -> (* state 2 = final state for Int *)
        begin
          match chars with 
          | h :: t -> 
              begin 
                match h with
                | '0' .. '9' -> (* transition to state 2 *)
                    lex_impl S2 t (v * 10 + (char_to_int h))
                | _ -> failwith "Not a valid integer"
              end
          | [] -> Int v
        end
  in
  (* start from state 0 *)
  lex_impl S0 chars 0

let pp fmt v = 
  match v with
  | Int i -> F.fprintf fmt "Int %d" i
