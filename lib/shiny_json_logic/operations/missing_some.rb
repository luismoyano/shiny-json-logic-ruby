# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/missing"

module ShinyJsonLogic
  module Operations
    class MissingSome < Missing
      def self.execute(rules, scope_stack)
        min_required = evaluate(rules[0], scope_stack)
        raw_keys = evaluate(rules[1], scope_stack)
        raw_keys_arr = wrap_nil(raw_keys)
        keys = Array.new(raw_keys_arr.size)
        i = 0
        n = raw_keys_arr.size
        while i < n
          keys[i] = raw_keys_arr[i].to_s
          i += 1
        end

        current_data = scope_stack.last
        return keys unless current_data.is_a?(Hash) && rules.is_a?(Array)

        present = keys.select { |key| present?(current_data, key) }
        present.size >= min_required ? [] : keys - present
      end
    end
  end
end
