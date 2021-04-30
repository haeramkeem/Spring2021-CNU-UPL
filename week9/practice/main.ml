module F = Format

(* Test cases *)
let _ = 
  let open Ast in
  let open Interpreter in
  let a = (FDef ("foo", "x", (Add (Num 1, Id "x")))) in
  let b = (FCall ("foo", (Num 4))) in
  let c = (Prog (a, b)) in
  let _ = F.printf "AST: %a\n" pp c in
  let _ = F.printf "RES: %n\n" (interp c) in
  ()
