module VagrantPlugins
  module Dotvm
    module Injector
      module Network
        extend AbstractInjector

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

        module_function

        def inject(net: nil, machine: nil)
          machine.vm.network net.net, **generate_hash(net, OPTIONS)
        end
      end
    end
  end
end
