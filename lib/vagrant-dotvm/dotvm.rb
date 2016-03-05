module VagrantPlugins
  module Dotvm
    class Dotvm
      def initialize(path = nil)
        fail 'path must be set.' until path
        @path = path
      end

      def inject(vc)
        begin
          init_instance
          load_options
          load_projects
          Injector::Instance.inject @instance, vc
        rescue VagrantPlugins::Dotvm::Config::InvalidConfigError => e
          raise Vagrant::Errors::VagrantError.new, "DotVM: #{e.file}: #{e.message}"
        rescue Psych::SyntaxError => e
          raise Vagrant::Errors::VagrantError.new, "DotVM: #{e.file}: Syntax error, line #{e.line}, #{e.problem}"
        end
      end

      private

      def parse_variables(path)
        result = {}

        Dir[path].each do |fname|
          yaml = YAML.load_file(fname) || {}
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
        @instance.variables.append_group 'global', (parse_variables "#{@path}/variables/*.{yaml,yml}")
      end

      def load_options
        Dir["#{@path}/options/*.{yaml,yml}"].each do |file|
          @instance.options = Replacer.new
            .on(YAML.load_file(file) || {})
            .using(@instance.variables)
            .result
        end
      end

      def load_projects
        Dir["#{@path}/projects/*"].each do |dir|
          project = @instance.new_project
          project.variables.append_group 'project', (parse_variables "#{dir}/variables/*.{yaml,yml}")
          project.variables.append_group(
            'host',
            {
              'project_dir' => dir,
              'files_dir' => "#{dir}/files"
            }
          )
          project.variables.append_group(
            'guest',
            {
              'project_dir' => DOTVM_PROJECT_PATH,
              'files_dir' => DOTVM_FILES_PATH
            }
          )

          Dir["#{dir}/machines/*.{yaml,yml}"].each do |file|
            yaml = Replacer.new
                   .on(YAML.load_file(file) || [])
                   .using(@instance.variables.merge(project.variables))
                   .result

            begin
              yaml.each do |machine_yaml|
                machine = project.new_machine
                machine.populate machine_yaml
              end
            rescue VagrantPlugins::Dotvm::Config::InvalidConfigError => e
              # add filename to exception so we can display
              # nice error message later.
              e.file = file
              raise e
            end
          end
        end
      end

    end # DotVm
  end # Dotvm
end # VagrantPlugins
