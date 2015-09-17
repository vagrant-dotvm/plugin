module VagrantPlugins
  module Dotvm
    module Config
      # Stores route configuration
      class Route < AbstractConfig
        attr_accessor :destination
        attr_accessor :gateway
      end
    end
  end
end
