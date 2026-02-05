require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Product < Base
      include Numericals::WithErrorHandling
      include Numericals::Numerify

      protected

      def run
        operands = Array.wrap_nil(rules)
        return 1 if operands.empty?

        safe_arithmetic do
          result = nil
          count = 0

          each_operand(operands) do |num|
            return handle_nan if num.nil?
            count += 1
            result = result.nil? ? num.to_f : result * num.to_f
          end

          return 1 if count == 0

          result
        end
      end

      private

      def each_operand(operands)
        operands.each do |rule|
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
