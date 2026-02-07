require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class StrictDifferent < Base
      include Numericals::WithErrorHandling
      raise_on_dynamic_args!

      protected

      def run
        return handle_invalid_args if dynamic_args?
        operands = Array.wrap_nil(rules)
        return handle_invalid_args if operands.length < 2

        prev = cast(evaluate(operands[0]))
        operands[1..].each do |rule|
          curr = cast(evaluate(rule))
          return false if curr == prev  # Si son iguales, !== es false
          prev = curr
        end
        true  # Todos los pares consecutivos son diferentes
      end

      private

      def cast(value)
        value.is_a?(Numeric) ? value.to_f : value
      end
    end
  end
end