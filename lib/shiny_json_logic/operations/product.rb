require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Product < Base
      include Numericals::WithErrorHandling
      include Numericals::Numerify

      protected

      def run
        return 1 if rules.empty?

        safe_arithmetic do
          numerified.map(&:to_f).reduce(:*)
        end
      end
    end
  end
end
