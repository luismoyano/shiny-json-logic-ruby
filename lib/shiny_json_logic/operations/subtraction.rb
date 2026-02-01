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
        safe_arithmetic do
          return numerified.first * -1 if rules.size == 1

          numerified.reduce(:-)
        end
      end

      private

      def numerify(value)
        val = super
        return 0 if val.nil?

        val
      end
    end
  end
end
