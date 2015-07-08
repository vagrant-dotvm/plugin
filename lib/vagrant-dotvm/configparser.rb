module VagrantPlugins
  module Dotvm
    class ConfigParser

      DEFAULT_NET     = 'private_network'
      DEFAULT_NETMASK = '255.255.255.0'

      def initialize(vars = {})
        @vars = vars
      end


      def replace_vars(value)
        if value.kind_of?(Hash)
          result = {}
          value.each do |key, val|
            result[key] = self.replace_vars(val)
          end
        elsif value.kind_of?(Array)
          result = value.map do |val|
            self.replace_vars(val)
          end
        elsif value.kind_of?(String)
          result = value.dup

          @vars.each do |k, v|
            pattern = '%' + k + '%'
            result.gsub! pattern, v
          end
        elsif !value.respond_to?(:duplicable) or !value.duplicable?
          result = value
        else
          result = value.dup
        end

        return result
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
          :natnet     => machine['natnet'],
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
          :source         => prv['source'],
          :destination    => prv['destination'],
          :path		  => prv['path'],
          :module_path    => prv['module_path'],
          :manifests_path => prv['manifests_path'],
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

        return self.replace_vars(config)
      end
      
    end
  end
end
