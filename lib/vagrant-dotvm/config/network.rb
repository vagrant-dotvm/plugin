module VagrantPlugins
  module Dotvm
    module Config
      class Network < AbstractConfig
        attr_reader :net
        attr_accessor :type
        attr_accessor :ip
        attr_accessor :mask # netmask
        attr_accessor :interface
        attr_accessor :guest
        attr_accessor :host
        attr_accessor :protocol
        attr_accessor :bridge

        def net=(value)
          nets = {
            "private_network" => :private_network,
            "private"         => :private_network,
            "public_network"  => :public_network,
            "public"          => :public_network,
            "forwarded_port"  => :forwarded_port,
            "port"            => :forwarded_port,
          }

          @net = nets[value]
        end

        def netmask=(value)
          @mask = value
        end
      end
    end
  end
end
