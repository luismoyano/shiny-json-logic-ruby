require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class And < Base
      protected

      def run
        rules.reduce { |a, b| Truthy.call(a) ? b : a }
      end
    end
  end
end