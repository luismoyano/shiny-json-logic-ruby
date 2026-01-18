require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Map < Iterable::Base
      private

      def on_each(_item)
        ShinyJsonLogic.apply(filter, data)
      end
    end
  end
end
