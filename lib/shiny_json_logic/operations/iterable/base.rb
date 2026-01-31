require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    module Iterable
      class Base < Operations::Base
        def initialize(context)
          super
          Engine.new(context.dig("rules", 0), data).tap do |engine|
            @collection = engine.call || []
            self.errors = [*self.errors, *engine.errors]
          end
          @filter = rules[1]
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

        attr_reader :collection, :filter
      end
    end
  end
end
