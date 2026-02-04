require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Equal < Base
      protected

      def run
        first = normalize(rules[0])
        rules.all? { |r| normalize(r) == first }
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