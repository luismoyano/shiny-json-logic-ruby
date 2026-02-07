require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/min_max_collection"

module ShinyJsonLogic
  module Operations
    class Min < Base
      include Numericals::MinMaxCollection

      def call
        collect_numeric_values.min
      end
    end
  end
end
