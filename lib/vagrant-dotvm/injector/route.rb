module VagrantPlugins
  module Dotvm
    module Injector
      class Route < AbstractInjector
        def self.inject(route: nil, machine: nil)
          machine.vm.provision "shell", run: "always" do |s|
            s.path       = "#{UTILS_PATH}/setup_route.sh"
            s.args       = [route.destination, route.gateway]
            s.privileged = true
          end
        end
      end
    end
  end
end
