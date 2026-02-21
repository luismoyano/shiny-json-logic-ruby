# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class DoubleNot < Base
      def self.execute(rules, scope_stack)
        value = Utils::Array.wrap_nil(rules).first
        !!Truthy.call(evaluate(value, scope_stack))
      end
    end
  end
end