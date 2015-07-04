module VagrantPlugins
  module Dotvm
    class ConfigParser

      def self.parse_machine(machine)
        return {
          :nick	      => machine['nick'],
          :name	      => machine['name'],
          :box        => machine['box'],
          :memory     => machine['memory'],
          :cpus       => machine['cpus'],
          :cpucap     => machine['cpucap'],
          :networks   => [],
          :provision  => [],
        }
      end

      
      def self.parse_net(net)
        return {
          :net  => net['net'],
          :type => net['type'],
          :ip   => net['ip'],
          :mask => net['mask'],
        }
      end

      
      def self.parse_provision(prv)
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

      
      def self.parse(yaml)
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

          config[:machines] << item
        end

        return config
      end
      
    end
  end
end
