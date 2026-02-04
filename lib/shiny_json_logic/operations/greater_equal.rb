require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class GreaterEqual < Base
      protected

      def run
        prev = evaluate(rules[0]).to_f
        rules[1..].each do |rule|
          curr = evaluate(rule).to_f
          return false unless prev >= curr
          prev = curr
        end
        true
      end
    end
  end
end