module VagrantPlugins
  module Dotvm
    module Injector
      class Project < AbstractInjector
        def self.inject(project, vc)
          project.machines.to_a.each do |machine_cfg|
            Machine.inject machine_cfg: machine_cfg, vc: vc
          end
        end
      end
    end
  end
end
