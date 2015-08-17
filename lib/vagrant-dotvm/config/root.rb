module VagrantPlugins
  module Dotvm
    module Config
      class Root < AbstractConfig
        OPTIONS_CATEGORIES = [
          :ssh,
          :winrm,
          :vagrant,
        ]

        include OptionsSetter

        attr_reader :machines
        attr_reader :options # mixin
        attr_reader :vars

        def machines=(machines)
          ensure_type machines, Array, 'machines'
          @machines = convert_array(machines, Machine.name)
        end

        def vars=(vars)
          ensure_type vars, Hash, 'vars'
          @vars = vars
        end
      end
    end
  end
end
