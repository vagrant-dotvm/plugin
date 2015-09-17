module VagrantPlugins
  module Dotvm
    class Dotvm

      def initialize(path = nil)
        fail 'path must be set.' until path
        @path = path
      end

      def inject(vc)
        init_instance
        load_options
        load_projects
        Injector::Instance.inject @instance, vc
      end

      private

      def parse_variables(path)
        result = {}

        Dir[path].each do |fname|
          yaml = YAML.load(File.read(fname)) || {}
          yaml.each do |name, value|
            fail "Variable #{name} already exists." if result.key? name
            result[name] = value
          end
        end

        result
      end

      def init_instance
        @instance = Config::Instance.new
        @instance.variables.append_group 'env', ENV
        @instance.variables.append_group 'global', (parse_variables "#{@path}/variables/*.yaml")
      end

      def load_options
        Dir["#{@path}/options/*.yaml"].each do |file|
          @instance.options = Replacer.new
            .on(YAML.load(File.read(file)) || {})
            .using(@instance.variables)
            .result
        end
      end

      def load_projects
        Dir["#{@path}/projects/*"].each do |dir|
          project = @instance.new_project
          project.variables.append_group 'project', (parse_variables "#{dir}/variables/*.yaml")
          project.variables.append_group(
            'host',
            {
              'project_dir' => dir,
              'files_dir' => "#{dir}/files",
            }
          )
          project.variables.append_group(
            'guest',
            {
              'project_dir' => DOTVM_PROJECT_PATH,
              'files_dir' => "#{DOTVM_PROJECT_PATH}/files"
            }
          )

          Dir["#{dir}/machines/*.yaml"].each do |file|
            begin
              yaml = Replacer.new
                     .on(YAML.load(File.read(file)) || [])
                     .using(@instance.variables.merge(project.variables))
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
      end

    end # DotVm
  end # Dotvm
end # VagrantPlugins
