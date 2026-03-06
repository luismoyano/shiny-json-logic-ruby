# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Product < Base
      extend Numericals::WithErrorHandling

      def self.execute(rules, scope_stack)
        operands = Utils::Array.wrap_nil(rules)
        return 1 if operands.empty?

        safe_arithmetic do
          result = nil
          count = 0
          i = 0
          n = operands.size

          while i < n
            evaluated = evaluate(operands[i], scope_stack)
            num = Numericals::Numerify.numerify(evaluated)
            num = 0 if num.nil?
            return handle_nan if num.nil?
            count += 1
            result = result.nil? ? num.to_f : result * num.to_f
            i += 1
          end

          return 1 if count == 0

          result
        end
      end
    end
  end
end
