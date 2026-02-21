# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/missing"

module ShinyJsonLogic
  module Operations
    class MissingSome < Missing
      def self.execute(rules, scope_stack)
        min_required = evaluate(rules[0], scope_stack)
        keys = Utils::Array.wrap_nil(evaluate(rules[1], scope_stack)).map(&:to_s)
        current_data = scope_stack.current
        return keys unless current_data.is_a?(Hash) && rules.is_a?(Array)

        data_keys = current_data.keys.map(&:to_s)
        present = keys & data_keys
        present.size >= min_required ? [] : Missing.execute(keys, scope_stack)
      end
    end
  end
end
