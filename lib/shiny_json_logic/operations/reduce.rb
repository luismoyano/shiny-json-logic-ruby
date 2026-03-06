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
        filter = setup_filter(rules)
          collection = setup_collection(rules, scope_stack)

          accumulator = Engine.call(rules[2], scope_stack)

          reduce_scope = { "current" => nil, "accumulator" => nil }
          scope_stack << reduce_scope

          begin
            i = 0
            n = collection.size
            while i < n
              reduce_scope["current"] = collection[i]
              reduce_scope["accumulator"] = accumulator
              accumulator = Engine.call(filter, scope_stack)
              i += 1
            end
          ensure
            scope_stack.pop
          end

        safe_arithmetic { accumulator }
      end
    end
  end
end
