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
            machine.vm.box                           = machine_cfg.box                           unless machine_cfg.box.nil?
            machine.vm.hostname                      = machine_cfg.name                          unless machine_cfg.name.nil?
            machine.vm.boot_timeout                  = machine_cfg.boot_timeout                  unless machine_cfg.boot_timeout.nil?
            machine.vm.box_check_update              = machine_cfg.box_check_update              unless machine_cfg.box_check_update.nil?
            machine.vm.box_version                   = machine_cfg.box_version                   unless machine_cfg.box_version.nil?
            machine.vm.graceful_halt_timeout         = machine_cfg.graceful_halt_timeout         unless machine_cfg.graceful_halt_timeout.nil?
            machine.vm.post_up_message               = machine_cfg.post_up_message               unless machine_cfg.post_up_message.nil?
            machine.vm.box_download_checksum         = machine_cfg.box_download_checksum         unless machine_cfg.box_download_checksum.nil?
            machine.vm.box_download_checksum_type    = machine_cfg.box_download_checksum_type    unless machine_cfg.box_download_checksum_type.nil?
            machine.vm.box_download_client_cert      = machine_cfg.box_download_client_cert      unless machine_cfg.box_download_client_cert.nil?
            machine.vm.box_download_ca_cert          = machine_cfg.box_download_ca_cert          unless machine_cfg.box_download_ca_cert.nil?
            machine.vm.box_download_ca_path          = machine_cfg.box_download_ca_path          unless machine_cfg.box_download_ca_path.nil?
            machine.vm.box_download_insecure         = machine_cfg.box_download_insecure         unless machine_cfg.box_download_insecure.nil?
            machine.vm.box_download_location_trusted = machine_cfg.box_download_location_trusted unless machine_cfg.box_download_location_trusted.nil?
            machine.vm.box_url                       = machine_cfg.box_url                       unless machine_cfg.box_url.nil?
            machine.vm.communicator                  = machine_cfg.communicator                  unless machine_cfg.communicator.nil?
            machine.vm.guest                         = machine_cfg.guest                         unless machine_cfg.guest.nil?
            machine.vm.usable_port_range             = machine_cfg.usable_port_range             unless machine_cfg.usable_port_range.nil?

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
              hash[:type]               = net.type         unless net.type.nil?
              hash[:ip]                 = net.ip           unless net.ip.nil?
              hash[:netmask]            = net.mask         unless net.mask.nil?
              hash[:virtualbox__intnet] = net.interface    unless net.interface.nil?
              hash[:guest]              = net.guest        unless net.guest.nil?
              hash[:host]               = net.host         unless net.host.nil?
              hash[:protocol]           = net.protocol     unless net.protocol.nil?
              hash[:bridge]             = net.bridge       unless net.bridge.nil?
              hash[:guest_ip]           = net.guest_ip     unless net.guest_ip.nil?
              hash[:host_ip]            = net.host_ip      unless net.host_ip.nil?
              hash[:auto_correct]       = net.auto_correct unless net.auto_correct.nil?
              hash[:auto_config]        = net.auto_config  unless net.auto_config.nil?

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
                p.path                    = provision.path                    unless provision.path.nil?
                p.inline                  = provision.inline                  unless provision.inline.nil?
                p.args                    = provision.args                    unless provision.args.nil?
                p.privileged              = provision.privileged              unless provision.privileged.nil?
                p.source                  = provision.source                  unless provision.source.nil?
                p.destination             = provision.destination             unless provision.destination.nil?
                p.module_path             = provision.module_path             unless provision.module_path.nil?
                p.manifest_file           = provision.manifest_file           unless provision.manifest_file.nil?
                p.manifests_path          = provision.manifests_path          unless provision.manifests_path.nil?
                p.binary_path             = provision.binary_path             unless provision.binary_path.nil?
                p.hiera_config_path       = provision.hiera_config_path       unless provision.hiera_config_path.nil?
                p.environment             = provision.environment             unless provision.environment.nil?
                p.environment_path        = provision.environment_path        unless provision.environment_path.nil?
                p.binary                  = provision.binary                  unless provision.binary.nil?
                p.upload_path             = provision.upload_path             unless provision.upload_path.nil?
                p.keep_color              = provision.keep_color              unless provision.keep_color.nil?
                p.name                    = provision.name                    unless provision.name.nil?
                p.powershell_args         = provision.powershell_args         unless provision.powershell_args.nil?
                p.facter                  = provision.facter                  unless provision.facter.nil?
                p.options                 = provision.options                 unless provision.options.nil?
                p.synced_folder_type      = provision.synced_folder_type      unless provision.synced_folder_type.nil?
                p.temp_dir                = provision.temp_dir                unless provision.temp_dir.nil?
                p.working_directory       = provision.working_directory       unless provision.working_directory.nil?
                p.client_cert_path        = provision.client_cert_path        unless provision.client_cert_path.nil?
                p.client_private_key_path = provision.client_private_key_path unless provision.client_private_key_path.nil?
                p.puppet_node             = provision.puppet_node             unless provision.puppet_node.nil?
                p.puppet_server           = provision.puppet_server           unless provision.puppet_server.nil?
              end
            end

            machine_cfg.shared_folders.each do |folder|
              hash = {}
              hash[:disabled]          = folder.disabled          unless folder.disabled.nil?
              hash[:create]            = folder.create            unless folder.create.nil?
              hash[:type]              = folder.type              unless folder.type.nil?
              hash[:group]             = folder.group             unless folder.group.nil?
              hash[:mount_options]     = folder.mount_options     unless folder.mount_options.nil?
              hash[:owner]             = folder.owner             unless folder.owner.nil?
              hash[:nfs_export]        = folder.nfs_export        unless folder.nfs_export.nil?
              hash[:nfs_udp]           = folder.nfs_udp           unless folder.nfs_udp.nil?
              hash[:nfs_version]       = folder.nfs_version       unless folder.nfs_version.nil?
              hash[:rsync__args]       = folder.rsync__args       unless folder.rsync__args.nil?
              hash[:rsync__auto]       = folder.rsync__auto       unless folder.rsync__auto.nil?
              hash[:rsync__chown]      = folder.rsync__chown      unless folder.rsync__chown.nil?
              hash[:rsync__exclude]    = folder.rsync__exclude    unless folder.rsync__exclude.nil?
              hash[:rsync__rsync_path] = folder.rsync__rsync_path unless folder.rsync__rsync_path.nil?
              hash[:rsync__verbose]    = folder.rsync__verbose    unless folder.rsync__verbose.nil?
              hash[:smb_host]          = folder.smb_host          unless folder.smb_host.nil?
              hash[:smb_password]      = folder.smb_password      unless folder.smb_password.nil?
              hash[:smb_username]      = folder.smb_username      unless folder.smb_username.nil?

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
