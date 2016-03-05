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
        attr_accessor :minion_config
        attr_accessor :install_master
        attr_accessor :no_minion
        attr_accessor :install_syndic
        attr_accessor :install_type
        attr_accessor :install_args
        attr_accessor :install_command
        attr_accessor :always_install
        attr_accessor :bootstrap_script
        attr_accessor :bootstrap_options
        attr_accessor :version
        attr_accessor :minion_key
        attr_accessor :minion_id
        attr_accessor :minion_pub
        attr_accessor :grains_config
        attr_accessor :masterless
        attr_accessor :master_config
        attr_accessor :master_key
        attr_accessor :master_pub
        attr_accessor :seed_master
        attr_accessor :run_highstate
        attr_accessor :run_overstate
        attr_accessor :orchestrations
        attr_accessor :colorize
        attr_accessor :log_level
        attr_accessor :am_policy_hub
        attr_accessor :extra_agent_args
        attr_accessor :classes
        attr_accessor :deb_repo_file
        attr_accessor :deb_repo_line
        attr_accessor :files_path
        attr_accessor :force_bootstrap
        attr_accessor :install
        attr_accessor :mode
        attr_accessor :policy_server_address
        attr_accessor :repo_gpg_key_url
        attr_accessor :run_file
        attr_accessor :yum_repo_file
        attr_accessor :yum_repo_url
        attr_accessor :package_name
        attr_accessor :groups
        attr_accessor :inventory_path
        attr_accessor :playbook
        attr_accessor :extra_vars
        attr_accessor :sudo
        attr_accessor :sudo_user
        attr_accessor :ask_sudo_pass
        attr_accessor :ask_vault_pass
        attr_accessor :vault_password_file
        attr_accessor :limit
        attr_accessor :verbose
        attr_accessor :tags
        attr_accessor :skip_tags
        attr_accessor :start_at_task
        attr_accessor :raw_arguments
        attr_accessor :raw_ssh_args
        attr_accessor :host_key_checking
        attr_accessor :cookbooks_path
        attr_accessor :data_bags_path
        attr_accessor :environments_path
        attr_accessor :recipe_url
        attr_accessor :roles_path
        attr_accessor :binary_env
        attr_accessor :installer_download_path
        attr_accessor :prerelease
        attr_accessor :arguments
        attr_accessor :attempts
        attr_accessor :custom_config_path
        attr_accessor :encrypted_data_bag_secret_key_path
        attr_accessor :formatter
        attr_accessor :http_proxy
        attr_accessor :http_proxy_user
        attr_accessor :http_proxy_pass
        attr_accessor :no_proxy
        attr_accessor :json
        attr_accessor :node_name
        attr_accessor :provisioning_path
        attr_accessor :run_list
        attr_accessor :file_cache_path
        attr_accessor :file_backup_path
        attr_accessor :verbose_logging
        attr_accessor :enable_reporting
        attr_accessor :client_key_path
        attr_accessor :validation_client_name
        attr_accessor :delete_node
        attr_accessor :delete_client
        attr_accessor :recipe
        attr_accessor :recipes # chef
        attr_accessor :roles # chef
        attr_accessor :pillar
        attr_accessor :force_remote_user # ansible

        attr_accessor :images
        attr_reader :build_images
        attr_reader :runs

        def build_images=(build_images)
          ensure_type build_images, Array, 'build_images'
          @build_images = convert_array(build_images, BuildImage.name)
        end

        def runs=(runs)
          ensure_type runs, Array, 'runs'
          @runs = convert_array(runs, Run.name)
        end
      end
    end
  end
end
