# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/min_max_collection"

module ShinyJsonLogic
  module Operations
    class Min < Base
      def self.execute(rules, scope_stack)
        Numericals::MinMaxCollection.resolve(rules, scope_stack, :min)
      end
    end
  end
end
