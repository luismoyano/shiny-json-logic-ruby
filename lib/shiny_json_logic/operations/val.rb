# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/utils/data_hash"
require "shiny_json_logic/utils/hash_fetch"

module ShinyJsonLogic
  module Operations
    class Val < Base
      def self.execute(rules, scope_stack)
        # Fast path: null or empty → return current scope
        if rules.nil?
          return Utils::DataHash.wrap(scope_stack.current)
        end

        # Fast path: single string key (most common case)
        if rules.is_a?(String)
          return Utils::DataHash.wrap(Utils::HashFetch.fetch(scope_stack.current, rules))
        end

        raw_keys = Utils::Array.wrap_nil(rules)

        # {"val": []} - return current scope
        if raw_keys.empty? || raw_keys == [nil]
          return Utils::DataHash.wrap(scope_stack.current)
        end

        # Check if first element is an array (scope navigation syntax)
        first_key = raw_keys.first

        if first_key.is_a?(Array) && scope_stack
          level_indicator = first_key.first.to_i
          evaluated_keys = []
          i = 1
          n = raw_keys.length
          while i < n
            evaluated_keys << evaluate(raw_keys[i], scope_stack)
            i += 1
          end

          levels = level_indicator.abs
          return Utils::DataHash.wrap(scope_stack.resolve(levels, *evaluated_keys))
        end

        # Normal case: {"val": ["key1", "key2"]}
        keys_n = raw_keys.size
        keys = Array.new(keys_n)
        ki = 0
        while ki < keys_n
          keys[ki] = evaluate(raw_keys[ki], scope_stack)
          ki += 1
        end
        current_data = scope_stack.current
        Utils::DataHash.wrap(dig_value(current_data, keys))
      end

      def self.dig_value(data, keys)
        return nil if data.nil?
        return data if keys.empty?

        obj = data
        i = 0
        n = keys.size
        while i < n
          return nil if obj.nil?
          obj = Utils::HashFetch.fetch(obj, keys[i].to_s)
          i += 1
        end
        obj
      end
      private_class_method :dig_value
    end
  end
end
