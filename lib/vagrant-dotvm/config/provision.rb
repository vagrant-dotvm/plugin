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
        attr_accessor :binary_path
        attr_accessor :hiera_config_path
        attr_accessor :environment
        attr_accessor :environment_path
        attr_accessor :binary
        attr_accessor :upload_path
        attr_accessor :keep_color
        attr_accessor :name
        attr_accessor :powershell_args
        attr_accessor :facter
        attr_accessor :options
        attr_accessor :synced_folder_type
        attr_accessor :synced_folder_args
        attr_accessor :temp_dir
        attr_accessor :working_directory
        attr_accessor :client_cert_path
        attr_accessor :client_private_key_path
        attr_accessor :puppet_node
        attr_accessor :puppet_server
      end
    end
  end
end
