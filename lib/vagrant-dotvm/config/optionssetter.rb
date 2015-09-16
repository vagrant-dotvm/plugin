module VagrantPlugins
  module Dotvm
    module Config
      module OptionsSetter
        def options=(options)
          ensure_type options, Hash, 'options'

          @options  = {}
          self.class::OPTIONS_CATEGORIES.each do |cat|
            @options[cat] = []
          end

          options.to_h.each do |key, confs|
            key = key.to_sym
            fail InvalidConfigError.new, "Invalid options category: #{key}." unless @options.key?(key)
            ensure_type confs, Array, "options.#{key}"

            confs.to_a.each do |conf|
              ensure_type conf, Hash, "option item within options.#{key}"

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
