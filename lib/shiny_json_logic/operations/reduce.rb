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

        collection.each_with_index do |item, index|
          scope_stack.push({ "index" => index }, index: index)
          reduce_scope = { "current" => item, "accumulator" => accumulator }
          scope_stack.push(reduce_scope, index: index)
          begin
            accumulator = Engine.call(filter, scope_stack)
            scope_stack.pop
            scope_stack.pop
          rescue => e
            scope_stack.pop
            scope_stack.pop
            raise e
          end
        end

        safe_arithmetic { accumulator }
      end
    end
  end
end
