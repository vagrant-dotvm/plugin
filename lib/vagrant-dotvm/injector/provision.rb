module VagrantPlugins
  module Dotvm
    module Injector
      class Provision
        OPTIONS = [
          :path,
          :inline,
          :args,
          :privileged,
          :source,
          :destination,
          :module_path,
          :manifest_file,
          :manifests_path,
          :binary_path,
          :hiera_config_path,
          :environment,
          :environment_path,
          :binary,
          :upload_path,
          :keep_color,
          :name,
          :powershell_args,
          :facter,
          :options,
          :synced_folder_type,
          :temp_dir,
          :working_directory,
          :client_cert_path,
          :client_private_key_path,
          :puppet_node,
          :puppet_server,
          :minion_config,
          :run_highstate,
          :install_master,
          :no_minion,
          :install_syndic,
          :install_type,
          :install_args,
          :install_command,
          :always_install,
          :bootstrap_script,
          :bootstrap_options,
          :version,
          :minion_key,
          :minion_id,
          :minion_pub,
          :grains_config,
          :masterless,
          :master_config,
          :master_key,
          :master_pub,
          :seed_master,
          :run_highstate,
          :run_overstate,
          :orchestrations,
          :colorize,
          :log_level,
          :am_policy_hub,
          :extra_agent_args,
          :classes,
          :deb_repo_file,
          :deb_repo_line,
          :files_path,
          :force_bootstrap,
          :install,
          :mode,
          :policy_server_address,
          :repo_gpg_key_url,
          :run_file,
          :upload_path,
          :yum_repo_file,
          :yum_repo_url,
          :package_name,
          :groups,
          :inventory_path,
          :playbook,
          :extra_vars,
          :sudo,
          :sudo_user,
          :ask_sudo_pass,
          :ask_vault_pass,
          :vault_password_file,
          :limit,
          :verbose,
          :tags,
          :skip_tags,
          :start_at_task,
          :raw_arguments,
          :raw_ssh_args,
          :host_key_checking,
          :cookbooks_path,
          :data_bags_path,
          :environments_path,
          :recipe_url,
          :roles_path,
          :binary_env,
          :installer_download_path,
          :prerelease,
          :arguments,
          :attempts,
          :custom_config_path,
          :encrypted_data_bag_secret_key_path,
          :formatter,
          :http_proxy,
          :http_proxy_user,
          :http_proxy_pass,
          :no_proxy,
          :json,
          :node_name,
          :provisioning_path,
          :run_list,
          :file_cache_path,
          :file_backup_path,
          :verbose_logging,
          :enable_reporting,
          :client_key_path,
          :validation_client_name,
          :delete_node,
          :delete_client,
          :recipe,
        ]

        public
        def self.inject(provision_cfg: nil, machine: nil)
          machine.vm.provision provision_cfg.type, run: provision_cfg.run do |p|
            OPTIONS.each do |opt|
              val = provision_cfg.send(opt)
              p.send("#{opt}=", val) unless val.nil?
            end

            provision_cfg.recipes.to_a.each do |recipe|
              p.add_recipe(recipe)
            end

            provision_cfg.roles.to_a.each do |role|
              p.add_role(role)
            end
          end
        end
      end
    end
  end
end
