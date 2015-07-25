module VagrantPlugins
  module Dotvm
    module Config
      class BuildImage < AbstractConfig
        attr_accessor :image
        attr_accessor :args
      end
    end
  end
end
