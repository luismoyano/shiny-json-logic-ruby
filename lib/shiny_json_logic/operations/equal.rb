require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Equal < Base
      protected

      def run
        first = normalize(evaluate(rules[0]))
        rules[1..].each do |rule|
          return false unless normalize(evaluate(rule)) == first
        end
        true
      end

      private

      def normalize(value)
        return value.to_f if value.is_a?(Numeric)
        return value.to_f if value.is_a?(String) && numeric?(value)

        value.to_s
      end

      def numeric?(str)
        Float(str)
        true
      rescue ArgumentError, TypeError
        false
      end
    end
  end
end