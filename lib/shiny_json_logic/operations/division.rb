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

        safe_arithmetic do
          nums = numerified
          return handle_nil_operands if nums.any?(&:nil?)

          nums = [1, *nums] if nums.size < 2
          nums.reduce(:/)
        end
      end

      private

      def handle_nil_operands
        error = Errors::Base.new(type: "NaN")
        self.errors << error

        error.id
      end
    end
  end
end
