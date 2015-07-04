module VagrantPlugins
  module Dotvm
    class Dotvm
      
      def initialize(path = nil)
        if not path
          path = Dir.pwd
        end

        @path = path
      end


      def get_configs()
        configs = []

        Dir[@path + "/*.yaml"].each do |fname|
          yaml = YAML::load(File.read(fname))
          configs << ConfigParser.parse(yaml)
        end

        return configs
      end

      
      def inject(vc)
        configs = self.get_configs()

        configs.each do |config|
          ConfigInjecter.inject(config, vc)
        end
      end

    end # DotVm
  end # Dotvm
end # VagrantPlugins
