# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Merge < Base
      def self.execute(rules, scope_stack)
        result = []
        operands = Utils::Array.wrap_nil(rules)
        i = 0
        n = operands.size
        while i < n
          evaluated = evaluate(operands[i], scope_stack)
          if evaluated.is_a?(Array)
            result.concat(evaluated)
          else
            result << evaluated
          end
          i += 1
        end
        result
      end
    end
  end
end
