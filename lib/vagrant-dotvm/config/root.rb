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
          raise "'machines' must be array." unless machines.kind_of?(Array) || machines.kind_of?(NilClass)

          @machines = []
          machines.to_a.each do |item|
            machine = Machine.new
            machine.populate item
            @machines << machine
          end
        end

        def vars=(vars)
          raise "'vars' must be hash." unless vars.kind_of?(Hash) || vars.kind_of?(NilClass)
          @vars = vars
        end
      end
    end
  end
end
