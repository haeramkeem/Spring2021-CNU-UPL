module F = Format

(* practice *)
let rec interp (e : Ast.ae) : int =
  match e with
    | Num v -> v
    | Add (f, s) -> (interp f) + (interp s)
    | Sub (f, s) -> (interp f) - (interp s)
    | Neg v -> (-1) * (interp v)