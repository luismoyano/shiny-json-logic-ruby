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

        current_data = scope_stack.current
        return keys unless current_data.is_a?(Hash) && rules.is_a?(Array)

        data_keys = current_data.keys
        data_keys_s = Array.new(data_keys.size)
        j = 0
        m = data_keys.size
        while j < m
          data_keys_s[j] = data_keys[j].to_s
          j += 1
        end
        present = keys & data_keys_s
        present.size >= min_required ? [] : keys - present
      end
    end
  end
end
