# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Merge < Base
      def self.execute(rules, scope_stack)
        Utils::Array.wrap_nil(rules).each_with_object([]) do |rule, result|
          evaluated = evaluate(rule, scope_stack)
          next result.concat(evaluated) if evaluated.is_a?(Array)

          result << evaluated
        end
      end
    end
  end
end
