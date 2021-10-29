module Network = struct
  module Macaddr = struct 
    type t

    external create : unit -> t = "caml_macaddress"
  end
  type t

  external ext_create : unit -> t = "caml_network_configuration"
  external set_macaddr : Macaddr.t -> t -> unit = "caml_network_set_macaddress"

  let create ?macaddr () =
    let conf = ext_create () in
    Option.iter (fun m -> set_macaddr m conf) macaddr;
    conf
end

module Serial = struct
  type t

  module Virtio = struct
    type t 
    external create : unit -> t = "caml_virtio_serial_configuration"
  end 

  external create : unit -> t = "caml_serial_configuration"
end

module Config = struct 
  type t 
  external ext_create : unit -> t = "caml_vm_configuration"
  external set_cpu_count : int -> t -> unit = "caml_vm_set_cpu_count"
  external set_memory_size : int -> t -> unit = "caml_vm_set_memory_size"
  
  let create ~cpus ~memory_size =
    let conf = ext_create () in 
    set_cpu_count cpus conf;
    set_memory_size (memory_size * 1024 * 1024) conf;
    conf
end
