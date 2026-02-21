# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Division < Base
      extend Numericals::WithErrorHandling

      def self.execute(rules, scope_stack)
        operands = Utils::Array.wrap_nil(rules)
        return handle_invalid_args if operands.empty?

        result = nil
        count = 0

        begin
          operands.each do |rule|
            evaluated = evaluate(rule, scope_stack)
            num = Numericals::Numerify.numerify(evaluated)
            return handle_nan if num.nil?
            count += 1
            result = result.nil? ? num : result / num
          end
        rescue TypeError
          return handle_nan
        end

        return handle_invalid_args if count == 0

        final_result = count == 1 ? 1.0 / result : result

        safe_arithmetic { final_result }
      end
    end
  end
end
