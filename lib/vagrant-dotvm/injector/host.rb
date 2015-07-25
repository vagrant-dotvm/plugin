module VagrantPlugins
  module Dotvm
    module Injector
      class Host < AbstractInjector
        def self.inject(host: nil, machine: nil)
          machine.vm.provision "shell", run: "always" do |s|
            s.path       = "#{UTILS_PATH}/add_host.sh"
            s.args       = [host.ip, host.host]
            s.privileged = true
          end
        end
      end
    end
  end
end
