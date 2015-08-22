module VagrantPlugins
  module Dotvm
    class Dotvm

      def initialize(path = nil)
        raise 'path must be set.' until path
        @path = path
      end

      private
      def parse_variables(path)
        result = {}

        Dir[path].each do |fname|
          yaml = YAML::load(File.read(fname)) || {}
          yaml.each do |name, value|
            raise "Variable #{name} already exists." if result.has_key? name
            result[name] = value
          end
        end

        result
      end

      private
      def _replace_vars(target, vars)
        if target.is_a? Hash
          target.each do |k, v|
            target[k] = _replace_vars v, vars
          end
        elsif target.is_a? Array
          target.map! do |v|
            _replace_vars v, vars
          end
        elsif target.is_a? String
          vars.each do |k, v|
            pattern = "%#{k}%"

            if target.include? pattern
              @replaced += 1

              if target == pattern
                target = v
              else
                target = target.gsub pattern, v
              end
            end
          end
        end

        target
      end

      private
      def replace_vars(target, vars)
        0.upto(15).each do |_|
          @replaced = 0
          target = _replace_vars target, vars
          return target if @replaced == 0
        end

        raise 'Too deep variables relations, possible recurrence.'
      end

      private
      def process_configuration
        instance = Config::Instance.new
        instance.variables.append_group 'env', ENV
        instance.variables.append_group 'global', (parse_variables "#{@path}/variables/*.yaml")

        Dir["#{@path}/options/*.yaml"].each do |file|
          yaml = YAML::load(File.read(file)) || {}
          yaml = replace_vars yaml, instance.variables
          instance.options = yaml
        end

        Dir["#{@path}/projects/*"].each do |dir|
          project = instance.new_project
          project.variables.append_group 'project', (parse_variables "#{dir}/variables/*.yaml")
          project.variables.append_group(
            'dotvm',
            {
              'project.host_dir' => dir,
              'project.guest_dir' => DOTVM_PROJECT_PATH,
            }
          )

          Dir["#{dir}/machines/*.yaml"].each do |file|
            begin
              yaml = YAML::load(File.read(file)) || []
              yaml = replace_vars yaml, instance.variables.merge(project.variables)

              yaml.each do |machine_yaml|
                machine = project.new_machine
                machine.populate machine_yaml
              end
            rescue VagrantPlugins::Dotvm::Config::InvalidConfigError => e
              raise Vagrant::Errors::VagrantError.new, "DotVM: #{file}: #{e.message}"
            end
          end
        end

        instance
      end

      public
      def inject(vc)
        instance = process_configuration
        Injector::Instance.inject instance, vc
      end

    end # DotVm
  end # Dotvm
end # VagrantPlugins
