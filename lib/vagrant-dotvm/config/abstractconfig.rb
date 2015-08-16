module VagrantPlugins
  module Dotvm
    module Config
      class AbstractConfig
        # Populates current object with provided data.
        #
        # @param data [Hash] Hash with data
        def populate(data)
          data.each do |key, value|
            raise "Invalid configuration option: #{key}." until respond_to? "#{key}="
            send("#{key}=", value)
          end
        end

        # Replaces variables in target object.
        #
        # @param vars [Hash] Hash of variables to be replaced.
        # @param target [Object] Object to operate on.
        # @return [Number] Number of performed replaces.
        def replace_vars(vars, target)
          replaced = 0

          if target.kind_of?(Array)
            target.each do |item|
              replaced += replace_vars(vars, item)
            end
          elsif target.kind_of?(Hash)
            target.each do |name, item|
              replaced += replace_vars(vars, item)
            end
          elsif target.kind_of?(String)
            vars.each do |k, v|
              pattern = "%#{k}%"
              replaced += 1 unless (target.gsub! pattern, v).kind_of?(NilClass)
            end
          elsif target.kind_of?(AbstractConfig)
            replaced += target.replace_vars!(vars)
          end

          replaced
        end

        # Search for variables within this object
        # and performs replaces of them.
        #
        # @param vars [Hash] Hash of variables to be replaced.
        # @return [Number] Number of performed replaces.
        def replace_vars!(vars)
          replaced = 0

          instance_variables.each do |var_name|
            var = instance_variable_get(var_name)
            replaced += replace_vars(vars, var)
          end

          replaced
        end
      end
    end
  end
end
