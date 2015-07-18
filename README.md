# DotVm

[![Scrutinizer Code Quality](https://scrutinizer-ci.com/g/krzysztof-magosa/vagrant-dotvm/badges/quality-score.png?b=master)](https://scrutinizer-ci.com/g/krzysztof-magosa/vagrant-dotvm/?branch=master)

## What is that?
DotVm is vagrant plugin for easier maintenance of multi machine configurations.
DotVm joins easy syntax of YAML files with flexibility offered by configuration exploded into several small files.

## How to start using DotVm
First you need to install DotVm plugin:
```
$ vagrant plugin install vagrant-dotvm
```

It's also recommended to install plugin for easier work with groups:
```
$ vagrant plugin install vagrant-group
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

Please refer to [example](/examples) to see possible options.

## Available variables
You can use variables inside of config values.
Environment variables are accessible by using env prefix, e.g. `%env.LOGNAME%`.  

Predefined variables:  
* `%project.host%` - points to project directory on host
* `%project.guest%` - points to project directory on guest
