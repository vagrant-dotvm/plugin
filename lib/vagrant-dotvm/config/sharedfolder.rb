module VagrantPlugins
  module Dotvm
    module Config
      class SharedFolder < AbstractConfig
        attr_accessor :host
        attr_accessor :guest
        attr_accessor :disabled
        attr_accessor :create
        attr_accessor :type
      end
    end
  end
end
