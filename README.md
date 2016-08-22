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

Then init DotVm inside directory where you want to keep all projects:
```
$ vagrant dotvm init
```

## More information
For more information please follow to [documentation](https://github.com/vagrant-dotvm/documentation).

## Logo
Computing graphic by [Webalys](http://www.streamlineicons.com/) from [Flaticon](http://www.flaticon.com/) is licensed under [CC BY 3.0](http://creativecommons.org/licenses/by/3.0/). Made with [Logo Maker](http://logomakr.com).
