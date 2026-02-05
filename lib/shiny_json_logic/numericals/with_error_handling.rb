module ShinyJsonLogic
  module Numericals
    module WithErrorHandling
      def safe_arithmetic(&block)
        result = yield
        if result.to_f.nan? || result == Float::INFINITY || result == -Float::INFINITY
          return handle_invalid_operand
        end
        result
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