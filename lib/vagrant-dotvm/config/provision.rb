module VagrantPlugins
  module Dotvm
    module Config
      class Provision < AbstractConfig
        attr_accessor :type
        attr_accessor :source
        attr_accessor :destination
        attr_accessor :inline
        attr_accessor :path
        attr_accessor :args
        attr_accessor :module_path
        attr_accessor :manifests_path
        attr_accessor :manifest_file
        attr_accessor :privileged
        attr_accessor :run
      end
    end
  end
end
