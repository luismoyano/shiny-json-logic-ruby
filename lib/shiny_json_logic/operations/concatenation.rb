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
              result << stringify(evaluated[j])
              j += 1
            end
          else
            result << stringify(evaluated)
          end
          i += 1
        end
        result
      end

      # Arithmetic returns Floats, so 1 + 2 is 3.0. Print whole numbers
      # without the ".0", like JavaScript does ("Total: 3", not "Total: 3.0").
      def self.stringify(value)
        if value.is_a?(::Float) && value.finite? && value == value.truncate && value.abs < 1e21
          value.to_i.to_s
        else
          value.to_s
        end
      end

      private_class_method :stringify
    end
  end
end
