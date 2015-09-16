module VagrantPlugins
  module Dotvm
    module Injector
      module Host
        extend AbstractInjector

        module_function

        def inject(host: nil, machine: nil)
          machine.vm.provision 'shell', run: 'always' do |s|
            s.path       = "#{UTILS_PATH}/add_host.sh"
            s.args       = [host.ip, host.host]
            s.privileged = true
            s.name       = "host #{host.host} -> #{host.ip}"
          end
        end
      end
    end
  end
end
