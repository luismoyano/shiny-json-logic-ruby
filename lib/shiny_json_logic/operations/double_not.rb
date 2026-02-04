require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class DoubleNot < Base
      protected

      def run
        !!Truthy.call(evaluate(rules.first))
      end
    end
  end
end