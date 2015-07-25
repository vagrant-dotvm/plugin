module VagrantPlugins
  module Dotvm
    module Config
      class Run < AbstractConfig
        attr_accessor :name
        attr_accessor :image
        attr_accessor :cmd
        attr_accessor :args
        attr_accessor :auto_assign_name
        attr_accessor :daemonize
        attr_accessor :restart
      end
    end
  end
end
