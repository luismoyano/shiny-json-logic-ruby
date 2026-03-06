# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Subtraction < Base
      extend Numericals::WithErrorHandling

      def self.execute(rules, scope_stack)
        operands = Utils::Array.wrap_nil(rules)
        return handle_invalid_args if operands.empty?

        safe_arithmetic do
          result = nil
          count = 0
          i = 0
          n = operands.size

          while i < n
            evaluated = evaluate(operands[i], scope_stack)
            num = Numericals::Numerify.numerify(evaluated)
            num = 0 if num.nil?
            count += 1
            result = result.nil? ? num : result - num
            i += 1
          end

          return handle_invalid_args if count == 0
          return result * -1 if count == 1

          result
        end
      end
    end
  end
end
