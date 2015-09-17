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

        def inject_options(machine_cfg, machine)
          BOX_OPTIONS.each do |opt|
            val = machine_cfg.send(opt)
            machine.vm.send("#{opt}=", val) unless val.nil?
          end
        end

        def inject_vbox(machine_cfg, machine)
          mapping = [
            ['--memory', :memory],
            ['--cpus', :cpus],
            ['--cpuexecutioncap', :cpucap],
            ['--natnet1', :natnet]
          ]

          machine.vm.provider 'virtualbox' do |vb|
            mapping.each do |item|
              value = machine_cfg.send(item[1])
              vb.customize ['modifyvm', :id, item[0], value] unless value.nil?
            end

            machine_cfg.options.to_h[:virtualbox].to_a.each do |option|
              vb.customize ['modifyvm', :id, option.name, option.value]
            end
          end
        end

        def inject_vmware(machine_cfg, machine)
          machine.vm.provider 'vmware_fusion' do |vf|
            vf.vmx['memsize']  = machine_cfg.memory unless machine_cfg.memory.nil?
            vf.vmx['numvcpus'] = machine_cfg.cpus   unless machine_cfg.cpus.nil?
          end
        end

        def inject_groups(machine_cfg, vc)
          return false unless Vagrant.has_plugin?('vagrant-group')

          vc.group.groups = {} unless vc.group.groups.kind_of?(Hash)

          machine_cfg.groups.to_a.each do |group|
            vc.group.groups[group] = [] unless vc.group.groups.key?(group)
            vc.group.groups[group] << machine_cfg.nick
          end
        end

        def inject(machine_cfg: nil, vc: nil)
          define_opts = {}
          define_opts[:primary]   = machine_cfg.primary   unless machine_cfg.primary.nil?
          define_opts[:autostart] = machine_cfg.autostart unless machine_cfg.autostart.nil?

          vc.vm.define machine_cfg.nick, **define_opts do |machine|
            inject_options machine_cfg, machine
            inject_vbox machine_cfg, machine
            inject_vmware machine_cfg, vc

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
          end
        end
      end
    end
  end
end
