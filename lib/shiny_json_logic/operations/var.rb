# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"
require "shiny_json_logic/utils/data_hash"
require "shiny_json_logic/utils/hash_fetch"

module ShinyJsonLogic
  module Operations
    class Var < Base
      def self.execute(rules, scope_stack)
        # Fast path: simple string key, no default
        if rules.is_a?(String)
          current_data = scope_stack.current
          if rules.empty?
            return Utils::DataHash.wrap(current_data)
          end
          return Utils::DataHash.wrap(fetch_value(current_data, rules))
        end

        items = Utils::Array.wrap_nil(rules)
        key = evaluate(items[0], scope_stack)
        default = items.length > 1 ? evaluate(items[1], scope_stack) : nil
        current_data = scope_stack.current

        if key.nil? || key == ""
          return Utils::DataHash.wrap(current_data)
        end

        result = fetch_value(current_data, key)
        result = result.nil? ? default : result
        Utils::DataHash.wrap(result)
      rescue
        default || scope_stack.current
      end

      def self.fetch_value(obj, key)
        return nil if obj.nil?

        key_s = key.is_a?(String) ? key : key.to_s

        # Fast path: no dot notation
        dot_idx = key_s.index(".")
        unless dot_idx
          return Utils::HashFetch.fetch(obj, key_s)
        end

        # Dot notation: scan without split
        current = obj
        start = 0
        len = key_s.length
        while start < len
          dot_idx = key_s.index(".", start)
          segment = dot_idx ? key_s[start, dot_idx - start] : key_s[start, len - start]
          return nil if current.nil?
          current = Utils::HashFetch.fetch(current, segment)
          break unless dot_idx
          start = dot_idx + 1
        end
        current
      end
      private_class_method :fetch_value
    end
  end
end

