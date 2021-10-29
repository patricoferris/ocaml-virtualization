open Cmdliner

let ( let+ ) t f = Term.(const f $ t)
let ( and+ ) a b = Term.(const (fun x y -> (x, y)) $ a $ b)

let cpus_term =
  let i = 
    Arg.info ["cpus"] ~doc:"Number of CPUS for the virtual machine" ~docv:"CPUS"
  in 
  Arg.(value (opt int 1 i)) 

let memory_term =
  let i = 
    Arg.info ["memory"] ~doc:"Amount of memory for the VM in megabytes" ~docv:"MEMORY"
  in 
  Arg.(value (opt int 10 i)) 

let run cpus memory_size = 
  let _conf = Virtualization.Config.create ~cpus ~memory_size in 
  ()

let term =
  let+ cpus = cpus_term
  and+ memory = memory_term in
  run cpus memory

let cmd = 
  let info = 
    Term.info "create" 
      ~doc:"Create a new virtual machine"
      ~man:[
        `S Manpage.s_description;
        `P "Create a new virtual machine using the Virtualization framework"
      ]
  in
    (term, info)
