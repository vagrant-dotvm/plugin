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
          ensure_array machines, 'machines'
          @machines = convert_array(machines, Machine.name)
        end

        def vars=(vars)
          ensure_hash vars 'vars'
          @vars = vars
        end
      end
    end
  end
end
