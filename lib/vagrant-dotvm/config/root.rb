module VagrantPlugins
  module Dotvm
    module Config
      class Root < AbstractConfig
        attr_reader :machines

        def initialize()
          @machines = []
        end

        def populate_machines(data)
          data.to_a.each do |item|
            machine = Machine.new
            machine.populate item
            @machines << machine
          end
        end
      end
    end
  end
end
