require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Division < Base
      include Numericals::WithErrorHandling
      protected

      def run
        safe_arithmetic do
          rules.map(&:to_f).reduce(:/)
        end
      end
    end
  end
end
