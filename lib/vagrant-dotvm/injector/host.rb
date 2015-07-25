module VagrantPlugins
  module Dotvm
    module Injector
      class Host
        def self.inject(host: nil, machine: nil)
          machine.vm.provision "shell", run: "always" do |s|
            s.path       = File.dirname(__FILE__) + "/../../utils/add_host.sh"
            s.args       = [host.ip, host.host]
            s.privileged = true
          end
        end
      end
    end
  end
end