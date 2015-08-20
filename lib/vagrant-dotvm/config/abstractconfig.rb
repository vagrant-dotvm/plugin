module VagrantPlugins
  module Dotvm
    module Config
      class AbstractConfig
        # Populates current object with provided data.
        #
        # @param data [Hash] Hash with data
        def populate(data)
          data.each do |key, value|
            raise InvalidConfigError.new "Invalid configuration option: #{key}." until respond_to? "#{key}="
            send("#{key}=", value)
          end
        end

        def ensure_type(value, type, name = '')
          raise InvalidConfigError.new "'#{name}' must be #{type.name}." unless value.kind_of?(type) || value.kind_of?(NilClass)
        end

        # Converts array of hashes into array of specialized objects.
        #
        # @param data [Array] Array of hashes
        # @param type [String] Specialized class name
        # @return [Array] Array of specialized objects.
        def convert_array(data, type)
          result = []

          data.to_a.each do |item|
            object = Object.const_get(type).new
            object.populate item
            result << object
          end

          result
        end
      end
    end
  end
end
