module VagrantPlugins
  module Dotvm
    module Config
      module OptionsSetter
        def options=(options)
          ensure_hash options, 'options'

          @options  = {}
          self.class::OPTIONS_CATEGORIES.each do |cat|
            @options[cat] = []
          end

          options.to_h.each do |key, confs|
            key = key.to_sym
            raise InvalidConfigError.new "Invalid options category: #{key}." unless @options.has_key?(key)

            confs.to_a.each do |conf|
              item = Option.new
              item.populate conf
              @options[key] << item
            end
          end
        end
      end
    end
  end
end
