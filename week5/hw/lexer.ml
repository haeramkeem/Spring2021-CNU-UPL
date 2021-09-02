module F = Format

type t = 
  | Int of int
  | Var of string

type state = 
  | S0
  | S1
  | S2
  | S3

let char_to_int c = (int_of_char c) - 48 
let char_to_str c = Char.escaped c

(* lex : char list -> t *)
let lex chars = 
  (* 
   * Lexer for integer value and variblaes using finite automata
   *
   * Args :
   *      chars(char list) : input list containing characters
   *
   * Return :
   *        t : output integer value or varialbe name
   *)

  (* lex_impl : state -> char list -> int -> t *)
  let rec lex_impl chars_ state_ acc =
    match state_ with
      | S0 -> (*start state*)
        begin
          match chars_ with
            | [] -> failwith "Not a valid integer or a valid variable"
            | h :: t ->
              begin
                match h with
                  | '-' -> (*goto S1*) lex_impl t S1 (Int 0)
                  | '0' .. '9' -> (*goto S2*) lex_impl t S2 (Int (char_to_int h))
                  | 'a' .. 'z' -> (*goto S3*) lex_impl t S3 (Var (char_to_str h))
                  | _ -> failwith "Not a valid integer or a valid variable"
              end
        end
      | S1 -> (*if negative detected*)
        begin
          match chars_ with
            | [] -> failwith "Not a valid integer or a valid variable"
            | h :: t ->
              begin
                match h with
                  | '0' -> 
                    begin
                      if t = [] then (*goto S2 with result 0*) lex_impl [] S2 (Int 0)
                      else (*goto S1*) lex_impl t S1 acc
                    end
                  | '1' .. '9' -> (*goto S2*) lex_impl t S2 (Int (-(char_to_int h)))
                  | _ -> failwith "Not a valid integer or a valid variable"
              end
        end
      | S2 -> (*if integer*)
        begin
          match acc with
            | Int acc_ ->
              begin
                match chars_ with
                  | [] -> acc
                  | h :: t ->
                    begin
                      match h with
                      | '0' .. '9' ->
                        begin
                          if acc_ < 0 then (*negative integer*) lex_impl t S2 (Int (acc_ * 10 - (char_to_int h)))
                          else (*positive integer*) lex_impl t S2 (Int (acc_ * 10 + (char_to_int h)))
                        end
                      | _ -> failwith "Not a valid integer or a valid variable"
                    end
              end
            | Var _ -> failwith "Not a valid integer or a valid variable"
        end
      | S3 -> (*if name of variable*)
        begin
          match acc with
            | Var acc_ ->
              begin
                match chars_ with
                  | [] -> acc
                  | h :: t ->
                    begin
                      match h with
                        | '0' .. '9' | 'a' .. 'z' | 'A' .. 'Z' | '\'' | '_' -> lex_impl t S3 (Var (acc_ ^ (char_to_str h)))
                        | _ -> failwith "Not a valid integer or a valid variable"
                    end
              end
            | Int _ -> failwith "Not a valid integer or a valid variable"
        end
  in
  lex_impl chars S0 (Int 0)

let pp fmt v = 
  match v with
  | Int i -> F.fprintf fmt "Int %d" i
  | Var x -> F.fprintf fmt "Var %s" x 