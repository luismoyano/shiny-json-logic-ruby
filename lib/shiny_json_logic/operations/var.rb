require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Var < Base
      def call
        items = wrap_nil(rules)
        key = evaluate(items[0])
        default = items[1] ? evaluate(items[1]) : nil

        return data if key.nil? || key == ""

        fetch_value(data, key) || default
      rescue
        default || data
      end

      private

      def fetch_value(obj, key)
        return nil if obj.nil?
        
        # Split dot-separated keys
        keys = key.to_s.split('.')
        
        keys.reduce(obj) do |current, k|
          return nil if current.nil?
          
          if current.is_a?(Hash)
            # Try string key first, then symbol key for indifferent access
            result = current[k]
            result = current[k.to_sym] if result.nil? && !current.key?(k)
            result
          elsif current.is_a?(Array)
            current[k.to_i]
          else
            nil
          end
        end
      end
    end
  end
end

