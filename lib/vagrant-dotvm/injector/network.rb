module VagrantPlugins
  module Dotvm
    module Injector
      class Network
        OPTIONS = [
          :type,
          :ip,
          :netmask,
          :virtualbox__intnet,
          :guest,
          :host,
          :protocol,
          :bridge,
          :guest_ip,
          :host_ip,
          :auto_correct,
          :auto_config,
        ]

        def self.inject(net: nil, machine: nil)
          hash = {}

          OPTIONS.each do |opt|
            val = net.send(opt)
            hash[opt] = val unless val.nil?
          end

          machine.vm.network net.net, **hash
        end
      end
    end
  end
end
