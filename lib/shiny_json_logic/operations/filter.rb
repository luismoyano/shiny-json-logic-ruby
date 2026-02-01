require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Filter < Iterable::Base
      private

      def on_each(item)
        Engine.new(filter, data).then do |engine|
          [Truthy.call(engine.call) ? item : nil, engine]
        end
      end

      def on_after(results)
        results.compact
      end
    end
  end
end
