module F = Format

type t = (string * int) list

let empty = []

let insert x n s =
  (* write your code *)
  let rec insert_impl x f s =
    match s with
      | [] -> f
      | (str, i) :: t -> (
        if str = x then (f @ t)
        else insert_impl x (f @ [(str, i)]) t
      )
  in
  let deleted = insert_impl x [] s in
  (x, n) :: deleted

let rec find x s = 
  (* write your code *)
  match s with
  | [] -> failwith ("Free identifier " ^ x)
  | (str, i) :: t -> (
    if str = x then i
    else find x t
  )

let pp fmt s = 
  let rec pp_impl fmt s = 
    match s with
    | [] -> F.fprintf fmt "]"
    | (x, n) :: t -> F.fprintf fmt "(%s, %d) %a" x n pp_impl t
  in
  F.fprintf fmt "[ %a" pp_impl s
