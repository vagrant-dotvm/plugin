module VagrantPlugins
  module Dotvm
    class ConfigInjecter

      public
      def self.inject(config, vc)
        # General settings
        vc.ssh.forward_x11 = true

        config.machines.each do |machine_cfg|
          vc.vm.define machine_cfg.nick,
                       primary: machine_cfg.primary,
                       autostart: machine_cfg.autostart do |machine|
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

            machine.vm.provider "virtualbox" do |vb|
              vb.customize ["modifyvm", :id, "--memory",          machine_cfg.memory] unless machine_cfg.memory.nil?
              vb.customize ["modifyvm", :id, "--cpus",            machine_cfg.cpus]   unless machine_cfg.cpus.nil?
              vb.customize ["modifyvm", :id, "--cpuexecutioncap", machine_cfg.cpucap] unless machine_cfg.cpucap.nil?
              vb.customize ["modifyvm", :id, "--natnet1",         machine_cfg.natnet] unless machine_cfg.natnet.nil?

              machine_cfg.options[:virtualbox].each do |option|
                vb.customize ["modifyvm", :id, option.name, option.value]
              end
            end

            machine_cfg.networks.each do |net|
              hash = {}
              hash[:type]               = net.type      unless net.type.nil?
              hash[:ip]                 = net.ip        unless net.ip.nil?
              hash[:netmask]            = net.mask      unless net.mask.nil?
              hash[:virtualbox__intnet] = net.interface unless net.interface.nil?
              hash[:guest]              = net.guest     unless net.guest.nil?
              hash[:host]               = net.host      unless net.host.nil?
              hash[:protocol]           = net.protocol  unless net.protocol.nil?
              hash[:bridge]             = net.bridge    unless net.bridge.nil?
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
                p.path              = provision.path              unless provision.path.nil?
                p.inline            = provision.inline            unless provision.inline.nil?
                p.args              = provision.args              unless provision.args.nil?
                p.privileged        = provision.privileged        unless provision.privileged.nil?
                p.source            = provision.source            unless provision.source.nil?
                p.destination       = provision.destination       unless provision.destination.nil?
                p.module_path       = provision.module_path       unless provision.module_path.nil?
                p.manifest_file     = provision.manifest_file     unless provision.manifest_file.nil?
                p.manifests_path    = provision.manifests_path    unless provision.manifests_path.nil?
                p.binary_path       = provision.binary_path       unless provision.binary_path.nil?
                p.hiera_config_path = provision.hiera_config_path unless provision.hiera_config_path.nil?
                p.environment       = provision.environment       unless provision.environment.nil?
                p.environment_path  = provision.environment_path  unless provision.environment_path.nil?
              end
            end

            machine_cfg.shared_folders.each do |folder|
              hash = {}
              hash[:disabled] = folder.disabled unless folder.disabled.nil?
              hash[:create]   = folder.create   unless folder.create.nil?
              hash[:type]     = folder.type     unless folder.type.nil?

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
