require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Subtraction < Base
      include Numericals::WithErrorHandling
      include Numericals::Numerify

      protected

      def run
        return handle_no_operators if rules.empty?

        safe_arithmetic do
          result = nil
          count = 0

          each_operand do |num|
            count += 1
            result = result.nil? ? num : result - num
          end

          return handle_no_operators if count == 0
          return result * -1 if count == 1

          result
        end
      end

      private

      def each_operand
        rules.each do |rule|
          evaluated = evaluate(rule)
          yield numerify(evaluated)
        end
      end

      def numerify(value)
        val = super
        return 0 if val.nil?
        val
      end
    end
  end
end
