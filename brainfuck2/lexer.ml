module String = struct
  include String

  let get_opt s i = if i >= 0 && i < length s then Some (unsafe_get s i) else None
end

type t =
  { source : string
  ; offset : Token.offset
  }

let init source = { source; offset = 0 }

let rec next_token lexer =
  let open Token in
  let ch = String.get_opt lexer.source lexer.offset in
  match ch with
  | None -> lexer, None
  | Some '>' -> advance lexer, Some (IncrementPointer, lexer.offset)
  | Some '<' -> advance lexer, Some (DecrementPointer, lexer.offset)
  | Some '+' -> advance lexer, Some (IncrementByte, lexer.offset)
  | Some '-' -> advance lexer, Some (DecrementByte, lexer.offset)
  | Some '.' -> advance lexer, Some (OutputByte, lexer.offset)
  | Some ',' -> advance lexer, Some (InputByte, lexer.offset)
  | Some '[' -> advance lexer, Some (StartBlock, lexer.offset)
  | Some ']' -> advance lexer, Some (EndBlock, lexer.offset)
  | Some _ -> scan_comment lexer

and scan_comment lexer =
  let offset_start = lexer.offset in
  let rec skip l =
    match String.get_opt l.source l.offset with
    | Some ch when not (is_command ch) -> skip (advance l)
    | _ -> l
  in
  let lexer = skip lexer in
  let comment =
    ( Token.Comment (String.sub lexer.source offset_start (lexer.offset - offset_start))
    , offset_start )
  in
  lexer, Some comment

and advance lexer = { lexer with offset = lexer.offset + 1 }

and is_command = function
  | '>' | '<' | '+' | '-' | '.' | ',' | '[' | ']' -> true
  | _ -> false
;;
