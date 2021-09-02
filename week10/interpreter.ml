module F = Format

(* practice & homework *)
let rec interp_e (s : Store.t) (e : Ast.expr) : Store.value = 
  match e with
    | Num i -> (Store.NumV i)
    | Add (e1, e2) -> (
      match (interp_e s e1) with
        | ClosureV _ -> failwith (Format.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
        | NumV n1 -> (
          match (interp_e s e2) with
            | ClosureV _ -> failwith (Format.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
            | NumV n2 -> (Store.NumV (n1 + n2))
        )
    )
    | Sub (e1, e2) -> (
      match (interp_e s e1) with
        | ClosureV _ -> failwith (Format.asprintf "Invalid subtraction: %a - %a" Ast.pp_e e1 Ast.pp_e e2)
        | NumV n1 -> (
          match (interp_e s e2) with
            | ClosureV _ -> failwith (Format.asprintf "Invalid subtraction: %a - %a" Ast.pp_e e1 Ast.pp_e e2)
            | NumV n2 -> (Store.NumV (n1 - n2))
        )
    )
    | Id v -> (Store.find v s)
    | LetIn (v, e1, e2) -> (interp_e (Store.insert v (interp_e s e1) s) e2)
    | App (e1, e2) -> (
      match (interp_e s e1) with
        | NumV _ -> failwith (Format.asprintf "Not a function: %a" Ast.pp_e e1)
        | ClosureV (arg, exp, st) -> (interp_e (Store.insert arg (interp_e s e2) st) exp)
    )
    | Fun (arg, exp) -> (Store.ClosureV (arg, exp, s))

(* practice & homework *)
let interp (p : Ast.fvae) : Store.value = 
  match p with
    | Prog exp -> (interp_e Store.empty exp)