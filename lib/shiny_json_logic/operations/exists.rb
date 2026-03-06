# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Exists < Base
      def self.execute(rules, scope_stack)
        current = scope_stack.current
        operands = Utils::Array.wrap_nil(rules)
        i = 0
        n = operands.size
        while i < n
          segment = evaluate(operands[i], scope_stack)
          return false unless current.is_a?(Hash) && current.key?(segment)
          current = current[segment]
          i += 1
        end
        true
      end
    end
  end
end
