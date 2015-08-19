module VagrantPlugins
  module Dotvm
    class Variables < Hash
      def append_group(group, items)
        items.each do |name, value|
          self["#{group}.#{name}"] = value
        end
      end
    end
  end
end
