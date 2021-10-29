open Cmdliner

let root_term = Term.ret (Term.const (`Help (`Pager, None)))

let root_cmd =
  let info =
    Term.info "virtu" ~doc:"Manage VMs from the command-line"
      ~man:
        [
          `S Manpage.s_description;
          `P "Create and manage virtual machines using this CLI.";
        ]
  in
  (root_term, info)

let () = Term.(exit @@ eval_choice root_cmd [ Create.cmd ])
