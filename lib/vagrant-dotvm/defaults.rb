module VagrantPlugins
  module Dotvm
    class Defaults
      MEMORY                = 1024
      CPUS                  = 1
      CPUCAP                = 100
      NATNET                = "192.168.88.0/24"
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
