require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    module Iterable
      class Base < ShinyJsonLogic::Operations::Base
        def initialize(rules, data)
          @collection = ShinyJsonLogic.apply(rules.first, data) || []
          @filter = rules.last
          @data = data
        end

        def call
          collection.map do |item|
            data[""] = item
            data.merge!(item) if item.is_a?(Hash)
            on_each(item)
          end.compact
        end

        private

        attr_reader :collection, :filter
      end
    end
  end
end
