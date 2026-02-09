require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Merge < Base
      def call
        wrap_nil(rules).map do |rule|
          wrap_nil(evaluate(rule))
        end.reduce([], :+)
      end
    end
  end
end
