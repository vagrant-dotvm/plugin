module VagrantPlugins
  module Dotvm
    class ConfigInjecter
      
      def self.inject(config, vc)
        config[:machines].each do |machine_cfg|
          vc.vm.define machine_cfg[:nick] do |machine|
            machine.vm.box      = machine_cfg[:box]
            machine.vm.hostname = machine_cfg[:name]

            machine.vm.provider "virtualbox" do |vb|
              vb.customize ['modifyvm', :id, '--memory', machine_cfg['memory'] ||= 1024]
              vb.customize ['modifyvm', :id, '--cpus',   machine_cfg['cpus']   ||= 1]
              vb.customize ['modifyvm', :id, '--cpuexecutioncap', machine_cfg['cpucap'] ||= 100]
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
          end
        end
      end
      
    end # ConfigInjecter
  end # Dotvm
end # VagrantPlugins
