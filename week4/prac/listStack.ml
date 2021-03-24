module F = Format

type t = int list

let empty = []

(* Practice1 *)
let push elem stack = (* write your code *) 

(* Practice2 *)
let pop stack = (* write your code *) 

let print_stack fmt stack = 
  let rec print_stack_impl stack = 
    match stack with
    | [] -> ()
    | h :: t -> 
        let () = F.fprintf fmt "%d " h in
        print_stack_impl t
  in
  let () = F.fprintf fmt "[ " in
  let () = print_stack_impl stack in
  F.fprintf fmt "]"
