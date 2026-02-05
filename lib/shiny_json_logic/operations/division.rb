require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Division < Base
      include Numericals::WithErrorHandling
      include Numericals::Numerify

      protected

      def run
        return handle_no_operators if rules.empty?

        result = nil
        count = 0

        begin
          each_operand do |num|
            return handle_nan if num.nil?
            count += 1
            result = result.nil? ? num : result / num
          end
        rescue TypeError
          return handle_invalid_operand
        end

        return handle_no_operators if count == 0

        final_result = count == 1 ? 1.0 / result : result

        safe_arithmetic { final_result }
      end

      private

      def each_operand
        rules.each do |rule|
          evaluated = evaluate(rule)
          yield numerify(evaluated)
        end
      end

      def handle_nan
        error = Errors::Base.new(type: "NaN")
        self.errors << error
        error.id
      end
    end
  end
end
