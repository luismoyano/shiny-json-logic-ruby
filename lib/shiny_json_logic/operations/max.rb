# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/min_max_collection"

module ShinyJsonLogic
  module Operations
    class Max < Base
      include Numericals::MinMaxCollection

      def call
        collect_numeric_values.max
      end
    end
  end
end
