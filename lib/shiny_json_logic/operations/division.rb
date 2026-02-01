require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Division < Base
      include Numericals::WithErrorHandling
      protected

      def run
        return handle_no_operators if rules.empty?
        return handle_nil_operands if rules.any?(&:nil?)

        safe_arithmetic do
          self.rules = [1, *rules] if rules.size < 2

          numberified.reduce(:/)
        end
      end

      private

      def handle_nil_operands
        error = Errors::Base.new(type: "NaN")
        self.errors << error

        error.id
      end

      def handle_no_operators
        error = Errors::Base.new(type: "Invalid Arguments")
        self.errors << error

        error.id
      end

      def numberified
        rules.map do |rule|
          next rule.to_f if rule.is_a?(Numeric) || rule.is_a?(String)
          next 0 if rule == false
          next 1 if rule == true
        end
      end
    end
  end
end
