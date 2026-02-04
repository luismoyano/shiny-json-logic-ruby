require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Min < Base
      protected

      def run
        result = nil
        rules.each do |rule|
          Array.wrap(evaluate(rule)).flatten.each do |val|
            result = val if result.nil? || val < result
          end
        end
        result
      end
    end
  end
end
