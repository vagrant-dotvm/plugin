module VagrantPlugins
  module Dotvm
    module Injector
      module SharedFolder
        extend AbstractInjector

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
          :smb_username
        ]

        module_function

        def inject(folder: nil, machine: nil)
          machine.vm.synced_folder(
            folder.host,
            folder.guest,
            **generate_hash(folder, OPTIONS)
          )
        end
      end
    end
  end
end
