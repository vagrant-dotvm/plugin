module VagrantPlugins
  module Dotvm
    module Config
      # Stores host configuration
      class Host < AbstractConfig
        attr_accessor :ip
        attr_accessor :host
      end
    end
  end
end
