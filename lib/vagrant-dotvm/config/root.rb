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
          raise InvalidConfigError.new "'machines' must be array." unless machines.kind_of?(Array) || machines.kind_of?(NilClass)
          @machines = convert_array(machines, Machine.name)
        end

        def vars=(vars)
          raise InvalidConfigError.new "'vars' must be hash." unless vars.kind_of?(Hash) || vars.kind_of?(NilClass)
          @vars = vars
        end
      end
    end
  end
end
