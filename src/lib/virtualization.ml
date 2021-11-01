module Bootloader = struct
  module Linux = struct
    type t

    external create : string -> t = "caml_linux_boot_loader"
  end
end

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

    external ext_set_input_output :
      Unix.file_descr -> Unix.file_descr -> t -> unit
      = "caml_set_serial_port_attachment"

    let set_input_output ~input ~output t = ext_set_input_output input output t
  end

  external create : unit -> t = "caml_serial_configuration"
end

module Config = struct
  type t

  external ext_create : unit -> t = "caml_vm_configuration"

  external set_cpu_count : int -> t -> unit = "caml_vm_set_cpu_count"

  external set_memory_size : int -> t -> unit = "caml_vm_set_memory_size"

  external set_bootloader : Bootloader.Linux.t -> t -> unit
    = "caml_vm_set_bootloader"

  external set_serial_virtio_port : Serial.Virtio.t -> t -> unit
    = "caml_vm_set_serial_port_virtio"

  let create ?serial_virtio_port ~cpus ~memory_size ~bootloader () =
    let conf = ext_create () in
    set_cpu_count cpus conf;
    set_memory_size (memory_size * 1024 * 1024) conf;
    set_bootloader bootloader conf;
    Option.iter (fun v -> set_serial_virtio_port v conf) serial_virtio_port;
    conf
end
