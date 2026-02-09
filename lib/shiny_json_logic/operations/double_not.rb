require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class DoubleNot < Base
      def call
        value = wrap_nil(rules).first
        !!Truthy.call(evaluate(value))
      end
    end
  end
end