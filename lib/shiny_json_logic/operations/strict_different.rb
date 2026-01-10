require "shiny_json_logic/operations/base"
require "shiny_json_logic/operations/strict_equal"

module ShinyJsonLogic
  module Operations
    class StrictDifferent < Base
      def call
        !Operations::StrictEqual.new(rules, data).call
      end
    end
  end
end