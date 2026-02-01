require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    module Iterable
      class Base < Operations::Base
        def initialize(context)
          super
          collection = rules.any? ? rules[0] : rules
          return handle_nil_collection if collection.nil?

          if collection.nil?
            @collection = []
          else
            Engine.new(collection, data).tap do |engine|
              call = engine.call
              @collection = Array.wrap(call)
              self.errors = [*self.errors, *engine.errors]
            end
          end

          @filter = rules[1]
        end

        def call
          return deliver if errors.any?

          deliver run
        end

        protected

        def run
          on_before

          collection.each_with_object([]) do |item, results|
            on_before_each(item)
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
          Engine.new(filter, data).then do |engine|
            [engine.call, engine]
          end
        end

        def on_before_each(item)
          data[current_key] = item
          data.merge!(item) if item.is_a?(Hash)
        end

        def on_after_each(_solved, solver)
          self.errors = [*self.errors, *solver.errors]
        end

        def on_before
        end

        def on_after(results)
          results
        end

        def current_key
          ""
        end

        def handle_nil_collection
          error = Errors::Base.new(type: "Invalid Arguments")
          self.errors = [error]

          error.id
        end

        attr_reader :collection, :filter
      end
    end
  end
end
