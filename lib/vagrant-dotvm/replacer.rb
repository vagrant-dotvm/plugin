module VagrantPlugins
  module Dotvm
    class Replacer
      def initialize
        @limit = 10
      end

      def on(target)
        @target = target
        self
      end

      def using(vars)
        @vars = vars
        self
      end

      def limit(limit)
        @limit = limit
        self
      end

      def result
        0.upto(@limit).each do |_|
          @replaced = 0
          target = _replace_vars @target
          return target if @replaced == 0
        end

        fail 'Too deep variables relations, possible recurrence.'
      end

      private

      def process_string(target)
        @vars.each do |k, v|
          pattern = "%#{k}%"
          next unless target.include? pattern

          @replaced += 1

          if target == pattern
            target = v
            break unless v.is_a? String # value is no longer string, so replace cannot be performed
          else
            unless v.respond_to? :to_s
              fail 'Non-string values cannot be joined together.'
            end

            target = target.gsub pattern, v.to_s
          end
        end

        target
      end

      def _replace_vars(target)
        case target
        when Hash
          target.each do |k, v|
            target[k] = _replace_vars v
          end
        when Array
          target.map! do |v|
            _replace_vars v
          end
        when String
          target = process_string target
        end

        target
      end
    end
  end
end
