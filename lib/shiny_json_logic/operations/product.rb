require "shiny_json_logic/operations/base"
require "shiny_json_logic/numeric/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Product < Base
      include Numeric::WithErrorHandling
      protected

      def run
        safe_arithmetic do
          rules.map(&:to_f).reduce(:*)
        end
      end
    end
  end
end
