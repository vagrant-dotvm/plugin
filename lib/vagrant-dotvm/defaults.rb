module VagrantPlugins
  module Dotvm
    class Defaults
      NET                   = :private_network
      NET_TYPE              = "static"
      NETMASK               = "255.255.255.0"
      PROTOCOL              = "tcp"
      BOOT_TIMEOUT          = 300
      BOX_CHECK_UPDATE      = true
      BOX_VERSION           = ">= 0"
      GRACEFUL_HALT_TIMEOUT = 60
    end # Defaults
  end # Dotvm
end # VagrantPlugins
