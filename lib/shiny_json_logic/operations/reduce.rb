# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Reduce < Iterable::Base
      include Numericals::WithErrorHandling
      raise_on_dynamic_args!

      def initialize(rules, scope_stack)
        # Capture initial accumulator before super (which may pre-process rules)
        initial_accumulator_rule = rules.is_a?(Array) ? rules[2] : nil
        super
        # Evaluate the initial accumulator value (third argument)
        @accumulator = Engine.new(initial_accumulator_rule, scope_stack).call
      end

      private

      attr_accessor :accumulator

      def on_before_each(item, index = 0)
        # For reduce, we need to create a special scope with current and accumulator
        # Push iterator context
        scope_stack.push({ "index" => index }, index: index)
        
        # Push item scope with current and accumulator
        reduce_scope = { "current" => item, "accumulator" => accumulator }
        scope_stack.push(reduce_scope, index: index)
      end

      def on_each(_item)
        self.accumulator = Engine.new(filter, scope_stack).call
      end

      def on_after(_results)
        safe_arithmetic do
          self.accumulator
        end
      end
    end
  end
end
