require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Merge < Base
      protected

      def run
        Array.wrap_nil(rules).map do |rule|
          Array.wrap_nil(evaluate(rule))
        end.reduce([], :+)
      end
    end
  end
end
