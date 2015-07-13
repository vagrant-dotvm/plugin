module VagrantPlugins
  module Dotvm
    class ConfigParser

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
        {
          :nick	                 => machine["nick"],
          :name	                 => machine["name"],
          :box                   => machine["box"],
          :memory                => machine["memory"],
          :cpus                  => machine["cpus"],
          :cpucap                => machine["cpucap"],
          :primary               => coalesce(machine["primary"], false),
          :natnet                => machine["natnet"],
          :networks              => [],
          :routes                => [],
          :provision             => [],
          :groups                => [],
          :authorized_keys       => [],
          :boot_timeout          => coalesce(machine["boot_timeout"], Defaults::BOOT_TIMEOUT),
          :box_check_update      => coalesce(machine["box_check_update"], Defaults::BOX_CHECK_UPDATE),
          :box_version           => coalesce(machine["box_version"], Defaults::BOX_VERSION),
          :graceful_halt_timeout => coalesce(machine["graceful_halt_timeout"], Defaults::GRACEFUL_HALT_TIMEOUT),
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
          :options               => {
            :virtualbox => [],
          },
        }
      end

      private
      def parse_net(net)
        nets = {
          "private_network" => :private_network,
          "private"         => :private_network,
          "public_network"  => :public_network,
          "public"          => :public_network,
          "forwarded_port"  => :forwarded_port,
          "port"            => :forwarded_port,
        }

        {
          :net       => nets.has_key?(net["net"]) ? nets[net["net"]] : Defaults::NET,
          :type      => coalesce(net["type"], Defaults::NET_TYPE),
          :ip        => net["ip"],
          :mask      => coalesce(net["mask"], net["netmask"], Defaults::NETMASK),
          :interface => net["interface"],
          :guest     => net["guest"],
          :host      => net["host"],
          :protocol  => coalesce(net["protocol"], Defaults::PROTOCOL),
          :bridge    => net["bridge"],
        }
      end

      private
      def parse_route(route)
        {
          :destination => route["destination"],
          :gateway     => route["gateway"],
        }
      end

      private
      def parse_provision(prv)
        {
          :type		  => prv["type"],
          :source         => prv["source"],
          :destination    => prv["destination"],
          :path		  => prv["path"],
          :args           => prv["args"],
          :module_path    => prv["module_path"],
          :manifests_path => prv["manifests_path"],
          :manifest_file  => prv["manifest_file"],
          :privileged     => prv["privileged"].nil? ? true : prv["privileged"],
          :run            => prv["run"],
        }
      end

      private
      def parse_folder(folder)
        {
          :host     => folder["host"],
          :guest    => folder["guest"],
          :disabled => coalesce(folder["disabled"], false),
          :create   => coalesce(folder["create"], false),
          :type     => folder["type"],
        }
      end

      private
      def parse_authorized_key(key)
        {
          :type => key["type"],
          :path => key["path"],
          :key  => key["key"],
        }
      end

      private
      def parse_option(option)
        {
          :name  => option["name"],
          :value => option["value"],
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

          machine["routes"].to_a.each do |route|
            item[:routes] << parse_route(route)
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

          machine["options"].to_h["virtualbox"].to_a.each do |option|
            item[:options][:virtualbox] << parse_option(option)
          end

          config[:machines] << item
        end

        replace_vars(config)
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
