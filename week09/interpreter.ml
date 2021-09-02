module F = Format

let rec interp_e (fenv : FEnv.t) (s : Store.t) (e : Ast.expr) : int = 
  (* write your code *)
  match e with
    | Num i -> i
    | Add (e1, e2) -> (interp_e fenv s e1) + (interp_e fenv s e2)
    | Sub (e1, e2) -> (interp_e fenv s e1) - (interp_e fenv s e2)
    | Id str -> Store.find str s
    | LetIn (v, e1, e2) -> interp_e fenv (Store.insert v (interp_e fenv s e1) s) e2
    | FCall (fname, params) -> (
      let rec make_fstore fenv s fargs plist acc =
        match plist with
          | [] -> (
            if fargs = [] then acc
            else failwith "Grammar Error"
          )
          | exp :: rest_param -> (
            match fargs with
              | [] -> failwith "Grammar Error"
              | arg :: rest_args -> (
                make_fstore fenv s rest_args rest_param (Store.insert arg (interp_e fenv s exp) acc)
              )
          )
      in
      let (args, exp) = FEnv.find fname fenv in
      interp_e fenv (make_fstore fenv s args params Store.empty) exp
    )

let interp_d (fenv : FEnv.t) (fd : Ast.fundef) : FEnv.t = 
  (* write your code *)
  match fd with
    | FDef (fname, args, exp) -> FEnv.insert fname args exp fenv

(* practice *)
let interp (p : Ast.f1vae) : int = 
  (* write your code *)
  let rec make_fenv flist acc =
    match flist with
      | [] -> acc
      | fd :: t -> make_fenv t (interp_d acc fd)
  in
  match p with
    | Prog (flist, exp) -> (
      interp_e (make_fenv flist FEnv.empty) Store.empty exp
    )