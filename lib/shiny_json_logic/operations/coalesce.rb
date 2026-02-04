require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Coalesce < Base
      protected

      def run
        rules.each do |rule|
          result = evaluate(rule)
          return result unless result.nil?
        end
        nil
      end
    end
  end
end
