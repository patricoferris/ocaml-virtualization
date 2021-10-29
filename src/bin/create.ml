open Cmdliner

let ( let+ ) t f = Term.(const f $ t)

let ( and+ ) a b = Term.(const (fun x y -> (x, y)) $ a $ b)

let cpus_term =
  let i =
    Arg.info [ "cpus" ] ~doc:"Number of CPUS for the virtual machine"
      ~docv:"CPUS"
  in
  Arg.(value (opt int 2 i))

let memory_term =
  let i =
    Arg.info [ "memory" ] ~doc:"Amount of memory for the VM in megabytes"
      ~docv:"MEMORY"
  in
  Arg.(value (opt int 1024 i))

let kernel_url_term =
  let i = Arg.info [ "kernel" ] ~doc:"Linux Kernel URL" ~docv:"KERNEL" in
  Arg.(required (opt (some string) None i))

let run cpus memory_size kernel_url =
  let open Virtualization in
  let bootloader = Bootloader.Linux.create kernel_url in
  let _conf = Virtualization.Config.create ~cpus ~memory_size ~bootloader in
  ()

let term =
  let+ cpus = cpus_term
  and+ memory = memory_term
  and+ kernel_url = kernel_url_term in
  run cpus memory kernel_url

let cmd =
  let info =
    Term.info "create" ~doc:"Create a new virtual machine"
      ~man:
        [
          `S Manpage.s_description;
          `P "Create a new virtual machine using the Virtualization framework";
        ]
  in
  (term, info)
