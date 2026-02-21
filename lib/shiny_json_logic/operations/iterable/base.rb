# frozen_string_literal: true

require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    module Iterable
      class Base < Operations::Base
        def initialize(rules, scope_stack)
          super

          return handle_nil if dynamic_args?
          return handle_nil unless rules.is_a?(Array)

          @filter = rules[1]
          return handle_nil if @filter.nil? && self.class.raise_on_nil_filter?

          collection = rules.any? ? rules[0] : rules
          return handle_nil if collection.nil?

          setup_collection(collection)
        end

        def call
          on_before

          results = collection.each_with_index.each_with_object([]) do |(item, index), results|
            on_before_each(item, index)
            begin
              solved = on_each(item)
              results << solved
              on_after_each
            rescue => e
              # Clean up scopes before re-raising
              scope_stack.pop  # item scope
              scope_stack.pop  # iterator context scope
              raise e
            end
          end

          on_after(results)
        end

        protected

        private

        def on_each(_item)
          Engine.call(filter, scope_stack)
        end

        def on_before_each(item, index = 0)
          # Push the iterator context first (with index)
          # This creates the intermediate level for [[1], "index"] access
          scope_stack.push({ "index" => index }, index: index)
          
          # Then push the current item
          scope_stack.push(item, index: index)
        end

        def on_after_each
          # Pop the item scope
          scope_stack.pop
          # Pop the iterator context scope
          scope_stack.pop
        end

        def on_before
        end

        def on_after(results)
          results
        end

        def handle_nil
          raise Errors::InvalidArguments
        end

        def setup_collection(collection)
          if collection.nil?
            @collection = []
          else
            @collection = wrap(evaluate(collection))
          end
        end

        def self.raise_on_nil_filter!
          @raise_on_nil_filter = true
        end

        def self.raise_on_nil_filter?
          @raise_on_nil_filter
        end

        attr_reader :collection, :filter
      end
    end
  end
end
