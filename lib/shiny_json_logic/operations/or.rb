# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Or < Base
      include Numericals::WithErrorHandling
      raise_on_dynamic_args!

      def call
        return handle_invalid_args if dynamic_args?
        return handle_invalid_args unless rules.is_a?(Array)
        return false if rules.empty?

        result = nil
        rules.each do |rule|
          result = evaluate(rule)
          return result if Truthy.call(result)
        end
        result
      end
    end
  end
end