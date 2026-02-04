require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Substring < Base
      protected

      def run
        str = evaluate(rules[0]).to_s
        start = evaluate(rules[1]).to_i
        length = rules[2] ? evaluate(rules[2]).to_i : str.length
        start += str.length if start < 0
        finish = length < 0 ? str.length + length : start + length

        str[start...finish]
      end
    end
  end
end
