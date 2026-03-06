# frozen_string_literal: true

require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    module Iterable
      class Base < Operations::Base
        def self.raise_on_nil_filter!
          @raise_on_nil_filter = true
        end

        def self.raise_on_nil_filter?
          @raise_on_nil_filter
        end

        def self.setup_filter(rules)
          raise Errors::InvalidArguments unless rules.is_a?(Array)
          filter = rules[1]
          raise Errors::InvalidArguments if filter.nil? && raise_on_nil_filter?
          filter
        end

        def self.setup_collection(rules, scope_stack)
          collection_rule = rules.size > 0 ? rules[0] : rules
          raise Errors::InvalidArguments if collection_rule.nil?
          Utils::Array.wrap(Engine.call(collection_rule, scope_stack))
        end

        def self.call(rules, scope_stack)
          rules = resolve_rules(rules, scope_stack)
          filter = setup_filter(rules)
          collection = setup_collection(rules, scope_stack)

          early = catch(:early_return) do
            results = []
            i = 0
            n = collection.size
            while i < n
              item = collection[i]
              scope_stack.push(item)
              begin
                results << on_each(item, filter, scope_stack)
              ensure
                scope_stack.pop
              end
              i += 1
            end
            on_after(results, scope_stack)
          end
          early
        end

        def self.on_each(_item, filter, scope_stack)
          Engine.call(filter, scope_stack)
        end

        def self.on_after(results, _scope_stack)
          results
        end
      end
    end
  end
end
