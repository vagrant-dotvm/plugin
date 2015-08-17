module VagrantPlugins
  module Dotvm
    class Dotvm

      def initialize(path = nil)
        raise 'path must be set.' until path
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
      def prefix_vars(vars, prefix)
        result = {}

        vars.each do |name, value|
          result[prefix + name] = value
        end

        result
      end

      private
      def process_config(fname)
        yaml = YAML::load(File.read(fname)) || {}

        begin
          conf = Config::Root.new
          conf.populate yaml

          vars = {}
          vars.merge! prefix_vars(ENV, 'env.')
          vars.merge! prefix_vars(get_globals, 'global.')
          vars.merge! prefix_vars(conf.vars.to_h, 'local.')
          vars.merge!(
            {
              'project.host'  => File.dirname(fname),
              'project.guest' => '/dotvm/project',
            }
          )

          for _ in (0..5)
            last = conf.replace_vars! vars
            break if last == 0
          end

          raise 'Too deep variables relations, possible recurrence.' unless last == 0
        rescue VagrantPlugins::Dotvm::Config::InvalidConfigError => e
          file = fname[(@path.length + '/projects/'.length)..-1]
          raise Vagrant::Errors::VagrantError.new, "DotVM: #{file}: #{e.message}"
        end

        conf
      end

      private
      def get_configs
        configs = []

        Dir[@path + '/projects/*/*.yaml'].each do |fname|
          configs << process_config(fname)
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
