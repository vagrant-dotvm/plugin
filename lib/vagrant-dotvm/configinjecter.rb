module VagrantPlugins
  module Dotvm
    class ConfigInjecter

      def self.inject(config, vc)
        # General settings
        vc.ssh.forward_x11 = true

        config[:machines].each do |machine_cfg|
          vc.vm.define machine_cfg[:nick], primary: machine_cfg[:primary] do |machine|
            machine.vm.box      = machine_cfg[:box]
            machine.vm.hostname = machine_cfg[:name]

            machine.vm.provider "virtualbox" do |vb|
              vb.customize ['modifyvm', :id, '--memory', machine_cfg['memory'] ||= 1024]
              vb.customize ['modifyvm', :id, '--cpus',   machine_cfg['cpus']   ||= 1]
              vb.customize ['modifyvm', :id, '--cpuexecutioncap', machine_cfg['cpucap'] ||= 100]
              vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
              vb.customize ['modifyvm', :id, '--natnet1', machine_cfg['natnet'] ||= '192.168.88.0/24']
            end

            machine_cfg[:networks].each do |net|
              if net[:net] == 'private_network'
                machine.vm.network net[:net], type: net[:type] ||= 'static', ip: net[:ip], netmask: net[:mask]
              end
            end

            machine_cfg[:provision].each do |provision|
              machine.vm.provision provision[:type] do |p|
                if provision[:type] == 'shell'
                  p.path           = provision[:path]
                  p.args           = provision[:args]
                  p.privileged     = provision[:privileged] ||= true
                elsif provision[:type] == 'file'
                  p.source         = provision[:source]
                  p.destination    = provision[:destination]
                elsif provision[:type] == 'puppet'
                  p.module_path    = provision[:module_path]
                  p.manifest_file  = provision[:manifest_file]
                  p.manifests_path = provision[:manifests_path]
                end
              end
            end

            machine_cfg[:folders].each do |folder|
              machine.vm.synced_folder folder[:host], folder[:guest]
            end

            if Vagrant.has_plugin?('vagrant-group')
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
