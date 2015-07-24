# 0.29.0
* Chef provision

# 0.28.0
* Ansible provision

# 0.27.0
* CFEngine provision

# 0.26.0
* Do validation of types in config
* vCPUs and memory options are not passed to VMWare Fusion
* Salt provision

# 0.25.0
* Ability to set global options for ssh
* Ability to set global options for winrm
* Ability to set global options for vagrant
* Don't set X11 forwarding by default, now it's controlled via option

# 0.24.0
* Fix for autostart/primary options incorrectly passed to Vagrant

# 0.23.0
* Support for puppet_server provision options
* Added option usable_port_range

# 0.22.0
* Support for more options - shell, puppet provisions
* Support for more options - shared folders
* Remove default settings from shared folders

# 0.21.0
* Support for more options - puppet provision
* Support for more options - vm
* Support for more options - network
* Fix for case when some options are missing - vm

# 0.20.0
* Now error is displayed when you specify unsupported option
* Removal of next bunch of default parameters

# 0.19.0
* Ability to use inline shell provision

# 0.18.0
* Use sh to add hosts entries to cover more systems

# 0.17.0
* Add ability to add entries to /etc/hosts in guest
* Ability to set custom options for VirtualBox
* Remove default setting for natdnshostresolver1

# 0.16.0
* Remove default settings so DotVm is more transparent

# 0.15.1
* Fix for natnet option

# 0.15.0
* Ability to set run option on provision
* Fix privileged option in provision
* Ability to setup static routes

# 0.14.0
* Ability to configure autostart option

# 0.13.0
* Ability to configure some vm related options
* Ability to use shorter forms of network
* Ability to configure public network
* Ability to set some options on shared folders
* Fix bug in port forwarding

# 0.12.0
* Ability to forward port

# 0.11.0
* Ability to authorize ssh public key from file or hardcoded string

# 0.10.0
* Make `/vagrant` available in guest

# 0.9.0
* Ability to select network interface in private network

# 0.8.0
* Now forwarding of X11 via SSH is enabled
* Ability to configure nat network
* Ability to use variables in many configuration options
* Ability to pass args to provision script
* Now project directory is available in guest

# 0.7.0
* Better handling of network configuration

# 0.6.0
* Ability to configure primary machine

# 0.5.0
* Ability to configure groups for `vagrant-group` users

# 0.4.0
* Ability to use environment variables in configuration

# 0.3.0
* Ability to use predefined variables
* Ability to configure shared folders

# 0.2.0
* Now configs are spread across projects directories

# 0.1.0
* Initial version
