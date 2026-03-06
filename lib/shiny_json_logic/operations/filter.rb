# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Filter < Iterable::Base
      raise_on_nil_filter!
      raise_on_dynamic_args!

      def self.call(rules, scope_stack)
        rules = resolve_rules(rules, scope_stack)
        filter = setup_filter(rules)
        collection = setup_collection(rules, scope_stack)

        collection.each_with_object([]) do |item, acc|
          scope_stack.push(item)
          begin
            acc << item if Truthy.call(Engine.call(filter, scope_stack))
          ensure
            scope_stack.pop
          end
        end
      end
    end
  end
end
