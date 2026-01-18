require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Filter < Iterable::Base
      private

      def on_each(item)
        item if Truthy.call(ShinyJsonLogic.apply(filter, data))
      end

      def on_after(results)
        results.compact
      end
    end
  end
end
