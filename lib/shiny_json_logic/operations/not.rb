# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Not < Base
      def self.execute(rules, scope_stack)
        value = rules.is_a?(Array) ? rules.first : rules
        !Truthy.call(evaluate(value, scope_stack))
      end
    end
  end
end