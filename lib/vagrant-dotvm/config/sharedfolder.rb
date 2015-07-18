module VagrantPlugins
  module Dotvm
    module Config
      class SharedFolder < AbstractConfig
        attr_accessor :host
        attr_accessor :guest
        attr_accessor :disabled
        attr_accessor :create
        attr_accessor :type
        attr_accessor :group
        attr_accessor :mount_options
        attr_accessor :owner
        attr_accessor :nfs_export
        attr_accessor :nfs_udp
        attr_accessor :nfs_version
        attr_accessor :rsync__args
        attr_accessor :rsync__auto
        attr_accessor :rsync__chown
        attr_accessor :rsync__exclude
        attr_accessor :rsync__rsync_path
        attr_accessor :rsync__verbose
        attr_accessor :smb_host
        attr_accessor :smb_password
        attr_accessor :smb_username

        def initialize()
          @disabled = false
          @create   = false
        end
      end
    end
  end
end
