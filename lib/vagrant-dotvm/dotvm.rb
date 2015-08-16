module VagrantPlugins
  module Dotvm
    class Dotvm

      def initialize(path = nil)
        path = Dir.pwd unless path
        @path = path
      end

      private
      def get_globals
        globals = {}

        Dir[@path + '/globals/*.yaml'].each do |fname|
          yaml = YAML::load(File.read(fname)) || {}
          yaml.each do |name, value|
            globals[name] = value
          end
        end

        globals
      end

      private
      def get_configs
        configs = []

        Dir[@path + "/projects/*/*.yaml"].each do |fname|
          yaml = YAML::load(File.read(fname)) || {}

          vars = {
            'project.host' => File.dirname(fname),
            'project.guest' => '/dotvm/project',
          }

          ENV.each_pair do |name, value|
            vars['env.' + name] = value
          end

          get_globals.each do |name, value|
            vars['global.' + name] = value
          end

          begin
            conf = Config::Root.new
            conf.populate yaml

            conf.vars.to_h.each do |name, value|
              vars['local.' + name] = value
            end

            for _ in (0..5)
              last = conf.replace_vars! vars
              break if last == 0
            end

            raise 'Too deep variables relations, possible recurrence.' unless last == 0
          rescue StandardError => e
            file = fname[(@path.length + "/projects/".length)..-1]
            raise Vagrant::Errors::VagrantError.new, "DotVM: #{file}: #{e.message}"
          end

          configs << conf
        end

        return configs
      end

      public
      def inject(vc)
        get_configs.each do |config|
          Injector::Root.inject config: config, vc: vc
        end
      end

    end # DotVm
  end # Dotvm
end # VagrantPlugins
