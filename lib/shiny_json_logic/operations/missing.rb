# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Missing < Base
      def self.execute(rules, scope_stack)
        items = Utils::Array.wrap_nil(rules)
        keys = []
        items.each do |rule|
          evaluated = evaluate(rule, scope_stack)
          keys.concat(Utils::Array.wrap_nil(evaluated).map(&:to_s))
        end
        current_data = scope_stack.current
        return keys unless current_data.is_a?(Hash)

        keys - deep_keys(current_data)
      end

      def self.deep_keys(hash, prefix = nil)
        return unless hash.is_a?(Hash)

        result = []
        hash.each do |key, val|
          key_s = key.to_s
          full_key = prefix ? "#{prefix}.#{key_s}" : key_s
          nested = deep_keys(val, full_key)
          if nested
            result.concat(nested)
          else
            result << full_key
          end
        end
        result
      end
      private_class_method :deep_keys
    end
  end
end
