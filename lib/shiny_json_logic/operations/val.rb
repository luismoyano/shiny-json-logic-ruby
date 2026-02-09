require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Val < Base
      def call
        raw_keys = Array.wrap_nil(rules)
        
        # {"val": []} or {"val": null} - return current scope
        if raw_keys.empty? || raw_keys == [nil]
          return scope_stack ? scope_stack.current : data
        end

        # Check if first element is an array (scope navigation syntax)
        # {"val": [[N], "key"]} - scope navigation
        first_key = raw_keys.first
        
        if first_key.is_a?(Array) && scope_stack
          level_indicator = first_key.first.to_i
          remaining_keys = raw_keys[1..]
          
          # Evaluate any remaining keys that might be operations
          evaluated_keys = remaining_keys.map { |rule| evaluate(rule) }
          
          # Both positive and negative numbers mean "go up N levels"
          # [[2], "key"] = go up 2 levels
          # [[-2], "key"] = go up 2 levels (same as above)
          levels = level_indicator.abs
          return scope_stack.resolve(levels, *evaluated_keys)
        end

        # Normal case: {"val": "key"} or {"val": ["key1", "key2"]}
        keys = raw_keys.map { |rule| evaluate(rule) }
        current_data = scope_stack ? scope_stack.current : data
        dig_value(current_data, keys)
      end

      private

      def dig_value(data, keys)
        return nil if data.nil?
        return data if keys.empty?
        
        keys.reduce(data) do |obj, key|
          return nil if obj.nil?
          
          result = if obj.is_a?(Hash)
            obj[key]
          elsif obj.is_a?(Array)
            # Convert string keys to integers for arrays
            index = key.is_a?(String) ? key.to_i : key
            obj[index]
          else
            nil
          end

          # Wrap nested hashes for indifferent access
          result.is_a?(Hash) && !result.is_a?(IndifferentHash) ? IndifferentHash.new(result) : result
        end
      end
    end
  end
end
