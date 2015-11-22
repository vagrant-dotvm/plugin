module VagrantPlugins
  module Dotvm
    class Plugin < Vagrant.plugin(2)
      name 'Dotvm'
      description 'Easy YAML based multi machine config.'

      command(:dotvm) do
        require_relative 'command'
        Command
      end
    end # Plugin
  end # Dotvm
end # VagrantPlugins
