module VagrantPlugins
  module Dotvm
    module Injector
      class AuthorizedKey < AbstractInjector
        def self.inject(key: nil, machine: nil)
          if key.type == "file"
            pubkey = File.readlines(File.expand_path(key.path)).first.strip
          elsif key.type == "static"
            pubkey = key.key
          end

          machine.vm.provision "shell" do |s|
            s.path       = "#{UTILS_PATH}/authorize_key.sh"
            s.args       = [pubkey]
            s.privileged = false
          end
        end
      end
    end
  end
end
