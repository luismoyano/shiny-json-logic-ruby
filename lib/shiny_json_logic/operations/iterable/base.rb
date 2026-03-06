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

        def self.call(rules, scope_stack)
          rules = resolve_rules(rules, scope_stack)

          collection, filter = setup_collection(rules, scope_stack)

          index_scope = { "index" => 0 }
          on_before(scope_stack)
          results = collection.each_with_index.each_with_object([]) do |(item, index), acc|
            index_scope["index"] = index
            scope_stack.push(index_scope, index: index)
            scope_stack.push(item, index: index)
            begin
              solved = on_each(item, filter, scope_stack)
              acc << solved
              scope_stack.pop
              scope_stack.pop
            rescue => e
              scope_stack.pop  # item scope
              scope_stack.pop  # iterator context scope
              raise e
            end
          end
          on_after(results, scope_stack)
        end

        def self.setup_collection(rules, scope_stack)
          return handle_nil unless rules.is_a?(Array)

          filter = rules[1]
          return handle_nil if filter.nil? && raise_on_nil_filter?

          collection_rule = rules.any? ? rules[0] : rules
          return handle_nil if collection_rule.nil?

          collection = Utils::Array.wrap(Engine.call(collection_rule, scope_stack))
          [collection, filter]
        end

        def self.on_before(_scope_stack); end

        def self.on_each(_item, filter, scope_stack)
          Engine.call(filter, scope_stack)
        end

        def self.on_after(results, _scope_stack)
          results
        end

        def self.handle_nil
          raise Errors::InvalidArguments
        end
      end
    end
  end
end
