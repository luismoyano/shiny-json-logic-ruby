require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"


module ShinyJsonLogic
  module Operations
    class Modulo < Base
      include Numericals::WithErrorHandling
      include Numericals::Numerify

      protected

      def run
        return handle_no_operators if rules.size < 2

        safe_arithmetic do
          numerified.reduce { |a, b| a.remainder(b) }
        end
      end
    end
  end
end
