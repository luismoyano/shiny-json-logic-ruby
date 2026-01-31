require "shiny_json_logic/operations/base"
require "shiny_json_logic/numeric/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Subtraction < Base
      include Numeric::WithErrorHandling

      protected

      def run
        safe_arithmetic do
          return rules.first.to_f * -1 if rules.size == 1
          rules.map(&:to_f).reduce(:-)
        end
      end
    end
  end
end
