require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Filter < Iterable::Base
      def on_each(item)
        iterable_data = data.merge("" => item)
        # p collection, filter, iterable_data
        item if Truthy.call(ShinyJsonLogic.apply(filter, iterable_data))
      end
    end
  end
end
