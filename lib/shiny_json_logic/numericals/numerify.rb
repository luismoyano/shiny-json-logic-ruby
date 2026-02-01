module ShinyJsonLogic
  module Numericals
    module Numerify
      def numerified
        @numerified ||=
          rules.map do |rule|
            numerify(rule)
          end
      end

      private

      def numerify(value)
        return value.to_f if value.is_a?(Numeric)
        return 0.0 if value == ""
        return value.to_f if value.is_a?(String) && value.match?(/\A[+-]?\d*.?\d+\z/)
        return 0 if value == false
        return 1 if value == true
        return nil if value.nil?

        raise TypeError, "Cannot convert #{value.inspect} to a number"
      end
    end
  end
end