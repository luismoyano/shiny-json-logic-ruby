require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Some < Iterable::Base
      private

      def on_each(_item)
        ShinyJsonLogic.apply(filter, data)
      end

      def on_after(results)
        results.any? { |res| res == true }
      end
    end
  end
end
