# frozen_string_literal: true

require "shiny_json_logic/errors/base"
require "shiny_json_logic/errors/not_a_number"
require "shiny_json_logic/errors/invalid_arguments"

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
        raise Errors::NotANumber
      end

      def handle_invalid_args
        raise Errors::InvalidArguments
      end
    end
  end
end