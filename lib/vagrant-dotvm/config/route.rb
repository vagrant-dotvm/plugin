module VagrantPlugins
  module Dotvm
    module Config
      class Route < AbstractConfig
        attr_accessor :destination
        attr_accessor :gateway
      end
    end
  end
end
