module VagrantPlugins
  module Dotvm
    module Config
      class Root < AbstractConfig
        attr_reader :machines
        attr_reader :options

        def initialize()
          @machines = []
          @options  = {
            :ssh     => [],
            :winrm   => [],
            :vagrant => [],
          }
        end

        def populate_machines(data)
          data.to_a.each do |item|
            machine = Machine.new
            machine.populate item
            @machines << machine
          end
        end

        def populate_options(data)
          data.to_h.each do |key, confs|
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
