module VagrantPlugins
  module Dotvm
    module Config
      class Root < AbstractConfig
        attr_reader :machines
        attr_reader :options

        def machines=(machines)
          raise "'machines' must be array." unless machines.kind_of?(Array) || machines.kind_of?(NilClass)

          @machines = []
          machines.to_a.each do |item|
            machine = Machine.new
            machine.populate item
            @machines << machine
          end
        end

        def options=(data)
          raise "'options' must be hash." unless options.kind_of?(Hash) || options.kind_of?(NilClass)

          @options  = {
            :ssh     => [],
            :winrm   => [],
            :vagrant => [],
          }
          options.to_h.each do |key, confs|
            key = key.to_sym
            raise "Invalid options category: #{key}." unless @options.has_key?(key)

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
