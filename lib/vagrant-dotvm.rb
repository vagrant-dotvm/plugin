require 'vagrant'
require 'yaml'

require 'vagrant-dotvm/plugin'
require 'vagrant-dotvm/version'
require 'vagrant-dotvm/paths'
require 'vagrant-dotvm/dotvm'

require 'vagrant-dotvm/variables'
require 'vagrant-dotvm/replacer'

require 'vagrant-dotvm/injector/abstractinjector'
require 'vagrant-dotvm/injector/instance'
require 'vagrant-dotvm/injector/project'
require 'vagrant-dotvm/injector/machine'
require 'vagrant-dotvm/injector/provision'
require 'vagrant-dotvm/injector/authorizedkey'
require 'vagrant-dotvm/injector/host'
require 'vagrant-dotvm/injector/sharedfolder'
require 'vagrant-dotvm/injector/route'
require 'vagrant-dotvm/injector/network'

require 'vagrant-dotvm/config/optionssetter'
require 'vagrant-dotvm/config/invalidconfigerror'
require 'vagrant-dotvm/config/abstractconfig'
require 'vagrant-dotvm/config/instance'
require 'vagrant-dotvm/config/project'
require 'vagrant-dotvm/config/machine'
require 'vagrant-dotvm/config/provision'
require 'vagrant-dotvm/config/authorizedkey'
require 'vagrant-dotvm/config/host'
require 'vagrant-dotvm/config/sharedfolder'
require 'vagrant-dotvm/config/option'
require 'vagrant-dotvm/config/route'
require 'vagrant-dotvm/config/network'
require 'vagrant-dotvm/config/buildimage'
require 'vagrant-dotvm/config/run'
