module VagrantPlugins
  module Dotvm
    module Injector
      class Root < AbstractInjector
        def self.inject(config: nil, vc: nil)
          config.options.to_h.each do |category, options|
            options.to_a.each do |option|
              vc.send(category).send("#{option.name}=", option.value)
            end
          end

          config.machines.to_a.each do |machine_cfg|
            Machine.inject machine_cfg: machine_cfg, vc: vc
          end
        end
      end # Root
    end # Injector
  end # Dotvm
end # VagrantPlugins
