module VagrantPlugins
  module Dotvm
    class ConfigInjecter

      public
      def self.inject(config, vc)
        # General settings
        vc.ssh.forward_x11 = true

        config[:machines].each do |machine_cfg|
          vc.vm.define machine_cfg[:nick],
                       primary: machine_cfg[:primary],
                       autostart: machine_cfg[:autostart] do |machine|
            machine.vm.box                   = machine_cfg[:box]
            machine.vm.hostname              = machine_cfg[:name]
            machine.vm.boot_timeout          = machine_cfg[:boot_timeout]
            machine.vm.box_check_update      = machine_cfg[:box_check_update]
            machine.vm.box_version           = machine_cfg[:box_version]
            machine.vm.graceful_halt_timeout = machine_cfg[:graceful_halt_timeout]
            machine.vm.post_up_message       = machine_cfg[:post_up_message]

            machine.vm.provider "virtualbox" do |vb|
              vb.customize ["modifyvm", :id, "--memory", machine_cfg[:memory]] unless machine_cfg[:memory].nil?
              vb.customize ["modifyvm", :id, "--cpus",   machine_cfg[:cpus]] unless machine_cfg[:cpus].nil?
              vb.customize ["modifyvm", :id, "--cpuexecutioncap", machine_cfg[:cpucap]] unless machine_cfg[:cpucap].nil?
              vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
              vb.customize ["modifyvm", :id, "--natnet1", machine_cfg[:natnet]] unless machine_cfg[:natnet].nil?

              machine_cfg[:options][:virtualbox].each do |option|
                vb.customize ["modifyvm", :id, option[:name], option[:value]]
              end
            end

            machine_cfg[:networks].each do |net|
              if net[:net] == :private_network
                machine.vm.network net[:net],
                                   type: net[:type],
                                   ip: net[:ip],
                                   netmask: net[:mask],
                                   virtualbox__intnet: net[:interface]
              elsif net[:net] == :public_network
                machine.vm.network net[:net],
                                   type: net[:type],
                                   ip: net[:ip],
                                   netmask: net[:mask],
                                   bridge: net[:bridge]
              elsif net[:net] == :forwarded_port
                machine.vm.network net[:net],
                                   guest: net[:guest],
                                   host: net[:host],
                                   protocol: net[:protocol]
              end
            end

            machine_cfg[:routes].each do |route|
              machine.vm.provision "shell", run: "always" do |s|
                s.path       = File.dirname(__FILE__) + "/../../utils/setup_route.sh"
                s.args       = [route[:destination], route[:gateway]]
                s.privileged = true
              end
            end

            machine_cfg[:provision].each do |provision|
              machine.vm.provision provision[:type], run: provision[:run] do |p|
                if provision[:type] == "shell"
                  p.path           = provision[:path]
                  p.args           = provision[:args]
                  p.privileged     = provision[:privileged]
                elsif provision[:type] == "file"
                  p.source         = provision[:source]
                  p.destination    = provision[:destination]
                elsif provision[:type] == "puppet"
                  p.module_path    = provision[:module_path]
                  p.manifest_file  = provision[:manifest_file]
                  p.manifests_path = provision[:manifests_path]
                end
              end
            end

            machine_cfg[:folders].each do |folder|
              machine.vm.synced_folder folder[:host],
                                       folder[:guest],
                                       disabled: folder[:disabled],
                                       create: folder[:create],
                                       type: folder[:type]
            end

            machine_cfg[:authorized_keys].each do |key|
              if key[:type] == "file"
                pubkey = File.readlines(File.expand_path(key[:path])).first.strip
              elsif key[:type] == "static"
                pubkey = key[:key]
              end

              machine.vm.provision "shell" do |s|
                s.path       = File.dirname(__FILE__) + "/../../utils/authorize_key.sh"
                s.args       = [pubkey]
                s.privileged = false
              end
            end

            if Vagrant.has_plugin?("vagrant-group")
              vc.group.groups = {} unless vc.group.groups.kind_of?(Hash)

              machine_cfg[:groups].each do |group|
                vc.group.groups[group] = [] unless vc.group.groups.has_key?(group)
                vc.group.groups[group] << machine_cfg[:nick]
              end
            end
          end
        end
      end

    end # ConfigInjecter
  end # Dotvm
end # VagrantPlugins
