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

        result = fetch_value(data, key)
        result.nil? ? default : result
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
            # Check if key exists (string or symbol) and return value
            if current.key?(k)
              current[k]
            elsif current.key?(k.to_sym)
              current[k.to_sym]
            else
              nil
            end
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

