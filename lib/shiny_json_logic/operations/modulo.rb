require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"


module ShinyJsonLogic
  module Operations
    class Modulo < Base
      include Numericals::WithErrorHandling

      protected

      def run
        safe_arithmetic do
          rules.reduce(:%)
        end
      end
    end
  end
end
