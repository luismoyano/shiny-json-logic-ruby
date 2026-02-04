require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Merge < Base
      protected

      def run
        result = []
        rules.each do |rule|
          evaluated = evaluate(rule)
          result.concat(Array.wrap(evaluated).flatten)
        end
        result
      end
    end
  end
end
