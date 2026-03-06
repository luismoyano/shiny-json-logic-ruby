# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/comparisons/comparable"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class StrictEqual < Base
      extend Numericals::WithErrorHandling
      raise_on_dynamic_args!

      def self.execute(rules, scope_stack)
        operands = Utils::Array.wrap_nil(rules)
        n = operands.length
        return handle_invalid_args if n < 2

        first = Comparisons::Comparable.cast(evaluate(operands[0], scope_stack))
        i = 1
        while i < n
          return false unless Comparisons::Comparable.cast(evaluate(operands[i], scope_stack)) == first
          i += 1
        end
        true
      end
    end
  end
end