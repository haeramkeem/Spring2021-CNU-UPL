module F = Format

(* Test cases *)
let _ =
  let empty_stack = ListStack.empty in (* empty_stack = [] *)
  let stack1 = ListStack.push 1 empty_stack in  (* stack1 = [1] *)
  let stack1' = ListStack.push 2 stack1 in (* stack1' = [2; 1] *)
  let stack1'' = ListStack.push 3 stack1' in (* stack1'' = [3; 2; 1] *)
  let v1, stack2 = ListStack.pop stack1'' in (* v1 = 3, stack2 = [2; 1] *)
  let v2, stack2' = ListStack.pop stack2 in (* v2 = 2, stack2' = [1] *)
  let v3, stack2'' = ListStack.pop stack2' in (*v3 = 1, stack2'' = [] *)
  let () = F.printf "EMPTY_STACK: %a\n" ListStack.print_stack empty_stack in
  let () = F.printf "STACK1: %a\n" ListStack.print_stack stack1 in
  let () = F.printf "STACK1': %a\n" ListStack.print_stack stack1' in
  let () = F.printf "STACK1'': %a\n" ListStack.print_stack stack1'' in
  let () = F.printf "STACK2: %a\n" ListStack.print_stack stack2 in
  let () = F.printf "STACK2': %a\n" ListStack.print_stack stack2' in
  let () = F.printf "STACK2'': %a\n" ListStack.print_stack stack2'' in
  let () = F.printf "V1 : %d\n" v1 in
  let () = F.printf "V2 : %d\n" v2 in
  let () = F.printf "V3 : %d\n" v3 in
  try
    let _ = ListStack.pop stack2'' in ()
  with Failure e ->
    F.printf "Exception occurs : %s\n" e (* Exception occurs : Stack is empty *)