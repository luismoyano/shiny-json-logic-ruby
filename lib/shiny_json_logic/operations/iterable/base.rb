require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    module Iterable
      class Base < ShinyJsonLogic::Operations::Base
        attr_reader :collection, :filter, :data

        def initialize(rules, data)
          @collection = ShinyJsonLogic.apply(rules.first, data)
          @filter = rules.last
          @data = data
        end

        def call
          collection.map do |item|
            on_each(item)
          end.compact
        end
      end
    end
  end
end
