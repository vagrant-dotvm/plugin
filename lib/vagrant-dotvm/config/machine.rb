module VagrantPlugins
  module Dotvm
    module Config
      class Machine < AbstractConfig
        include OptionsSetter

        OPTIONS_CATEGORIES = [
          :virtualbox,
        ]

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

        def name=(value)
          @hostname = value
        end

        def usable_port_range=(value)
          m = value.scan(/^(\d+)\.\.(\d+)$/)
          raise InvalidConfigError.new 'Invalid usable_port_range, it must be in A..B format.' if m.length == 0
          @usable_port_range = Range.new(m[0][0].to_i, m[0][1].to_i)
        end

        def networks=(networks)
          raise InvalidConfigError.new "'networks' must be array." unless networks.kind_of?(Array) || networks.kind_of?(NilClass)
          @networks = convert_array(networks, Network.name)
        end

        def routes=(routes)
          raise InvalidConfigError.new "'routes' must be array." unless routes.kind_of?(Array) || routes.kind_of?(NilClass)
          @routes = convert_array(routes, Route.name)
        end

        def provision=(provision)
          raise InvalidConfigError.new "'provision' must be array." unless provision.kind_of?(Array) || provision.kind_of?(NilClass)
          @provision = convert_array(provision, Provision.name)
        end

        def groups=(groups)
          raise InvalidConfigError.new "'groups' must be array." unless groups.kind_of?(Array) || groups.kind_of?(NilClass)

          @groups = []
          groups.to_a.each do |item|
            @groups << item
          end
        end

        def authorized_keys=(keys)
          raise InvalidConfigError.new "'authorized_keys' must be array." unless keys.kind_of?(Array) || keys.kind_of?(NilClass)
          @authorized_keys = convert_array(keys, AuthorizedKey.name)
        end

        def hosts=(hosts)
          raise InvalidConfigError.new "'hosts' must be array." unless hosts.kind_of?(Array) || hosts.kind_of?(NilClass)
          @hosts = convert_array(hosts, Host.name)
        end

        def shared_folders=(shared_folders)
          @shared_folders = convert_array(shared_folders, SharedFolder.name)

          settings = {
            'host'     => '%project.host%',
            'guest'    => '%project.guest%',
            'disabled' => false,
            'create'   => false,
            'type'     => nil,
          }
          item = SharedFolder.new
          item.populate settings
          @shared_folders << item
        end

      end
    end
  end
end
