module VagrantPlugins
  module Dotvm
    module Config
      class AbstractConfig
        def populate(data)
          data.each do |key, value|
            raise "Invalid configuration option: #{key}." until respond_to? "#{key}="
            send("#{key}=", value)
          end
        end

        def replace_vars(vars, target)
          if target.kind_of?(Array)
            target.each do |item|
              replace_vars(vars, item)
            end
          elsif target.kind_of?(Hash)
            target.each do |name, item|
              replace_vars(vars, item)
            end
          elsif target.kind_of?(String)
            vars.each do |k, v|
              pattern = "%#{k}%"
              target.gsub! pattern, v
            end
          elsif target.kind_of?(AbstractConfig)
            target.replace_vars!(vars)
          end
        end

        def replace_vars!(vars)
          instance_variables.each do |var_name|
            var = instance_variable_get(var_name)
            replace_vars(vars, var)
          end
        end
      end
    end
  end
end
