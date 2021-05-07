module F = Format

type value = 
  | NumV of int
  | ClosureV of string * Ast.expr * t
and t = (string * value) list

let empty = []

let insert x n s = 

let rec find x s = 

let rec pp_v fmt v =
  match v with
  | NumV i -> F.fprintf fmt "%d" i
  | ClosureV (p, e, s) -> F.fprintf fmt "<λ%s.%a, %a>" p Ast.pp_e e pp s

and pp fmt s = 
  let rec pp_impl fmt s = 
    match s with
    | [] -> F.fprintf fmt "]"
    | (x, v) :: t -> F.fprintf fmt "(%s, %a) %a" x pp_v v pp_impl t
  in
  F.fprintf fmt "[ %a" pp_impl s
