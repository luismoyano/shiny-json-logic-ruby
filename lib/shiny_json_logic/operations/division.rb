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
        return handle_nil_operands if rules.any?(&:nil?)

        safe_arithmetic do
          self.rules = [1, *rules] if rules.size < 2

          numerified.reduce(:/)
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
