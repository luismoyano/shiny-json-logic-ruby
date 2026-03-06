# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/min_max_collection"

module ShinyJsonLogic
  module Operations
    class Max < Base
      def self.execute(rules, scope_stack)
        Numericals::MinMaxCollection.scan(rules, scope_stack, :max) ||
          Numericals::MinMaxCollection.collect_numeric_values(rules, scope_stack).max
      end
    end
  end
end
