type t =
  | IncrementPointer
  | DecrementPointer
  | IncrementByte
  | DecrementByte
  | Input
  | Output
  | Loop of t list

type error =
  | UnmatchedOpen of Token.offset
  | UnmatchedClose of Token.offset

let error_to_string = function
  | UnmatchedOpen offset -> Printf.sprintf "unmatched '[' at offset %d" offset
  | UnmatchedClose offset -> Printf.sprintf "unmatched ']' at offset %d" offset
;;

let parse lexer =
  let rec loop lexer stack acc =
    let lexer, token = Lexer.next_token lexer in
    match token with
    | None ->
      (match stack with
       | [] -> Ok (List.rev acc)
       | (offset, _) :: _ -> Error (UnmatchedOpen offset))
    | Some (Token.Comment _, _) -> loop lexer stack acc
    | Some (Token.IncrementPointer, _) -> loop lexer stack (IncrementPointer :: acc)
    | Some (Token.DecrementPointer, _) -> loop lexer stack (DecrementPointer :: acc)
    | Some (Token.IncrementByte, _) -> loop lexer stack (IncrementByte :: acc)
    | Some (Token.DecrementByte, _) -> loop lexer stack (DecrementByte :: acc)
    | Some (Token.OutputByte, _) -> loop lexer stack (Output :: acc)
    | Some (Token.InputByte, _) -> loop lexer stack (Input :: acc)
    | Some (Token.StartBlock, offset) -> loop lexer ((offset, acc) :: stack) []
    | Some (Token.EndBlock, offset) ->
      (match stack with
       | [] -> Error (UnmatchedClose offset)
       | (_, outer) :: stack -> loop lexer stack (Loop (List.rev acc) :: outer))
  in
  loop lexer [] []
;;
