# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class If < Base
      extend Numericals::WithErrorHandling

      def self.call(rules, scope_stack)
        # Skip pre_process - spec requires static array, dynamic args should error
        return handle_invalid_args unless rules.is_a?(Array)

        rules.each_slice(2) do |condition_rule, value_rule|
          condition_result = Engine.call(condition_rule, scope_stack)
          return condition_result if value_rule.nil?

          next unless Truthy.call(condition_result)

          return Engine.call(value_rule, scope_stack)
        end

        nil
      end
    end
  end
end
