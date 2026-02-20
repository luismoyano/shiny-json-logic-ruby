# frozen_string_literal: true

require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Preserve < Iterable::Base
      def initialize(rules, scope_stack)
        @collection = wrap(rules) || []
        # Skip Iterable::Base initialization, go directly to Operations::Base
        # Preserve doesn't need the standard iterable setup (filter, collection from rules[0], etc.)
        @rules = rules
        @scope_stack = scope_stack
      end

      private

      def on_each(item)
        Engine.new(item, scope_stack).call
      end

      def on_after(results)
        return results.first if results.size == 1

        results
      end

      # Preserve doesn't create new scopes - it just evaluates expressions
      def on_before_each(_item, _index = 0)
        # Don't push to scope stack
      end

      def on_after_each
        # Don't pop from scope stack
      end
    end
  end
end
