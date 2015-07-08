# DotVm

## How to start using DotVm
First you need to install DotVm plugin:
```
$ vagrant plugin install vagrant-dotvm
```

Then create Vagrantfile like that:
```ruby
require 'vagrant-dotvm'

Vagrant.configure(2) do |config|
  # config directory will be expected in the same
  # directory as Vagrantfile.
  config_path = File.dirname(File.expand_path(__FILE__)) + "/config"
  dotvm = VagrantPlugins::Dotvm::Dotvm.new config_path
  dotvm.inject(config)
end
```

Prepare directory for storing your projects:
```
$ mkdir -p config/projects
```

## How to configure machine
You need to create folder named after your project in `config/projects`.
In this folder you can create as many YAML files as you want.
In each one you are able to define multiple machines.


Example YAML configuration:
```yaml
machines:
  - nick: example
    name: machine1.example
    box: chef/centos-7.0
    networks:
      - net: private_network
        ip: 192.168.56.100
        mask: 255.255.255.0
    provision:
      - type: shell
        path: "%project.host%/bootstrap.sh"
        args:
          - "%project.guest%"
    shared_folders:
      - host: /Volumes/Repos
        guest: /srv/www
```

## Available variables
You can use variables inside of config values.
Environment variables are accessible by using env prefix, e.g. `%env.LOGNAME%`.  

Predefined variables:  
* `%project.host%` - points to project directory on host
* `%project.guest%` - points to project directory on guest
