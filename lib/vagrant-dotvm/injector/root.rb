module VagrantPlugins
  module Dotvm
    module Injector
      class Root
        def self.inject(config: nil, vc: nil)
          config.options[:ssh].each do |option|
            vc.ssh.send("#{option.name}=", option.value)
          end

          config.options[:winrm].each do |option|
            vc.winrm.send("#{option.name}=", option.value)
          end

          config.options[:vagrant].each do |option|
            vc.vagrant.send("#{option.name}=", option.value)
          end

          config.machines.each do |machine_cfg|
            Machine.inject machine_cfg: machine_cfg, vc: vc
          end
        end
      end # Root
    end # Injector
  end # Dotvm
end # VagrantPlugins
