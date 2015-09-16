module VagrantPlugins
  module Dotvm
    module Injector
      module Instance
        extend AbstractInjector

        module_function

        def inject(instance, vc)
          instance.options.to_h.each do |category, options|
            options.to_a.each do |option|
              vc.send(category).send("#{option.name}=", option.value)
            end
          end

          instance.projects.each do |project|
            Injector::Project.inject project, vc
          end
        end
      end
    end
  end
end
