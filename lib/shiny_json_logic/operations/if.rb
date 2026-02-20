# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class If < Base
      include Numericals::WithErrorHandling

      # Skip pre_process - spec requires static array, dynamic args should error
      def initialize(rules, scope_stack)
        @rules = rules
        @scope_stack = scope_stack
      end

      def call
        return handle_invalid_args unless rules.is_a?(Array)

        rules.each_slice(2) do |condition_rule, value_rule|
          condition_result = evaluate(condition_rule)
          return condition_result if value_rule.nil?

          next unless Truthy.call(condition_result)

          return evaluate(value_rule)
        end

        nil
      end

      private

      def evaluate(rule)
        Engine.new(rule, scope_stack).call
      end
    end
  end
end
