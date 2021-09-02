module F = Format

type t = (string * string) list 

let empty = []

let add key value map = (* write your code *)
  (*
   * insert key-value into map
   *
   * Args :
   *      key(string) : key
   *      value(string) : value
   *      map(t) : which map you want to insert
   *
   * Return :
   *        t : map of finished insertation
   *)
  let rec find_and_slice k m acc =
    match m with
      | [] -> (("", ""), [], [])
      | (k_, v_) :: t ->
        if k_ = k then ((k_, v_), acc, t)
        else find_and_slice k t (acc @ [(k_, v_)])
  in

  match (find_and_slice key map []) with
    | (("", ""), [], []) -> (key, value) :: map
    | ((_, _), f_, b_) -> f_ @ ((key, value) :: b_)

let find key map = (* write your code *)
  (*
   * find value of key from map
   *
   * Args :
   *      key(string) : key
   *      map(t) : which map you want to search
   *
   * Return :
   *        string : final result of finding value using key
   *)
  let rec find_and_slice k m acc =
    match m with
      | [] -> (("", ""), [], [])
      | (k_, v_) :: t ->
        if k_ = k then ((k_, v_), acc, t)
        else find_and_slice k t (acc @ [(k_, v_)])
  in

  match (find_and_slice key map []) with
    | (("", ""), [], []) -> failwith "No such key exists"
    | ((_, v_), _, _) -> v_

let erase key map = (* write your code *)
  (*
   * erase key-value from map
   *
   * Args :
   *      key(string) : key
   *      map(t) : which map you want to erase key-value
   *
   * Return :
   *        t : map of finished deletaion
   *)
  let rec find_and_slice k m acc =
    match m with
      | [] -> (("", ""), [], [])
      | (k_, v_) :: t ->
        if k_ = k then ((k_, v_), acc, t)
        else find_and_slice k t (acc @ [(k_, v_)])
  in

  match (find_and_slice key map []) with
    | (("", ""), [], []) -> failwith "No such key exists"
    | ((_, _), f_, b_) -> f_ @ b_

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
