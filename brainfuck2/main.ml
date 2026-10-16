let () =
  match Array.to_list Sys.argv with
  | [ _; fpath ] ->
    let source = In_channel.with_open_bin fpath In_channel.input_all in
    (match Ast.parse (Lexer.init source) with
     | Error err ->
       Printf.eprintf "%s: %s\n" fpath (Ast.error_to_string err);
       exit 1
     | Ok program -> program |> Eval.run (Eval.init ()) |> Eval.output |> print_string)
  | _ ->
    prerr_endline "usage: brainfuck2 <file.bf>";
    exit 1
;;
