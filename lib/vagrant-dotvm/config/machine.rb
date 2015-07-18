module VagrantPlugins
  module Dotvm
    module Config
      class Machine < AbstractConfig
        attr_accessor :nick
        attr_accessor :name
        attr_accessor :box
        attr_accessor :memory
        attr_accessor :cpus
        attr_accessor :cpucap
        attr_accessor :primary
        attr_accessor :natnet
        attr_accessor :networks
        attr_accessor :routes
        attr_accessor :provision
        attr_accessor :groups
        attr_accessor :authorized_keys
        attr_accessor :boot_timeout
        attr_accessor :box_check_update
        attr_accessor :box_version
        attr_accessor :graceful_halt_timeout
        attr_accessor :post_up_message
        attr_accessor :autostart
        attr_accessor :hosts
        attr_accessor :options
        attr_accessor :shared_folders

        def initialize()
          @primary         = false
          @networks        = []
          @routes          = []
          @provision       = []
          @groups          = []
          @authorized_keys = []
          @hosts           = []
          @options         = {
            :virtualbox    => [],
          }
          @shared_folders  = []

          populate_shared_folders(
            [
              {
                "host"     => "%project.host%",
                "guest"    => "%project.guest%",
                "disabled" => false,
                "create"   => false,
                "type"     => nil,
              }
            ]
          )
        end

        def populate_networks(data)
          data.to_a.each do |conf|
            item = Network.new
            item.populate conf
            @networks << item
          end
        end

        def populate_routes(data)
          data.to_a.each do |conf|
            item = Route.new
            item.populate conf
            @routes << item
          end
        end

        def populate_provision(data)
          data.to_a.each do |conf|
            item = Provision.new
            item.populate conf
            @provision << item
          end
        end

        def populate_groups(data)
          data.to_a.each do |item|
            @groups << item
          end
        end

        def populate_authorized_keys(data)
          data.to_a.each do |conf|
            item = AuthorizedKey.new
            item.populate conf
            @authorized_keys << item
          end
        end

        def populate_hosts(data)
          data.to_a.each do |conf|
            item = Host.new
            item.populate conf
            @hosts << item
          end
        end

        def populate_options(data)
          data.to_h.each do |key, confs|
            key = key.to_sym
            raise "Invalid options category: #{key}." unless @options.has_key?(key)

            confs.to_a.each do |conf|
              item = Option.new
              item.populate conf
              @options[key] << item
            end
          end
        end

        def populate_shared_folders(data)
          data.to_a.each do |conf|
            item = SharedFolder.new
            item.populate conf
            @shared_folders << item
          end
        end

      end
    end
  end
end
