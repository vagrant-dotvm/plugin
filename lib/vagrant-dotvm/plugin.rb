module VagrantPlugins
  module Dotvm
    class Plugin < Vagrant.plugin(2)
      name 'Dotvm'
      description 'Easy YAML based multi machine config.'

      command(:dotvm) do
        require_relative 'command'
        Command
      end

      command(:group) do
        require_relative 'group/command'
        Group::Command
      end

      config(:dotvm_group) do
        require_relative 'group/config'
        Group::Config
      end
    end # Plugin
  end # Dotvm
end # VagrantPlugins
