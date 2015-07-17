module VagrantPlugins
  module Dotvm
    class Dotvm

      def initialize(path = nil)
        if not path
          path = Dir.pwd
        end

        @path = path
      end

      private
      def get_configs()
        configs = []

        Dir[@path + "/projects/*/*.yaml"].each do |fname|
          yaml = YAML::load(File.read(fname))

          vars = {
            'project.host' => File.dirname(fname),
            'project.guest' => '/dotvm/project',
          }

          ENV.each_pair do |name, value|
            vars['env.' + name] = value
          end

          begin
            conf = Config::Root.new
            conf.populate yaml
            conf.replace_vars! vars
          rescue Exception => e
            raise Vagrant::Errors::VagrantError.new, "DotVM: #{e.message}"
          end

          configs << conf
        end

        return configs
      end

      public
      def inject(vc)
        configs = get_configs()

        configs.each do |config|
          ConfigInjecter.inject(config, vc)
        end
      end

    end # DotVm
  end # Dotvm
end # VagrantPlugins
