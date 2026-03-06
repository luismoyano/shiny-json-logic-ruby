# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/utils/data_hash"
require "shiny_json_logic/utils/hash_fetch"

module ShinyJsonLogic
  module Operations
    class Val < Base
      def self.execute(rules, scope_stack)
        raw_keys = Utils::Array.wrap_nil(rules)

        # {"val": []} or {"val": null} - return current scope
        if raw_keys.empty? || raw_keys == [nil]
          return Utils::DataHash.wrap(scope_stack.current)
        end

        # Check if first element is an array (scope navigation syntax)
        first_key = raw_keys.first

        if first_key.is_a?(Array) && scope_stack
          level_indicator = first_key.first.to_i
          remaining_keys = raw_keys[1..]

          evaluated_keys = remaining_keys.map { |rule| evaluate(rule, scope_stack) }

          levels = level_indicator.abs
          return Utils::DataHash.wrap(scope_stack.resolve(levels, *evaluated_keys))
        end

        # Normal case: {"val": "key"} or {"val": ["key1", "key2"]}
        keys = raw_keys.map { |rule| evaluate(rule, scope_stack) }
        current_data = scope_stack.current
        Utils::DataHash.wrap(dig_value(current_data, keys))
      end

      def self.dig_value(data, keys)
        return nil if data.nil?
        return data if keys.empty?

        keys.reduce(data) do |obj, key|
          return nil if obj.nil?
          Utils::HashFetch.fetch(obj, key.to_s)
        end
      end
      private_class_method :dig_value
    end
  end
end
