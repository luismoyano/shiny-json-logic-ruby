# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Merge < Base
      def self.execute(rules, scope_stack)
        Utils::Array.wrap_nil(rules).map do |rule|
          Utils::Array.wrap_nil(evaluate(rule, scope_stack))
        end.reduce([], :+)
      end
    end
  end
end
