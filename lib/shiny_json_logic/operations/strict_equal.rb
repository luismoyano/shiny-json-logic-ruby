require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class StrictEqual < Base
      protected

      def run
        first = cast(evaluate(rules[0]))
        rules[1..].each do |rule|
          return false unless cast(evaluate(rule)) == first
        end
        true
      end

      private

      def cast(value)
        value.is_a?(Numeric) ? value.to_f : value
      end
    end
  end
end