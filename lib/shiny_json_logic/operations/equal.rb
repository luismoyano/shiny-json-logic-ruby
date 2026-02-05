require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Equal < Base
      include Numericals::WithErrorHandling
      include Numericals::Numerify

      protected

      def run
        operands = Array.wrap_nil(rules)
        return handle_invalid_args if operands.length < 2

        first = evaluate(operands[0])
        operands[1..].each do |rule|
          curr = evaluate(rule)
          result = compare(first, curr)
          return handle_nan if result == :nan
          return false unless result == 0
        end
        true
      end

      private

      def compare(a, b)
        # Arrays u objetos → NaN
        return :nan if a.is_a?(Array) || a.is_a?(Hash) || b.is_a?(Array) || b.is_a?(Hash)

        # Ambos strings → comparación directa
        if a.is_a?(String) && b.is_a?(String)
          return a <=> b
        end

        # Convertir a números para comparar
        num_a = numerify_for_compare(a)
        num_b = numerify_for_compare(b)
        return :nan if num_a.nil? || num_b.nil?

        num_a <=> num_b
      end

      def numerify_for_compare(value)
        return value.to_f if value.is_a?(Numeric)
        return 0.0 if value == false
        return 1.0 if value == true
        return 0.0 if value.nil?
        return value.to_f if value.is_a?(String) && numeric_string?(value)
        nil # String no numérica
      end
    end
  end
end