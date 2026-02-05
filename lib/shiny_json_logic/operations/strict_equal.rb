require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class StrictEqual < Base
      include Numericals::WithErrorHandling

      protected

      def run
        operands = Array.wrap_nil(rules)
        return handle_invalid_args if operands.length < 2

        first = cast(evaluate(operands[0]))
        operands[1..].each do |rule|
          return false unless cast(evaluate(rule)) == first
        end
        true
      end

      private

      def cast(value)
        value.is_a?(Numeric) ? value.to_f : value
      end
    end
  end
end