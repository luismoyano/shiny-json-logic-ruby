require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Division < Base
      include Numericals::WithErrorHandling
      protected

      def run
        return handle_no_operators if rules.empty?
        safe_arithmetic do
          self.rules = [1, *rules] if rules.size < 2

          rules.map(&:to_f).reduce(:/)
        end
      end

      private

      def handle_no_operators
        error = Errors::Base.new(type: "Invalid Arguments")
        self.errors << error

        error.id
      end
    end
  end
end
