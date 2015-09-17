module VagrantPlugins
  module Dotvm
    module Config
      # Stores network configuration
      class Network < AbstractConfig
        attr_reader :net
        attr_accessor :type
        attr_accessor :ip
        attr_accessor :netmask # mask
        attr_accessor :virtualbox__intnet # interface
        attr_accessor :guest
        attr_accessor :host
        attr_accessor :protocol
        attr_accessor :bridge
        attr_accessor :guest_ip
        attr_accessor :host_ip
        attr_accessor :auto_correct
        attr_accessor :auto_config

        def initialize
          @net = :private_network
        end

        def net=(value)
          nets = {
            'private_network' => :private_network,
            'private'         => :private_network,
            'public_network'  => :public_network,
            'public'          => :public_network,
            'forwarded_port'  => :forwarded_port,
            'port'            => :forwarded_port
          }

          @net = nets[value]
        end

        def mask=(value)
          @netmask = value
        end

        def interface=(value)
          @virtualbox__intnet = value
        end
      end
    end
  end
end
