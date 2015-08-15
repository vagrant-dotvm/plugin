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
              replaced+=1 unless (target.gsub! pattern, v).kind_of?(NilClass)
            end
          elsif target.kind_of?(AbstractConfig)
            replaced += target.replace_vars!(vars)
          end

          replaced
        end

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
