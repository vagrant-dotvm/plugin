module VagrantPlugins
  module Dotvm
    module Injector
      module Machine
        extend AbstractInjector

        BOX_OPTIONS = [
          :box,
          :hostname,
          :boot_timeout,
          :box_check_update,
          :box_version,
          :graceful_halt_timeout,
          :post_up_message,
          :box_download_checksum,
          :box_download_checksum_type,
          :box_download_client_cert,
          :box_download_ca_cert,
          :box_download_ca_path,
          :box_download_insecure,
          :box_download_location_trusted,
          :box_url,
          :communicator,
          :guest,
          :usable_port_range
        ]

        module_function

        def inject(machine_cfg: nil, vc: nil)
          define_opts = {}
          define_opts[:primary]   = machine_cfg.primary   unless machine_cfg.primary.nil?
          define_opts[:autostart] = machine_cfg.autostart unless machine_cfg.autostart.nil?

          vc.vm.define machine_cfg.nick, **define_opts do |machine|
            BOX_OPTIONS.each do |opt|
              val = machine_cfg.send(opt)
              machine.vm.send("#{opt}=", val) unless val.nil?
            end

            machine.vm.provider 'virtualbox' do |vb|
              vb.customize ['modifyvm', :id, '--memory',          machine_cfg.memory] unless machine_cfg.memory.nil?
              vb.customize ['modifyvm', :id, '--cpus',            machine_cfg.cpus]   unless machine_cfg.cpus.nil?
              vb.customize ['modifyvm', :id, '--cpuexecutioncap', machine_cfg.cpucap] unless machine_cfg.cpucap.nil?
              vb.customize ['modifyvm', :id, '--natnet1',         machine_cfg.natnet] unless machine_cfg.natnet.nil?

              machine_cfg.options.to_h[:virtualbox].to_a.each do |option|
                vb.customize ['modifyvm', :id, option.name, option.value]
              end
            end

            machine.vm.provider 'vmware_fusion' do |vf|
              vf.vmx['memsize']  = machine_cfg.memory unless machine_cfg.memory.nil?
              vf.vmx['numvcpus'] = machine_cfg.cpus   unless machine_cfg.cpus.nil?
            end

            machine_cfg.networks.to_a.each do |net|
              Network.inject net: net,
                             machine: machine
            end

            machine_cfg.routes.to_a.each do |route|
              Route.inject route: route,
                           machine: machine
            end

            machine_cfg.hosts.to_a.each do |host|
              Host.inject host: host,
                       machine: machine
            end

            machine_cfg.provision.to_a.each do |provision|
              Provision.inject provision_cfg: provision,
                               machine: machine
            end

            machine_cfg.shared_folders.to_a.each do |folder|
              SharedFolder.inject folder: folder,
                                  machine: machine
            end

            machine_cfg.authorized_keys.to_a.each do |key|
              AuthorizedKey.inject key: key,
                                   machine: machine
            end

            if Vagrant.has_plugin?('vagrant-group')
              vc.group.groups = {} unless vc.group.groups.kind_of?(Hash)

              machine_cfg.groups.to_a.each do |group|
                vc.group.groups[group] = [] unless vc.group.groups.key?(group)
                vc.group.groups[group] << machine_cfg.nick
              end
            end
          end
        end
      end
    end
  end
end
