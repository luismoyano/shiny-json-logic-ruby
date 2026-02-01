require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/numerify"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Addition < Base
      include Numericals::WithErrorHandling
      include Numericals::Numerify

      protected

      def run

        safe_arithmetic do
          return 0 if numerified.empty?

          numerified.reduce(:+)
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
