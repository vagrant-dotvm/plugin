module VagrantPlugins
  module Dotvm
    module Injector
      class AbstractInjector
        def self.generate_hash(source, options)
          hash = {}

          options.each do |opt|
            val = source.send(opt)
            hash[opt] = val unless val.nil?
          end

          return hash
        end

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
