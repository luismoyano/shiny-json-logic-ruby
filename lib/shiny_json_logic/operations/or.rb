require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Or < Base
      protected

      def run
        result = nil
        rules.each do |rule|
          result = evaluate(rule)
          return result if Truthy.call(result)
        end
        result
      end
    end
  end
end