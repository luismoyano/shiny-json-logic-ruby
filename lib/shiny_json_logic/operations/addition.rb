# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Addition < Base
      extend Numericals::WithErrorHandling

      def self.execute(rules, scope_stack)
        safe_arithmetic do
          operands = Utils::Array.wrap_nil(rules)
          result = 0.0
          i = 0
          n = operands.size
          while i < n
            val = Numericals::Numerify.numerify(evaluate(operands[i], scope_stack))
            result += val.nil? ? 0 : val
            i += 1
          end
          result
        end
      end
    end
  end
end
