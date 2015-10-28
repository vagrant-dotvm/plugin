module VagrantPlugins
  module Dotvm
    module Config
      # Exception signaling error in configuration
      class InvalidConfigError < ArgumentError
        attr_accessor :file
      end
    end
  end
end
