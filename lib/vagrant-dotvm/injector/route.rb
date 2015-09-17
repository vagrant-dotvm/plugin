module VagrantPlugins
  module Dotvm
    module Injector
      # Injects DotVm route configuration into Vagrant
      module Route
        extend AbstractInjector

        module_function

        def inject(route: nil, machine: nil)
          machine.vm.provision 'shell', run: 'always' do |s|
            s.path       = "#{UTILS_PATH}/setup_route.sh"
            s.args       = [route.destination, route.gateway]
            s.privileged = true
            s.name       = "route to #{route.destination} via #{route.gateway}"
          end
        end
      end
    end
  end
end
