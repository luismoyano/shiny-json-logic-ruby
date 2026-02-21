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

      def self.deep_keys(hash)
        return unless hash.is_a?(Hash)

        hash.keys.map { |key| ([key.to_s] << deep_keys(hash[key])).compact.join(".") }
      end
      private_class_method :deep_keys
    end
  end
end
