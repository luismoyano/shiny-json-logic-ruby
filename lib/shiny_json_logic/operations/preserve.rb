# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Preserve < Iterable::Base
      def self.call(rules, scope_stack)
        # Preserve doesn't create new scopes - evaluates each item directly
        collection = Utils::Array.wrap(rules)
        n = collection.size
        results = Array.new(n)
        i = 0
        while i < n
          results[i] = Engine.call(collection[i], scope_stack)
          i += 1
        end
        results.size == 1 ? results.first : results
      end
    end
  end
end
