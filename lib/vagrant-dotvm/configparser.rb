module VagrantPlugins
  module Dotvm
    class ConfigParser

      DEFAULT_NET                   = "private_network"
      DEFAULT_NET_TYPE              = "static"
      DEFAULT_NETMASK               = "255.255.255.0"
      DEFAULT_PROTOCOL              = "tcp"
      DEFAULT_BOOT_TIMEOUT          = 300
      DEFAULT_BOX_CHECK_UPDATE      = true
      DEFAULT_BOX_VERSION           = ">= 0"
      DEFAULT_GRACEFUL_HALT_TIMEOUT = 60

      def initialize(vars = {})
        @vars = vars
      end

      private
      def replace_vars(value)
        if value.kind_of?(Hash)
          result = {}
          value.each do |key, val|
            result[key] = replace_vars(val)
          end
        elsif value.kind_of?(Array)
          result = value.map do |val|
            replace_vars(val)
          end
        elsif value.kind_of?(String)
          result = value.dup

          @vars.each do |k, v|
            pattern = "%#{k}%"
            result.gsub! pattern, v
          end
        elsif !value.respond_to?(:duplicable) or !value.duplicable?
          result = value
        else
          result = value.dup
        end

        return result
      end

      private
      def parse_machine(machine)
        return {
          :nick	                 => machine["nick"],
          :name	                 => machine["name"],
          :box                   => machine["box"],
          :memory                => machine["memory"],
          :cpus                  => machine["cpus"],
          :cpucap                => machine["cpucap"],
          :primary               => coalesce(machine["primary"], false),
          :natnet                => machine["natnet"],
          :networks              => [],
          :provision             => [],
          :groups                => [],
          :authorized_keys       => [],
          :boot_timeout          => coalesce(machine["boot_timeout"], DEFAULT_BOOT_TIMEOUT),
          :box_check_update      => coalesce(machine["box_check_update"], DEFAULT_BOX_CHECK_UPDATE),
          :box_version           => coalesce(machine["box_version"], DEFAULT_BOX_VERSION),
          :graceful_halt_timeout => coalesce(machine["graceful_halt_timeout"], DEFAULT_GRACEFUL_HALT_TIMEOUT),
          :post_up_message       => machine["post_up_message"],
          :autostart             => coalesce(machine["autostart"], true),
          :folders               => [
            {
              :host     => "%project.host%",
              :guest    => "%project.guest%",
              :disabled => false,
              :create   => false,
              :type     => nil,
            }
          ],
        }
      end

      private
      def parse_net(net)
        case net["net"]
        when "private_network", "private"
          nettype = :private_network
        when "forwarded_port", "port"
          nettype = :forwarded_port
        when "public_network", "public", "bridged"
          nettype = :public_network
        else
          nettype = DEFAULT_NET
        end

        return {
          :net       => nettype,
          :type      => coalesce(net["type"], DEFAULT_NET_TYPE),
          :ip        => net["ip"],
          :mask      => coalesce(net["mask"], net["netmask"], DEFAULT_NETMASK),
          :interface => net["interface"],
          :guest     => net["guest"],
          :host      => net["host"],
          :protocol  => coalesce(net["protocol"], DEFAULT_PROTOCOL),
          :bridge    => net["bridge"],
        }
      end

      private
      def parse_provision(prv)
        return {
          :type		  => prv["type"],
          :source         => prv["source"],
          :destination    => prv["destination"],
          :path		  => prv["path"],
          :args           => prv["args"],
          :module_path    => prv["module_path"],
          :manifests_path => prv["manifests_path"],
          :manifest_file  => prv["manifest_file"],
        }
      end

      private
      def parse_folder(folder)
        return {
          :host     => folder["host"],
          :guest    => folder["guest"],
          :disabled => coalesce(folder["disabled"], false),
          :create   => coalesce(folder["create"], false),
          :type     => folder["type"],
        }
      end

      private
      def parse_authorized_key(key)
        return {
          :type => key["type"],
          :path => key["path"],
          :key  => key["key"],
        }
      end

      public
      def parse(yaml)
        config = {
          :machines => []
        }

        yaml["machines"].each do |machine|
          item = parse_machine(machine)

          machine["networks"].to_a.each do |net|
            item[:networks] << parse_net(net)
          end

          machine["provision"].to_a.each do |prv|
            item[:provision] << parse_provision(prv)
          end

          machine["shared_folders"].to_a.each do |folder|
            item[:folders] << parse_folder(folder)
          end

          machine["groups"].to_a.each do |group|
            item[:groups] << group
          end

          machine["authorized_keys"].to_a.each do |key|
            item[:authorized_keys] << parse_authorized_key(key)
          end

          config[:machines] << item
        end

        return replace_vars(config)
      end

      private
      def coalesce(*args)
        args.each do |val|
          next if val.nil?
          return val
        end
      end

    end
  end
end
