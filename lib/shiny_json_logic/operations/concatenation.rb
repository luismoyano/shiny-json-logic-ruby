# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Concatenation < Base
      def self.execute(rules, scope_stack)
        result = +""
        operands = Utils::Array.wrap_nil(rules)
        i = 0
        n = operands.size
        while i < n
          evaluated = evaluate(operands[i], scope_stack)
          if evaluated.is_a?(Array)
            j = 0
            m = evaluated.size
            while j < m
              result << evaluated[j].to_s
              j += 1
            end
          else
            result << evaluated.to_s
          end
          i += 1
        end
        result
      end
    end
  end
end
