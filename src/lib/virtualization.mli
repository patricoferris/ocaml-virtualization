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
  end
  val create : unit -> t
end

module Config : sig 
  type t

  val create : cpus:int -> memory_size:int -> t
  (** Creates a new virtual machine configuration object with the specified
      configuration options. *) 
end
