module VagrantPlugins
  module DotVm
    class ConfigParser
      ::DEFAULT_MEMORY                = 1024
      ::DEFAULT_CPUS                  = 1
      ::DEFAULT_CPUCAP                = 100
      ::DEFAULT_NATNET                = "192.168.88.0/24"
      ::DEFAULT_NET                   = :private_network
      ::DEFAULT_NET_TYPE              = "static"
      ::DEFAULT_NETMASK               = "255.255.255.0"
      ::DEFAULT_PROTOCOL              = "tcp"
      ::DEFAULT_BOOT_TIMEOUT          = 300
      ::DEFAULT_BOX_CHECK_UPDATE      = true
      ::DEFAULT_BOX_VERSION           = ">= 0"
      ::DEFAULT_GRACEFUL_HALT_TIMEOUT = 60
    end # ConfigParser
  end # DotVm
end # VagrantPlugins
