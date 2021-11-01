module Bootloader : sig
  module Linux : sig
    type t

    val create : string -> t
    (** Create a new linux boot loader with the specified kernel path *)
  end
end

module Network : sig
  module Macaddr : sig
    type t

    val create : unit -> t
  end

  type t

  val create : ?macaddr:Macaddr.t -> unit -> t
end

module Serial : sig
  type t

  module Virtio : sig
    type t

    val create : unit -> t

    val set_input_output :
      input:Unix.file_descr -> output:Unix.file_descr -> t -> unit
  end

  val create : unit -> t
end

module Config : sig
  type t

  val create :
    ?serial_virtio_port:Serial.Virtio.t ->
    cpus:int ->
    memory_size:int ->
    bootloader:Bootloader.Linux.t ->
    unit ->
    t
  (** Creates a new virtual machine configuration object with the specified
      configuration options. *)
end
