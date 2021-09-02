module F = Format

(* practice & homework *)
let rec interp_e (e : Ast.expr) ((env, mem) : Env.t * Mem.t) : Mem.value = 
  match e with
    | Num n -> (Mem.NumV n)
    (* fix *)
    | Var v -> (Mem.find (Env.find v env) mem)
    | Ref v -> (AddressV (Env.find v env))
    | Deref v -> (
      match (Mem.find (Env.find v env) mem) with
        | AddressV addr -> (Mem.find addr mem)
        | _ -> failwith (Format.asprintf "Not a memory address : %a" Ast.pp_e e)
    )
    | Bool b -> (Mem.BoolV b)
    | Add (e1, e2) -> (
      match (interp_e e1 (env, mem)) with
        | NumV n1 -> (
          match (interp_e e2 (env, mem)) with
            | NumV n2 -> (Mem.NumV (n1 + n2))
            | _ -> failwith (Format.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Sub (e1, e2) -> (
      match (interp_e e1 (env, mem)) with
        | NumV n1 -> (
          match (interp_e e2 (env, mem)) with
            | NumV n2 -> (Mem.NumV (n1 - n2))
            | _ -> failwith (Format.asprintf "Invalid subtraction: %a - %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid subtraction: %a - %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Lt (e1, e2) -> (
      match (interp_e e1 (env, mem)) with
        | NumV n1 -> (
          match (interp_e e2 (env, mem)) with
            | NumV n2 -> (Mem.BoolV (n1 < n2))
            | _ -> failwith (Format.asprintf "Invalid less-than: %a < %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid less-than: %a < %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Gt (e1, e2) -> (
      match (interp_e e1 (env, mem)) with
        | NumV n1 -> (
          match (interp_e e2 (env, mem)) with
            | NumV n2 -> (Mem.BoolV (n1 > n2))
            | _ -> failwith (Format.asprintf "Invalid greater-than: %a > %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid greater-than: %a > %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Eq (e1, e2) -> (
      match (interp_e e1 (env, mem)) with
        | NumV n1 -> (
          match (interp_e e2 (env, mem)) with
            | NumV n2 -> (Mem.BoolV (n1 = n2))
            | _ -> failwith (Format.asprintf "Invalid equal-to: %a == %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | BoolV b1 -> (
          match (interp_e e2 (env, mem)) with
          | BoolV b2 -> (Mem.BoolV (b1 = b2))
          | _ -> failwith (Format.asprintf "Invalid equal-to: %a == %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid equal-to: %a == %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | And (e1, e2) -> (
      match (interp_e e1 (env, mem)) with
        | BoolV b1 -> (
          match (interp_e e2 (env, mem)) with
            | BoolV b2 -> (Mem.BoolV (b1 && b2))
            | _ -> failwith (Format.asprintf "Invalid logical-and: %a && %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid logical-and: %a && %a" Ast.pp_e e1 Ast.pp_e e2)
    )
    | Or (e1, e2) -> (
      match (interp_e e1 (env, mem)) with
        | BoolV b1 -> (
          match (interp_e e2 (env, mem)) with
            | BoolV b2 -> (Mem.BoolV (b1 || b2))
            | _ -> failwith (Format.asprintf "Invalid logical-or: %a || %a" Ast.pp_e e1 Ast.pp_e e2)
        )
        | _ -> failwith (Format.asprintf "Invalid logical-or: %a || %a" Ast.pp_e e1 Ast.pp_e e2)
    )

(* practice & homework *)
let rec interp_s (stmt : Ast.stmt) ((env, mem) : Env.t * Mem.t) : Env.t * Mem.t = 
  match stmt with
  (* fix *)
  | VarDeclStmt v -> (
    if (Env.mem v env) then failwith (Format.asprintf "%s is already declared." v)
    else ((Env.insert v (Env.new_address ()) env), mem)
  )
  | StoreStmt (e1, e2) -> (
    match (interp_e e1 (env, mem)) with
      | AddressV addr -> (env, (Mem.insert addr (interp_e e2 (env, mem)) mem))
      | _ -> failwith (Format.asprintf "Not a memory address: %a" Ast.pp_e e1)
  )
  | WhileStmt (exp, stmt_list)-> (
      match (interp_e exp (env, mem)) with
        | BoolV b -> (
          if b then (interp_s (WhileStmt (exp, stmt_list)) (List.fold_right interp_s (List.rev stmt_list) (env, mem)))
          else (env, mem)
        )
        | _ -> failwith (Format.asprintf "Not a boolean: %a" Ast.pp_e exp)
  )
  | IfStmt (exp, true_branch, false_branch) -> (
    match (interp_e exp (env, mem)) with
      | BoolV bln-> (
        if bln then (List.fold_right interp_s (List.rev true_branch) (env, mem))
        else (
          match false_branch with
            | None -> (env, mem)
            | Some stmt_list -> (List.fold_right interp_s (List.rev stmt_list) (env, mem))
        )
      )
      | _ -> failwith (Format.asprintf "Not a boolean: %a" Ast.pp_e exp)
  )

(* practice & homework *)
let interp (p : Ast.program) : Env.t * Mem.t = 
  match p with
    | Program stmt_list -> (List.fold_right interp_s (List.rev stmt_list) (Env.empty, Mem.empty))