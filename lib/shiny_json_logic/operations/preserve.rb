# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Preserve < Iterable::Base
      def self.call(rules, scope_stack)
        # Preserve doesn't create new scopes - evaluates each item directly
        collection = Utils::Array.wrap(rules)

        results = collection.each_with_object([]) do |item, acc|
          acc << Engine.call(item, scope_stack)
        end

        results.size == 1 ? results.first : results
      end
    end
  end
end
