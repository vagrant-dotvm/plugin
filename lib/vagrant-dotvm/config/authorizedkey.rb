module VagrantPlugins
  module Dotvm
    module Config
      class AuthorizedKey < AbstractConfig
        attr_accessor :type
        attr_accessor :path
        attr_accessor :key
      end
    end
  end
end
