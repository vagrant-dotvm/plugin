# DotVm

[![Code Climate](https://codeclimate.com/github/vagrant-dotvm/vagrant-dotvm/badges/gpa.svg)](https://codeclimate.com/github/vagrant-dotvm/vagrant-dotvm)
[![Gem Version](https://badge.fury.io/rb/vagrant-dotvm.svg)](http://badge.fury.io/rb/vagrant-dotvm)

## What is that?
DotVm is plugin which makes your life easier when it comes to setup both simple VM in Vagrant and
bigger development environments. You can plug multiple infrastructure projects into one DotVm instance.
Each project can contain many VMs, splitted (or not) into several small YAML files.

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
  dotvm = VagrantPlugins::Dotvm::Dotvm.new __dir__
  dotvm.inject(config)
end
```

Prepare directory for storing your projects:
```
$ mkdir projects
```

## More information
For more information please follow to [wiki](https://github.com/vagrant-dotvm/vagrant-dotvm/wiki/Getting-started).
