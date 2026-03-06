# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Reduce < Iterable::Base
      extend Numericals::WithErrorHandling
      raise_on_dynamic_args!

      def self.call(rules, scope_stack)
        rules = resolve_rules(rules, scope_stack)

        collection, filter = setup_collection(rules, scope_stack)

        # Evaluate initial accumulator (third argument)
        accumulator = Engine.call(rules[2], scope_stack)

        reduce_scope = { "current" => nil, "accumulator" => nil }

        collection.each do |item|
          reduce_scope["current"] = item
          reduce_scope["accumulator"] = accumulator
          scope_stack.push(reduce_scope)
          begin
            accumulator = Engine.call(filter, scope_stack)
          ensure
            scope_stack.pop
          end
        end

        safe_arithmetic { accumulator }
      end
    end
  end
end
