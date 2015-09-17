module VagrantPlugins
  module Dotvm
    module Config
      # Stores one option
      class Option < AbstractConfig
        attr_accessor :name
        attr_accessor :value
      end
    end
  end
end
