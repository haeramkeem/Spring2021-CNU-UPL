module F = Format

(* practice & homework *)
let rec interp_e (s : Store.t) (e : Ast.expr) : Store.value = 
  match e with
  | Ast.Num n -> Store.NumV n
  | Ast.Add (e1, e2) -> 
      begin
        match interp_e s e1, interp_e s e2 with
        | Store.NumV n1, Store.NumV n2 -> Store.NumV (n1 + n2)
        | _ -> failwith (F.asprintf "Invalid addition: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
      end
  | Ast.Sub (e1, e2) ->
      begin
        match interp_e s e1, interp_e s e2 with
        | Store.NumV n1, Store.NumV n2 -> Store.NumV (n1 - n2)
        | _ -> failwith (F.asprintf "Invalid subtraction: %a + %a" Ast.pp_e e1 Ast.pp_e e2)
      end
  | Ast.Id x -> Lazy.force (Store.find x s)
  | Ast.LetIn (x, e1, e2) -> 
      let v = lazy(interp_e s e1) in
      let s' = Store.insert x v s in
      interp_e s' e2
  | Ast.RLetIn (x, e1, e2) -> 
      begin
      match interp_e s e1 with
      | Store.ClosureV (x', e, s') ->
          let rec s'' = (x, lazy(Store.ClosureV (x', e, s''))) :: s' in
          interp_e s'' e2
      | _ -> failwith (F.asprintf "Not a function: %a" Ast.pp_e e1)
      end
  | Ast.App(e1, e2) -> 
      begin
        match interp_e s e1 with
        | Store.ClosureV (p, e, s') ->
            let v = lazy(interp_e s e2) in
            let s'' = Store.insert p v s' in
            interp_e s'' e
        | _ -> failwith (F.asprintf "Not a function: %a" Ast.pp_e e1) 
      end
  | Ast.Fun(p, e) -> Store.ClosureV (p, e, s)
  | Ast.Lt(e1, e2) -> 
      begin
        match (interp_e s e1), (interp_e s e2) with
        | NumV n1, NumV n2 -> 
            begin
              match n1 < n2 with
              | true -> Store.ClosureV ("x", Ast.Fun("y", Ast.Id "x"), Store.empty)
              | false -> Store.ClosureV ("x", Ast.Fun("y", Ast.Id "y"), Store.empty)
            end
        | _ -> failwith (F.asprintf "Invalid less-than: %a < %a" Ast.pp_e e1 Ast.pp_e e2)
      end

(* practice & homework *)
let interp (p : Ast.fvae) : Store.value = 
  match p with
  | Ast.Prog e -> interp_e Store.empty e
