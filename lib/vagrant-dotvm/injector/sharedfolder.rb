module VagrantPlugins
  module Dotvm
    module Injector
      class SharedFolder
        OPTIONS = [
          :disabled,
          :create,
          :type,
          :group,
          :mount_options,
          :owner,
          :nfs_export,
          :nfs_udp,
          :nfs_version,
          :rsync__args,
          :rsync__auto,
          :rsync__chown,
          :rsync__exclude,
          :rsync__rsync_path,
          :rsync__verbose,
          :smb_host,
          :smb_password,
          :smb_username,
        ]

        def self.inject(folder: nil, machine: nil)
          hash = {}

          OPTIONS.each do |opt|
            val = folder.send(opt)
            hash[opt] = val unless val.nil?
          end

          machine.vm.synced_folder folder.host, folder.guest, **hash
        end
      end
    end
  end
end
