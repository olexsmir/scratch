let rec pp_ast fmt = function
  | Ast.IncrementPointer -> Format.pp_print_string fmt ">"
  | Ast.DecrementPointer -> Format.pp_print_string fmt "<"
  | Ast.IncrementByte -> Format.pp_print_string fmt "+"
  | Ast.DecrementByte -> Format.pp_print_string fmt "-"
  | Ast.Input -> Format.pp_print_string fmt ","
  | Ast.Output -> Format.pp_print_string fmt "."
  | Ast.Loop body -> Format.fprintf fmt "[%a]" (Format.pp_print_list pp_ast) body
;;

let ast_testable = Alcotest.testable pp_ast ( = )

let error_testable =
  Alcotest.testable
    (fun fmt error -> Format.pp_print_string fmt (Ast.error_to_string error))
    ( = )
;;

let result_testable = Alcotest.result (Alcotest.list ast_testable) error_testable

let require_progressing_lexer () =
  match Lexer.next_token (Lexer.init "+") with
  | lexer, Some (Token.IncrementByte, 0) when lexer.offset = 1 -> ()
  | _ ->
    Alcotest.fail
      "lexer does not advance on '+' (see lexer.ml); parser tests cannot run until the \
       lexer is fixed"
;;

let check name expected source =
  require_progressing_lexer ();
  Alcotest.(check result_testable) name expected (Ast.parse (Lexer.init source))
;;

let () =
  Alcotest.run
    "brainfuck2"
    [ ( "parser"
      , [ Alcotest.test_case "empty program" `Quick (fun () -> check "empty" (Ok []) "")
        ; Alcotest.test_case "flat sequence" `Quick (fun () ->
            check
              "flat"
              (Ok
                 [ Ast.IncrementByte
                 ; Ast.DecrementByte
                 ; Ast.IncrementPointer
                 ; Ast.DecrementPointer
                 ])
              "+-><")
        ; Alcotest.test_case "plus is not minus" `Quick (fun () ->
            check "plus" (Ok [ Ast.IncrementByte ]) "+";
            check "minus" (Ok [ Ast.DecrementByte ]) "-")
        ; Alcotest.test_case "comments are skipped" `Quick (fun () ->
            check "comments" (Ok [ Ast.IncrementByte ]) "a+b";
            check "comments in loop" (Ok [ Ast.Loop [ Ast.IncrementByte ] ]) "[a+b]")
        ; Alcotest.test_case "simple loop" `Quick (fun () ->
            check "loop" (Ok [ Ast.Loop [ Ast.IncrementByte ] ]) "[+]")
        ; Alcotest.test_case "empty loop" `Quick (fun () ->
            check "empty loop" (Ok [ Ast.Loop [] ]) "[]")
        ; Alcotest.test_case "nested loops" `Quick (fun () ->
            check
              "nested"
              (Ok
                 [ Ast.IncrementByte
                 ; Ast.Loop
                     [ Ast.IncrementPointer
                     ; Ast.Loop [ Ast.DecrementByte ]
                     ; Ast.DecrementPointer
                     ]
                 ])
              "+[>[-]<]")
        ; Alcotest.test_case "sequence after loop" `Quick (fun () ->
            check
              "after"
              (Ok
                 [ Ast.Loop [ Ast.IncrementByte ]
                 ; Ast.IncrementPointer
                 ; Ast.Input
                 ; Ast.Output
                 ])
              "[+]>,.")
        ; Alcotest.test_case "unmatched open" `Quick (fun () ->
            check "just open" (Error (Ast.UnmatchedOpen 0)) "[";
            check "after commands" (Error (Ast.UnmatchedOpen 2)) "++[+")
        ; Alcotest.test_case "unmatched close" `Quick (fun () ->
            check "just close" (Error (Ast.UnmatchedClose 0)) "]";
            check "after loop" (Error (Ast.UnmatchedClose 3)) "[+]]")
        ; Alcotest.test_case "innermost unclosed bracket is reported" `Quick (fun () ->
            check "inner" (Error (Ast.UnmatchedOpen 2)) "[+[+";
            check "outer" (Error (Ast.UnmatchedOpen 0)) "[[+]")
        ] )
    ]
;;
