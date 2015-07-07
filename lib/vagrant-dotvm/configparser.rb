module VagrantPlugins
  module Dotvm
    class ConfigParser

      DEFAULT_NET     = 'private_network'
      DEFAULT_NETMASK = '255.255.255.0'

      def initialize(vars = {})
        @vars = vars
      end

      
      def replace_vars(value)
        if value
          value = value.dup()
          
          @vars.each do |key, val|
            pattern = '%' + key + '%'
            value.gsub! pattern, val
          end
        end
          
        return value
      end

        
      def parse_machine(machine)
        return {
          :nick	      => machine['nick'],
          :name	      => machine['name'],
          :box        => machine['box'],
          :memory     => machine['memory'],
          :cpus       => machine['cpus'],
          :cpucap     => machine['cpucap'],
          :primary    => machine['primary'] ||= false,
          :networks   => [],
          :provision  => [],
          :folders    => [],
          :groups     => [],
        }
      end

      
      def parse_net(net)
        return {
          :net  => net['net'] || DEFAULT_NET,
          :type => net['type'],
          :ip   => net['ip'],
          :mask => net['mask'] || net['netmask'] || DEFAULT_NETMASK,
        }
      end

      
      def parse_provision(prv)
        return {
          :type		  => prv['type'],
          :source         => self.replace_vars(prv['source']),
          :destination    => prv['destination'],
          :path		  => self.replace_vars(prv['path']),
          :module_path    => self.replace_vars(prv['module_path']),
          :manifests_path => self.replace_vars(prv['manifests_path']),
          :manifest_file  => prv['manifest_file'],
        }
      end


      def parse_folder(folder)
        return {
          :host  => self.replace_vars(folder['host']),
          :guest => folder['guest'],
        }
      end

      
      def parse(yaml)
        config = {
          :machines => []
        }

        yaml['machines'].each do |machine|
          item = parse_machine(machine)

          machine['networks'] and machine['networks'].each do |net|
            item[:networks] << self.parse_net(net)
          end

          machine['provision'] and machine['provision'].each do |prv|
            item[:provision] << self.parse_provision(prv)
          end

          machine['shared_folders'] and machine['shared_folders'].each do |folder|
            item[:folders] << self.parse_folder(folder)
          end

          machine['groups'] and machine['groups'].each do |group|
            item[:groups] << group
          end

          config[:machines] << item
        end

        return config
      end
      
    end
  end
end
