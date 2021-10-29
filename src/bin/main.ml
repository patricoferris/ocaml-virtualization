open Cmdliner

let root_term = Term.ret (Term.const (`Help (`Pager, None)))

let root_cmd =
    let info =
      Term.info "virt" ~doc:"Manage VMs from the command-line"
        ~man:[
        `S Manpage.s_description;
        `P "This tool can be used to aggregate and process OKR reports in a \
            specific format. See project README for details.";
        ]
     in
    (root_term, info)

let () =
    Term.(exit @@ eval_choice root_cmd [ Create.cmd ])
