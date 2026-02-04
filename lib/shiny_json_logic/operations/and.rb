require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class And < Base
      protected

      def run
        result = nil
        rules.each do |rule|
          result = evaluate(rule)
          return result unless Truthy.call(result)
        end
        result
      end
    end
  end
end