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

      def numeric_string?(value)
        Float(value)
        true
      rescue ArgumentError
        false
      end
    end
  end
end
