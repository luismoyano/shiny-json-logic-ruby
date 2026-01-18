require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Filter < Base
      def call
        collection = ShinyJsonLogic.apply(rules.first, data)
        filter = rules.last
        collection.map do |item|
          iterable_data = data.merge("" => item)
          # p collection, filter, iterable_data
          item if Truthy.call(ShinyJsonLogic.apply(filter, iterable_data))
        end.compact
      end
    end
  end
end
