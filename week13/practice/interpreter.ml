module F = Format

(* practice & homework *)
let rec interp_e (e : Ast.expr) (s : Store.t) : Store.value = 
  match e with
    | Num n -> (Store.NumV n)
    | Var v -> (Store.find v s)
    | Bool b -> (Store.BoolV b)
    | Add (e1, e2) -> (
      match (interp_e e1 s) with
        | NumV n1 -> (
          match (interp_e e2 s) with
            | NumV n2 -> (Store.NumV (n1 + n2))
            | _ -> failwith (Format.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Sub (e1, e2) -> (
      match (interp_e e1 s) with
        | NumV n1 -> (
          match (interp_e e2 s) with
            | NumV n2 -> (Store.NumV (n1 - n2))
            | _ -> failwith (Format.asprintf "Invalid subtraction: %a - %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid subtraction: %a - %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Lt (e1, e2) -> (
      match (interp_e e1 s) with
        | NumV n1 -> (
          match (interp_e e2 s) with
            | NumV n2 -> (Store.BoolV (n1 < n2))
            | _ -> failwith (Format.asprintf "Invalid less-than: %a < %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid less-than: %a < %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Gt (e1, e2) -> (
      match (interp_e e1 s) with
        | NumV n1 -> (
          match (interp_e e2 s) with
            | NumV n2 -> (Store.BoolV (n1 > n2))
            | _ -> failwith (Format.asprintf "Invalid greater-than: %a > %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid greater-than: %a > %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Eq (e1, e2) -> (
      match (interp_e e1 s) with
        | NumV n1 -> (
          match (interp_e e2 s) with
            | NumV n2 -> (Store.BoolV (n1 = n2))
            | _ -> failwith (Format.asprintf "Invalid equal-to: %a == %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | BoolV b1 -> (
          match (interp_e e2 s) with
          | BoolV b2 -> (Store.BoolV (b1 = b2))
          | _ -> failwith (Format.asprintf "Invalid equal-to: %a == %a" Ast.pp_e e1 Ast.pp_e e2)
        )
    )
    | And (e1, e2) -> (
      match (interp_e e1 s) with
        | BoolV b1 -> (
          match (interp_e e2 s) with
            | BoolV b2 -> (Store.BoolV (b1 && b2))
            | _ -> failwith (Format.asprintf "Invalid logical-and: %a && %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid logical-and: %a && %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Or (e1, e2) -> (
      match (interp_e e1 s) with
        | BoolV b1 -> (
          match (interp_e e2 s) with
            | BoolV b2 -> (Store.BoolV (b1 || b2))
            | _ -> failwith (Format.asprintf "Invalid logical-or: %a || %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid logical-or: %a || %a" Ast.pp_e e1 Ast.pp_e e2)
    )
  

(* practice & homework *)
let rec interp_s (stmt : Ast.stmt) (s : Store.t) : Store.t =
  match stmt with
  | AssignStmt (str, exp) -> (Store.insert str (interp_e exp s) s)
  | IfStmt (exp, stmt_list, stmt_list_option) -> (
    match (interp_e exp s) with
      | BoolV bln-> (
        if bln then (List.fold_right interp_s (List.rev stmt_list) s)
        else (
          match stmt_list_option with
            | None -> s
            | Some slist -> (List.fold_right interp_s (List.rev slist) s)
        )
      )
      | _ -> failwith (Format.asprintf "Not a boolean: %a" Ast.pp_e exp)
  )

(* practice & homework *)
let interp (p : Ast.program) : Store.t = 
  match p with
    | Program slist -> (List.fold_right interp_s (List.rev slist) [])