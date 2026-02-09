require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/comparisons/comparable"

module ShinyJsonLogic
  module Operations
    class Equal < Base
      include Numericals::WithErrorHandling
      include Comparisons::Comparable
      raise_on_dynamic_args!

      def call
        return handle_invalid_args if dynamic_args?
        operands = wrap_nil(rules)
        return handle_invalid_args if operands.length < 2

        first = evaluate(operands[0])
        operands[1..].each do |rule|
          curr = evaluate(rule)
          result = compare(first, curr)
          return handle_nan if result == :nan
          return false unless result == 0
        end
        true
      end
    end
  end
end
