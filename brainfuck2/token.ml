type offset = int

type t =
  | Comment of string
  | IncrementPointer
  | DecrementPointer
  | IncrementByte
  | DecrementByte
  | OutputByte
  | InputByte
  | StartBlock
  | EndBlock

let to_string = function
  | Comment cmt -> cmt
  | IncrementPointer -> ">"
  | DecrementPointer -> "<"
  | IncrementByte -> "+"
  | DecrementByte -> "-"
  | OutputByte -> "."
  | InputByte -> ","
  | StartBlock -> "["
  | EndBlock -> "]"
;;
