require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class And < Base
      def call
        rules.reduce { |a, b| a && b }
      end
    end
  end
end