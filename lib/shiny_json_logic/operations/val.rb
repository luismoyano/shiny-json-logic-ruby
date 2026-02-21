# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Val < Base
      def self.execute(rules, scope_stack)
        raw_keys = Utils::Array.wrap_nil(rules)

        # {"val": []} or {"val": null} - return current scope
        if raw_keys.empty? || raw_keys == [nil]
          return scope_stack.current
        end

        # Check if first element is an array (scope navigation syntax)
        first_key = raw_keys.first

        if first_key.is_a?(Array) && scope_stack
          level_indicator = first_key.first.to_i
          remaining_keys = raw_keys[1..]

          evaluated_keys = remaining_keys.map { |rule| evaluate(rule, scope_stack) }

          levels = level_indicator.abs
          return scope_stack.resolve(levels, *evaluated_keys)
        end

        # Normal case: {"val": "key"} or {"val": ["key1", "key2"]}
        keys = raw_keys.map { |rule| evaluate(rule, scope_stack) }
        current_data = scope_stack.current
        dig_value(current_data, keys)
      end

      def self.dig_value(data, keys)
        return nil if data.nil?
        return data if keys.empty?

        keys.reduce(data) do |obj, key|
          return nil if obj.nil?

          if obj.is_a?(Hash)
            obj[key.to_s]
          elsif obj.is_a?(Array)
            index = key.is_a?(String) ? key.to_i : key
            obj[index]
          else
            nil
          end
        end
      end
      private_class_method :dig_value
    end
  end
end
