module VagrantPlugins
  module Dotvm
    module Config
      # Class represents one project
      class Project < AbstractConfig
        attr_reader :parent
        attr_reader :variables
        attr_reader :machines

        def initialize(parent)
          @parent = parent
          @variables = Variables.new
          @machines = []
        end

        def new_machine
          machines << (machine = Machine.new self)
          machine
        end
      end
    end
  end
end
