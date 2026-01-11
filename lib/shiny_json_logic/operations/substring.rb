require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Substring < Base
      def call
        str, start, length = rules[0].to_s, rules[1].to_i, rules[2].to_i
        start += str.length if start < 0
        finish = length < 0 ? str.length + length : start + length

        str[start...finish]
      end
    end
  end
end
