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
      def process_configuration
        instance = Config::Instance.new
        instance.variables.append_group 'env', ENV
        instance.variables.append_group 'global', (parse_variables "#{@path}/variables/*.yaml")

        Dir["#{@path}/options/*.yaml"].each do |file|
          instance.options = Replacer.new
                 .on(YAML::load(File.read(file)) || {})
                 .using(instance.variables)
                 .result
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
              yaml = 
              yaml = Replacer.new
                     .on(YAML::load(File.read(file)) || [])
                     .using(instance.variables.merge(project.variables))
                     .result

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
