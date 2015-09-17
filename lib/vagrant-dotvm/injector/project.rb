module VagrantPlugins
  module Dotvm
    module Injector
      # Injects DotVm project configuration into Vagrant
      module Project
        extend AbstractInjector

        module_function

        def inject(project, vc)
          project.machines.to_a.each do |machine_cfg|
            Machine.inject machine_cfg: machine_cfg, vc: vc
          end
        end
      end
    end
  end
end
