module VagrantPlugins
  module Dotvm
    class ConfigParser

      DEFAULT_NET     = 'private_network'
      DEFAULT_NET_TYPE = 'static'
      DEFAULT_NETMASK = '255.255.255.0'
      DEFAULT_PROTOCOL = 'tcp'
      DEFAULT_BOOT_TIMEOUT = 300
      DEFAULT_BOX_CHECK_UPDATE = true
      DEFAULT_BOX_VERSION = '>= 0'
      DEFAULT_GRACEFUL_HALT_TIMEOUT = 60

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
          :primary    => self.coalesce(machine['primary'], false),
          :natnet     => machine['natnet'],
          :networks   => [],
          :provision  => [],
          :folders    => [
            {
              :host => '%project.host%',
              :guest => '%project.guest%',
              :disabled => false,
              :create => false,
              :type => nil,
            }
          ],
          :groups     => [],
          :authorized_keys => [],
          :boot_timeout => self.coalesce(machine['boot_timeout'], DEFAULT_BOOT_TIMEOUT),
          :box_check_update => self.coalesce(machine['box_check_update'], DEFAULT_BOX_CHECK_UPDATE),
          :box_version => self.coalesce(machine['box_version'], DEFAULT_BOX_VERSION),
          :graceful_halt_timeout => self.coalesce(machine['graceful_halt_timeout'], DEFAULT_GRACEFUL_HALT_TIMEOUT),
          :post_up_message => machine['post_up_message'],
        }
      end

      
      def parse_net(net)
        case net['net']
        when 'private_network', 'private'
          nettype = :private_network
        when 'forwarded_port', 'port'
          nettype = :forwarded_port
        when 'public_network', 'public', 'bridged'
          nettype = :public_network
        else
          nettype = DEFAULT_NET
        end
        
        return {
          :net  => nettype,
          :type => self.coalesce(net['type'], DEFAULT_NET_TYPE),
          :ip   => net['ip'],
          :mask => self.coalesce(net['mask'], net['netmask'], DEFAULT_NETMASK),
          :interface => net['interface'],
          :guest => net['guest'],
          :host => net['host'],
          :protocol => self.coalesce(net['protocol'], DEFAULT_PROTOCOL),
          :bridge => net['bridge'],
        }
      end

      
      def parse_provision(prv)
        return {
          :type		  => prv['type'],
          :source         => prv['source'],
          :destination    => prv['destination'],
          :path		  => prv['path'],
          :args           => prv['args'],
          :module_path    => prv['module_path'],
          :manifests_path => prv['manifests_path'],
          :manifest_file  => prv['manifest_file'],
        }
      end


      def parse_folder(folder)
        return {
          :host  => folder['host'],
          :guest => folder['guest'],
          :disabled => self.coalesce(folder['disabled'], false),
          :create => self.coalesce(folder['create'], false),
          :type => folder['type'],
        }
      end


      def parse_authorized_key(key)
        return {
          :type => key['type'],
          :path => key['path'],
          :key => key['key'],
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

          machine['authorized_keys'].to_a.each do |key|
            item[:authorized_keys] << self.parse_authorized_key(key)
          end

          config[:machines] << item
        end

        return self.replace_vars(config)
      end


      def coalesce(*args)
        args.each do |val|
          next if val.nil?
          return val
        end
      end
      
    end
  end
end
