# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Exists < Base
      def self.execute(rules, scope_stack)
        current = scope_stack.current

        Utils::Array.wrap_nil(rules).each do |rule|
          segment = evaluate(rule, scope_stack)
          return false unless current.is_a?(Hash) && current.key?(segment)
          current = current[segment]
        end

        true
      end
    end
  end
end
