# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Substring < Base
      def self.execute(rules, scope_stack)
        str = evaluate(rules[0], scope_stack).to_s
        start = evaluate(rules[1], scope_stack).to_i
        length = rules[2] ? evaluate(rules[2], scope_stack).to_i : str.length
        start += str.length if start < 0
        start = 0 if start < 0  # clamp negative start to 0
        return "" if start >= str.length
        finish = length < 0 ? str.length + length : start + length

        str[start...finish] || ""
      end
    end
  end
end
