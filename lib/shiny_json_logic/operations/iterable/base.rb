require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    module Iterable
      class Base < ShinyJsonLogic::Operations::Base
        def initialize(rules, data)
          super
          @collection = ShinyJsonLogic.apply(rules.fetch(0), data) || []
          @filter = rules.fetch(1)
        end

        def call
          on_before

          collection.map do |item|
            on_before_each(item)
            on_each(item)
          end.then do |results|
            on_after(results)
          end
        end

        private

        def on_each(item)
          raise NotImplementedError
        end

        def on_before_each(item)
          data[current_key] = item
          data.merge!(item) if item.is_a?(Hash)
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
