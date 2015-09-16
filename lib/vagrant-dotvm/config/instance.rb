module VagrantPlugins
  module Dotvm
    module Config
      # Class represents whole instance of DotVm.
      class Instance < AbstractConfig
        include OptionsSetter

        OPTIONS_CATEGORIES = [
          :ssh,
          :winrm,
          :vagrant
        ]

        attr_reader :projects
        attr_reader :options # mixin
        attr_reader :variables

        def initialize
          @projects = []
          @variables = Variables.new
        end

        def new_project
          projects << (project = Project.new self)
          project
        end
      end
    end
  end
end
