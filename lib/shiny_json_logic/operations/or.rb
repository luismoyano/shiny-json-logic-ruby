# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Or < Base
      extend Numericals::WithErrorHandling
      raise_on_dynamic_args!

      def self.execute(rules, scope_stack)
        return handle_invalid_args unless rules.is_a?(Array)
        return false if rules.empty?

        result = nil
        rules.each do |rule|
          result = evaluate(rule, scope_stack)
          return result if Truthy.call(result)
        end
        result
      end
    end
  end
end