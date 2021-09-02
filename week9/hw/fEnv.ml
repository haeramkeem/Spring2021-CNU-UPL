module F = Format

type t = (string * (string list * Ast.expr)) list

let empty = []

let insert x plist body s =
  (* write your code *)
  let rec insert_impl f acc s = 
    match s with
      | [] -> acc
      | (fname, rest) :: t -> (
        if fname = f then (acc @ t)
        else insert_impl f (acc @ [(fname, rest)]) t
      )
  in
  let deleted = insert_impl x [] s in
  (x, (plist, body)) :: deleted

let rec find x s = 
  (* write your code *)
  match s with
    | [] -> failwith ("Free identifier " ^ x)
    | (fname, rest) :: t -> (
      if fname = x then rest
      else find x t
    )

let pp fmt s = 
  let rec pp_impl fmt s = 
    match s with
    | [] -> F.fprintf fmt "]"
    | (x, (p, e)) :: t -> F.fprintf fmt "(%s, (%s, %a)) %a" x p Ast.pp_e e pp_impl t
  in
  F.fprintf fmt "[ %a" pp_impl s
