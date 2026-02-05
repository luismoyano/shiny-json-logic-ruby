require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Not < Base
      protected

      def run
        value = rules.is_a?(Array) ? rules.first : rules
        !Truthy.call(evaluate(value))
      end
    end
  end
end