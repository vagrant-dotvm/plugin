module VagrantPlugins
  module Dotvm
    module Injector
      class AbstractInjector
        # Extracts specified `options` from `source` and return them as hash.
        #
        # @param source [Object] Object to extract data from
        # @param options [Array] List of options to be extraced
        # @return [Hash] Extracted data
        def self.generate_hash(source, options)
          hash = {}

          options.each do |opt|
            val = source.send(opt)
            hash[opt] = val unless val.nil?
          end

          return hash
        end

        # Rewrite `options` from `source` to `target`.
        #
        # @param source [Object] Object to rewrite data from
        # @param target [Object] Object to rewrite data to
        # @param options [Array] List of options to be rewritten
        def self.rewrite_options(source, target, options)
          options.each do |opt|
            val = source.send(opt)
            target.send("#{opt}=", val) unless val.nil?
          end
        end
      end
    end
  end
end
