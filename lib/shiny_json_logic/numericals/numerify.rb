# frozen_string_literal: true

module ShinyJsonLogic
  module Numericals
    module Numerify
      private

      def numerify(value)
        return value.to_f if value.is_a?(Numeric)
        return 0.0 if value == ""
        return value.to_f if value.is_a?(String) && numeric_string?(value)
        return 0 if value == false
        return 1 if value == true
        return nil if value.nil?

        raise TypeError, "Cannot convert #{value.inspect} to a number"
      end

      # Regex to match valid numeric strings (integers, floats, scientific notation)
      # Examples: "123", "-45.67", "+3.14", "1e10", "2.5E-3", ".5", "-.5"
      NUMERIC_REGEX = /\A[+-]?(?:\d+\.?\d*|\d*\.?\d+)(?:[eE][+-]?\d+)?\z/

      def numeric_string?(value)
        NUMERIC_REGEX.match?(value)
      end
    end
  end
end
