module VagrantPlugins
  module Dotvm
    class ConfigParser

      DEFAULT_NET     = 'private_network'
      DEFAULT_NETMASK = '255.255.255.0'

      def initialize(vars = {})
        @vars = vars
      end

      
      def replace_vars(value)
        if value && value.kind_of?(String)
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
          :nick	      => self.replace_vars(machine['nick']),
          :name	      => self.replace_vars(machine['name']),
          :box        => self.replace_vars(machine['box']),
          :memory     => self.replace_vars(machine['memory']),
          :cpus       => self.replace_vars(machine['cpus']),
          :cpucap     => self.replace_vars(machine['cpucap']),
          :primary    => self.replace_vars(machine['primary'] ||= false),
          :natnet     => self.replace_vars(machine['natnet']),
          :networks   => [],
          :provision  => [],
          :folders    => [],
          :groups     => [],
        }
      end

      
      def parse_net(net)
        return {
          :net  => self.replace_vars(net['net'] || DEFAULT_NET),
          :type => self.replace_vars(net['type']),
          :ip   => self.replace_vars(net['ip']),
          :mask => self.replace_vars(net['mask'] || net['netmask'] || DEFAULT_NETMASK),
        }
      end

      
      def parse_provision(prv)
        return {
          :type		  => self.replace_vars(prv['type']),
          :source         => self.replace_vars(prv['source']),
          :destination    => self.replace_vars(prv['destination']),
          :path		  => self.replace_vars(prv['path']),
          :module_path    => self.replace_vars(prv['module_path']),
          :manifests_path => self.replace_vars(prv['manifests_path']),
          :manifest_file  => self.replace_vars(prv['manifest_file']),
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
