let token_testable =
  Alcotest.testable
    (fun fmt token -> Format.pp_print_string fmt (Token.to_string token))
    ( = )
;;

let lex_all source =
  let rec loop lexer count acc =
    match Lexer.next_token lexer with
    | _, None -> List.rev acc
    | lexer, Some token ->
      if count > String.length source
      then Alcotest.failf "lexer did not terminate on %S" source;
      loop lexer (count + 1) (token :: acc)
  in
  loop (Lexer.init source) 0 []
;;

let check_tokens name expected source =
  Alcotest.(check (list (pair token_testable int))) name expected (lex_all source)
;;

let () =
  Alcotest.run
    "brainfuck2"
    [ ( "lexer"
      , [ Alcotest.test_case "init keeps source and zero offset" `Quick (fun () ->
            let lexer = Lexer.init "+-<>" in
            Alcotest.(check string) "source" "+-<>" lexer.source;
            Alcotest.(check int) "offset" 0 lexer.offset)
        ; Alcotest.test_case "empty source has no tokens" `Quick (fun () ->
            check_tokens "tokens" [] "")
        ; Alcotest.test_case "each command lexes to its token" `Quick (fun () ->
            check_tokens
              "tokens"
              [ Token.IncrementPointer, 0
              ; Token.DecrementPointer, 1
              ; Token.IncrementByte, 2
              ; Token.DecrementByte, 3
              ; Token.OutputByte, 4
              ; Token.InputByte, 5
              ; Token.StartBlock, 6
              ; Token.EndBlock, 7
              ]
              "><+-.,[]")
        ; Alcotest.test_case
            "consecutive commands have consecutive offsets"
            `Quick
            (fun () ->
               check_tokens
                 "tokens"
                 [ Token.IncrementByte, 0; Token.IncrementByte, 1 ]
                 "++")
        ; Alcotest.test_case "non-command run is one comment" `Quick (fun () ->
            check_tokens "tokens" [ Token.Comment "hello world!?", 0 ] "hello world!?")
        ; Alcotest.test_case "comment ends at next command" `Quick (fun () ->
            check_tokens
              "tokens"
              [ Token.Comment "ab", 0; Token.IncrementByte, 2; Token.Comment "cd", 3 ]
              "ab+cd")
        ; Alcotest.test_case "comment runs to end of input" `Quick (fun () ->
            check_tokens
              "tokens"
              [ Token.IncrementByte, 0; Token.Comment "trailing", 1 ]
              "+trailing")
        ] )
    ]
;;
