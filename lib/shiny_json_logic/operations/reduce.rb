require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Reduce < Iterable::Base
      include Numericals::WithErrorHandling
      raise_on_dynamic_args!

      def initialize(context)
        super

        # Evaluate the initial accumulator value (third argument)
        @accumulator = Engine.new(context.dig("rules", 2), scope_stack).call
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
        engine = Engine.new(filter, scope_stack)
        self.accumulator = engine.call
        [self.accumulator, engine]
      end

      def on_after(_results)
        safe_arithmetic do
          self.accumulator
        end
      end
    end
  end
end
