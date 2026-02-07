require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    module Iterable
      class Base < Operations::Base
        def initialize(context)
          super

          @filter = rules[1]
          return handle_nil if @filter.nil? && self.class.raise_on_nil_filter?

          collection = rules.any? ? rules[0] : rules
          return handle_nil if collection.nil?

          setup_collection(collection)
        end

        def call
          return deliver if errors.any?

          deliver run
        end

        protected

        def run
          on_before

          collection.each_with_index.each_with_object([]) do |(item, index), results|
            on_before_each(item, index)
            solved, solver = on_each(item)
            results << solved
            break if solved.is_a?(String) && solved.match?(Try::SHINY_ERROR_PATTERN)
            on_after_each(solved, solver)
          end.then do |results|
            on_after(results)
          end
        end

        private

        def on_each(_item)
          engine = Engine.new(filter, scope_stack: scope_stack)
          [engine.call, engine]
        end

        def on_before_each(item, index = 0)
          # Push the iterator context first (with index)
          # This creates the intermediate level for [[1], "index"] access
          scope_stack.push({ "index" => index }, index: index)
          
          # Then push the current item
          scope_stack.push(item, index: index)
        end

        def on_after_each(_solved, solver)
          # Pop the item scope
          scope_stack.pop
          # Pop the iterator context scope
          scope_stack.pop
          self.errors = [*self.errors, *solver.errors]
        end

        def on_before
        end

        def on_after(results)
          results
        end

        def handle_nil
          error = Errors::Base.new(type: "Invalid Arguments")
          self.errors = [error]

          error.id
        end

        def setup_collection(collection)
          if collection.nil?
            @collection = []
          else
            @collection = Array.wrap(evaluate(collection))
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
