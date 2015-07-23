module VagrantPlugins
  module Dotvm
    class ConfigInjecter

      public
      def self.inject(config, vc)
        config.options[:ssh].each do |option|
          vc.ssh.send("#{option.name}=", option.value)
        end

        config.options[:winrm].each do |option|
          vc.winrm.send("#{option.name}=", option.value)
        end

        config.options[:vagrant].each do |option|
          vc.vagrant.send("#{option.name}=", option.value)
        end

        config.machines.each do |machine_cfg|
          define_opts = {}
          define_opts[:primary]   = machine_cfg.primary   unless machine_cfg.primary.nil?
          define_opts[:autostart] = machine_cfg.autostart unless machine_cfg.autostart.nil?

          vc.vm.define machine_cfg.nick, **define_opts do |machine|
            [
              :box, :hostname, :boot_timeout, :box_check_update, :box_version, :graceful_halt_timeout, :post_up_message,
              :box_download_checksum, :box_download_checksum_type, :box_download_client_cert, :box_download_ca_cert,
              :box_download_ca_path, :box_download_insecure, :box_download_location_trusted, :box_url, :communicator,
              :guest, :usable_port_range
            ].each do |opt|
              val = machine_cfg.send(opt)
              machine.vm.send("#{opt}=", val) unless val.nil?
            end

            machine.vm.provider "virtualbox" do |vb|
              vb.customize ["modifyvm", :id, "--memory",          machine_cfg.memory] unless machine_cfg.memory.nil?
              vb.customize ["modifyvm", :id, "--cpus",            machine_cfg.cpus]   unless machine_cfg.cpus.nil?
              vb.customize ["modifyvm", :id, "--cpuexecutioncap", machine_cfg.cpucap] unless machine_cfg.cpucap.nil?
              vb.customize ["modifyvm", :id, "--natnet1",         machine_cfg.natnet] unless machine_cfg.natnet.nil?

              machine_cfg.options[:virtualbox].each do |option|
                vb.customize ["modifyvm", :id, option.name, option.value]
              end
            end

            machine.vm.provider "vmware_fusion" do |vf|
              vf.vmx["memsize"]  = machine_cfg.memory unless machine_cfg.memory.nil?
              vf.vmz["numvcpus"] = machine_cfg.cpus   unless machine_cfg.cpus.nil?
            end

            machine_cfg.networks.each do |net|
              hash = {}

              [
                :type, :ip, :netmask, :virtualbox__intnet, :guest, :host, :protocol, :bridge,
                :guest_ip, :host_ip, :auto_correct, :auto_config,
              ].each do |opt|
                val = net.send(opt)
                hash[opt] = val unless val.nil?
              end

              machine.vm.network net.net, **hash
            end

            machine_cfg.routes.each do |route|
              machine.vm.provision "shell", run: "always" do |s|
                s.path       = File.dirname(__FILE__) + "/../../utils/setup_route.sh"
                s.args       = [route.destination, route.gateway]
                s.privileged = true
              end
            end

            machine_cfg.hosts.each do |host|
              machine.vm.provision "shell", run: "always" do |s|
                s.path       = File.dirname(__FILE__) + "/../../utils/add_host.sh"
                s.args       = [host.ip, host.host]
                s.privileged = true
              end
            end

            machine_cfg.provision.each do |provision|
              machine.vm.provision provision.type, run: provision.run do |p|
                [
                  :path, :inline, :args, :privileged, :source, :destination, :module_path, :manifest_file,
                  :manifests_path, :binary_path, :hiera_config_path, :environment, :environment_path,
                  :binary, :upload_path, :keep_color, :name, :powershell_args, :facter, :options,
                  :synced_folder_type, :temp_dir, :working_directory, :client_cert_path, :client_private_key_path,
                  :puppet_node, :puppet_server, :minion_config, :run_highstate, :install_master, :no_minion,
                  :install_syndic, :install_type, :install_args, :install_command, :always_install, :bootstrap_script,
                  :bootstrap_options, :version, :minion_key, :minion_id, :minion_pub, :grains_config, :masterless,
                  :master_config, :master_key, :master_pub, :seed_master, :run_highstate, :run_overstate,
                  :orchestrations, :colorize, :log_level, :am_policy_hub, :extra_agent_args, :classes,
                  :deb_repo_file, :deb_repo_line, :files_path, :force_bootstrap, :install, :mode,
                  :policy_server_address, :repo_gpg_key_url, :run_file, :upload_path, :yum_repo_file,
                  :yum_repo_url, :package_name,
                ].each do |opt|
                  val = provision.send(opt)
                  p.send("#{opt}=", val) unless val.nil?
                end
              end
            end

            machine_cfg.shared_folders.each do |folder|
              hash = {}

              [
                :disabled, :create, :type, :group, :mount_options, :owner, :nfs_export, :nfs_udp, :nfs_version,
                :rsync__args, :rsync__auto, :rsync__chown, :rsync__exclude, :rsync__rsync_path, :rsync__verbose,
                :smb_host, :smb_password, :smb_username
              ].each do |opt|
                val = folder.send(opt)
                hash[opt] = val unless val.nil?
              end

              machine.vm.synced_folder folder.host, folder.guest, **hash
            end

            machine_cfg.authorized_keys.each do |key|
              if key.type == "file"
                pubkey = File.readlines(File.expand_path(key.path)).first.strip
              elsif key.type == "static"
                pubkey = key.key
              end

              machine.vm.provision "shell" do |s|
                s.path       = File.dirname(__FILE__) + "/../../utils/authorize_key.sh"
                s.args       = [pubkey]
                s.privileged = false
              end
            end

            if Vagrant.has_plugin?("vagrant-group")
              vc.group.groups = {} unless vc.group.groups.kind_of?(Hash)

              machine_cfg.groups.each do |group|
                vc.group.groups[group] = [] unless vc.group.groups.has_key?(group)
                vc.group.groups[group] << machine_cfg.nick
              end
            end
          end
        end
      end

    end # ConfigInjecter
  end # Dotvm
end # VagrantPlugins
