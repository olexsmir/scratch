type state =
  { left : int list
  ; current : int
  ; right : int list
  ; input : char list
  ; output : char list
  }

let init ?(input = []) () = { left = []; current = 0; right = []; input; output = [] }
let output state = List.rev state.output |> List.to_seq |> String.of_seq

let rec run_instr state = function
  | Ast.IncrementPointer -> inc_ptr state
  | Ast.DecrementPointer -> dec_ptr state
  | Ast.IncrementByte -> inc_byte state
  | Ast.DecrementByte -> dec_byte state
  | Ast.Input -> read_input state
  | Ast.Output -> write_output state
  | Ast.Loop body -> loop state body

and inc_ptr state =
  match state.right with
  | [] -> { state with left = state.current :: state.left; current = 0 }
  | next :: right ->
    { state with left = state.current :: state.left; current = next; right }

and dec_ptr state =
  match state.left with
  | [] -> { state with current = 0; right = state.current :: state.right }
  | prev :: left ->
    { state with left; current = prev; right = state.current :: state.right }

and inc_byte state = { state with current = (state.current + 1) land 0xff }
and dec_byte state = { state with current = (state.current - 1) land 0xff }

and read_input state =
  match state.input with
  | [] -> { state with current = 0 }
  | c :: input -> { state with current = Char.code c; input }

and write_output state = { state with output = Char.chr state.current :: state.output }
and run state program = List.fold_left run_instr state program

and loop state body =
  let rec loop state = if state.current = 0 then state else loop (run state body) in
  loop state
;;
