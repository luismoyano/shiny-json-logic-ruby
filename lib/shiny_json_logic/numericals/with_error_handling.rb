module ShinyJsonLogic
  module Numericals
    module WithErrorHandling
      def safe_arithmetic(&block)
        result = yield
        result.tap do |res|
          handle_invalid_operand if res.to_f.nan? || res == Float::INFINITY || res == -Float::INFINITY
        end
      rescue TypeError
        handle_invalid_operand
      end

      def handle_invalid_operand
        self.data["type"] = "NaN"
        error = ShinyJsonLogic::Errors::Base.new(type: "NaN")
        errors.push error
        return error.id
      end

      def handle_no_operators
        error = Errors::Base.new(type: "Invalid Arguments")
        self.errors << error

        error.id
      end
    end
  end
end