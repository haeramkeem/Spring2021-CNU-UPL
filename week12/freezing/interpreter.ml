module F = Format

(* practice & homework *)
let rec interp_e (s : Store.t) (e : Ast.expr) : Store.value = 
  match e with
  (*Number------------------------------------------------------------------------------------------*)
    | Num i -> (Store.NumV i)
  (*Addition----------------------------------------------------------------------------------------*)
    | Add (e1, e2) -> (
      match (interp_e s e1) with
        | NumV n1 -> (
          match (interp_e s e2) with
            | NumV n2 -> (Store.NumV (n1 + n2))
            | _ -> failwith (Format.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
    )
  (*Substitution-------------------------------------------------------------------------------------*)
    | Sub (e1, e2) -> (
      match (interp_e s e1) with
        | NumV n1 -> (
          match (interp_e s e2) with
            | NumV n2 -> (Store.NumV (n1 - n2))
            | _ -> failwith (Format.asprintf "Invalid subtraction: %a - %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid subtraction: %a - %a" Ast.pp_e e1 Ast.pp_e e2)
    )
  (*Variable------------------------------------------------------------------------------------------*)
    | Id v -> (
      match (Store.find v s) with
        | Store.FreezedV (e1, s1) -> (interp_e s1 e1)
        | any -> any
    )
  (*LetIn---------------------------------------------------------------------------------------------*)
    | LetIn (v, e1, e2) -> (interp_e (Store.insert v (interp_e s e1) s) e2)
  (*RLetIn--------------------------------------------------------------------------------------------*)
    | RLetIn (v, e1, e2) -> (
      match (interp_e s e1) with
        | Store.ClosureV (arg, body, s1) -> (
          let rec s2 = (v, (Store.ClosureV (arg, body, s2))) :: s1 in
          (interp_e s2 e2)
        )
        | _ -> failwith (Format.asprintf "Not a function: %a" Ast.pp_e e1)
    )
  (*Function Application-------------------------------------------------------------------------------*)
    | App (e1, e2) -> (
      match (interp_e s e1) with
        | ClosureV (arg, exp, st) -> (interp_e (Store.insert arg (Store.FreezedV (e2, s)) st) exp)
        | _ -> failwith (Format.asprintf "Not a function: %a" Ast.pp_e e1)
    )
  (*Function Definition--------------------------------------------------------------------------------*)
    | Fun (arg, exp) -> (Store.ClosureV (arg, exp, s))
  (*Less Than------------------------------------------------------------------------------------------*)
    | Lt (e1, e2) -> (
      match (interp_e s e1) with
        | NumV n1 -> (
          match (interp_e s e2) with
            | NumV n2 -> (
              if n1 < n2 then (Store.ClosureV ("x", Fun ("y", Id "x"), []))
              else (Store.ClosureV ("x", Fun ("y", Id "y"), []))
            )
            | _ -> failwith (Format.asprintf "Invalid less-than: %a < %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid less-than: %a < %a" Ast.pp_e e1 Ast.pp_e e2)
    )

(* practice & homework *)
let interp (p : Ast.fvae) : Store.value = 
  match p with
    | Prog exp -> (interp_e Store.empty exp)