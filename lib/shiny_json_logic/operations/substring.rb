require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Substring < Base
      protected

      def run
        str, start = rules[0].to_s, rules[1].to_i
        length = rules.fetch(2, str.length).to_i
        start += str.length if start < 0
        finish = length < 0 ? str.length + length : start + length

        str[start...finish]
      end
    end
  end
end
