require "shiny_json_logic/errors/base"

module ShinyJsonLogic
  module Numericals
    module WithErrorHandling
      def safe_arithmetic(&block)
        result = yield
        if result.to_f.nan? || result == Float::INFINITY || result == -Float::INFINITY
          return handle_nan
        end
        result
      rescue TypeError
        handle_nan
      end

      def handle_nan
        error = ShinyJsonLogic::Errors::Base.new(type: "NaN")
        raise error
      end

      def handle_invalid_args
        error = ShinyJsonLogic::Errors::Base.new(type: "Invalid Arguments")
        raise error
      end

      # Alias for backward compatibility
      alias_method :handle_invalid_operand, :handle_nan
      alias_method :handle_no_operators, :handle_invalid_args
    end
  end
end