require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class If < Base
      include Numericals::WithErrorHandling

      # Skip pre_process - spec requires static array, dynamic args should error
      def initialize(context)
        @context = context
        @rules, @errors, @scope_stack = context.values_at("rules", "errors", "scope_stack")
      end

      protected

      def run
        return handle_invalid_args unless rules.is_a?(Array)

        rules.each_slice(2) do |condition_rule, value_rule|
          condition_result = evaluate(condition_rule)
          return condition_result if error?(condition_result)
          return condition_result if value_rule.nil?

          next unless Truthy.call(condition_result)

          value_result = evaluate(value_rule)
          return value_result if error?(value_result)
          return value_result
        end

        nil
      end

      private

      def evaluate(rule)
        engine = Engine.new(rule, scope_stack)
        result = engine.call
        self.errors = [*errors, *engine.errors] if error?(result)
        result
      end

      def error?(result)
        result.is_a?(String) && result.match?(Try::SHINY_ERROR_PATTERN)
      end
    end
  end
end
