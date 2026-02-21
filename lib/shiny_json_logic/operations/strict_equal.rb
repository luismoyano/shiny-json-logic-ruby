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
        return handle_invalid_args if operands.length < 2

        first = Comparisons::Comparable.cast(evaluate(operands[0], scope_stack))
        operands[1..].each do |rule|
          return false unless Comparisons::Comparable.cast(evaluate(rule, scope_stack)) == first
        end
        true
      end
    end
  end
end