module F = Format

let rec interp_e (fenv : FEnv.t) (s : Store.t) (e : Ast.expr) : int = 
  match e with
  | Ast.Num n -> n
  | Ast.Add (e1, e2) -> (interp_e fenv s e1) + (interp_e fenv s e2)
  | Ast.Sub (e1, e2) -> (interp_e fenv s e1) - (interp_e fenv s e2)
  | Ast.Id x -> Store.find x s
  | Ast.LetIn (x, e1, e2) -> 
      let n = interp_e fenv s e1 in
      let s' = Store.insert x n s in
      interp_e fenv s' e2
  | Ast.FCall (f, elist) -> 
      let plist, body = FEnv.find f fenv in
      if List.length(elist) <> List.length(plist) then
        failwith "Arity mismatched."
      else
        let vlist = List.fold_right (fun e l ->
          (interp_e fenv s e) :: l) elist [] in
        let s' = List.fold_left2 (fun s p a -> Store.insert p a s) Store.empty
          plist vlist in
        interp_e fenv s' body

let interp_d (fenv : FEnv.t) (fd : Ast.fundef) : FEnv.t = 
  match fd with
  | FDef (f, plist, e) -> FEnv.insert f plist e fenv

(* practice *)
let interp (p : Ast.f1vae) : int = 
  match p with
  | Ast.Prog (fdlist, e) -> 
      let fenv = List.fold_left (fun fenv fd -> interp_d fenv fd) FEnv.empty fdlist in
      interp_e fenv Store.empty e

