require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Addition < Base
      include Numericals::WithErrorHandling
      include Numericals::Numerify

      protected

      def run
        safe_arithmetic do
          result = 0.0
          count = 0

          each_operand do |num|
            count += 1
            result = result + num
          end

          result
        end
      end

      private

      def each_operand
        Array.wrap_nil(rules).each do |rule|
          Array.wrap_nil(evaluate(rule)).each do |val|
            yield numerify(val)
          end
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
