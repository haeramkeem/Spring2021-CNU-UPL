module F = Format

type t = (string * string) list 

let empty = []

let add key value map = (* write your code *)

let rec find key map = (* write your code *)

let rec erase key map = (* write your code *)

let print_map fmt map = 
  let rec print_map_impl map = 
    match map with
    | [] -> ()
    | (k, v) :: t -> 
        let () = F.fprintf fmt "(%s, %s) " k v in
        print_map_impl t
  in
  let () = F.fprintf fmt "[ " in
  let () = print_map_impl map in
  F.fprintf fmt "]"
