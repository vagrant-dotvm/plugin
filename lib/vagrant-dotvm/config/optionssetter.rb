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
            ensure_array confs, "options.#{key}"

            confs.to_a.each do |conf|
              ensure_hash conf, "option item within options.#{key}"

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
