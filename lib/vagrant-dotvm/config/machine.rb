module VagrantPlugins
  module Dotvm
    module Config
      class Machine < AbstractConfig
        include OptionsSetter

        OPTIONS_CATEGORIES = [
          :virtualbox
        ]

        attr_reader :parent
        attr_accessor :nick
        attr_accessor :hostname # name
        attr_accessor :box
        attr_accessor :memory
        attr_accessor :cpus
        attr_accessor :cpucap
        attr_accessor :primary
        attr_accessor :natnet
        attr_reader :networks
        attr_reader :routes
        attr_reader :provision
        attr_reader :groups
        attr_reader :authorized_keys
        attr_accessor :boot_timeout
        attr_accessor :box_check_update
        attr_accessor :box_version
        attr_accessor :graceful_halt_timeout
        attr_accessor :post_up_message
        attr_accessor :autostart
        attr_reader :hosts
        attr_reader :options # mixin
        attr_reader :shared_folders
        attr_accessor :box_download_checksum
        attr_accessor :box_download_checksum_type
        attr_accessor :box_download_client_cert
        attr_accessor :box_download_ca_cert
        attr_accessor :box_download_ca_path
        attr_accessor :box_download_insecure
        attr_accessor :box_download_location_trusted
        attr_accessor :box_url
        attr_accessor :communicator
        attr_accessor :guest
        attr_reader :usable_port_range

        def initialize(parent)
          @parent = parent
        end

        def name=(value)
          @hostname = value
        end

        def usable_port_range=(value)
          m = value.scan(/^(\d+)\.\.(\d+)$/)
          raise InvalidConfigError.new 'Invalid usable_port_range, it must be in A..B format.' if m.length == 0
          @usable_port_range = Range.new(m[0][0].to_i, m[0][1].to_i)
        end

        def networks=(networks)
          ensure_type networks, Array, 'networks'
          @networks = convert_array(networks, Network.name)
        end

        def routes=(routes)
          ensure_type routes, Array, 'routes'
          @routes = convert_array(routes, Route.name)
        end

        def provision=(provision)
          ensure_type provision, Array, 'provision'
          @provision = convert_array(provision, Provision.name)
        end

        def groups=(groups)
          ensure_type groups, Array, 'groups'

          @groups = []
          groups.to_a.each do |item|
            @groups << item
          end
        end

        def authorized_keys=(keys)
          ensure_type keys, Array, 'authorized_keys'
          @authorized_keys = convert_array(keys, AuthorizedKey.name)
        end

        def hosts=(hosts)
          ensure_type hosts, Array, 'hosts'
          @hosts = convert_array(hosts, Host.name)
        end

        def shared_folders=(shared_folders)
          ensure_type shared_folders, Array, 'shared_folders'
          @shared_folders = convert_array(shared_folders, SharedFolder.name)

          # Mount DotVM project directory
          settings = {
            'host'     => @parent.variables['host.project_dir'],
            'guest'    => @parent.variables['guest.project_dir'],
            'disabled' => false,
            'create'   => false,
            'type'     => nil
          }
          item = SharedFolder.new
          item.populate settings
          @shared_folders << item
        end

      end
    end
  end
end
