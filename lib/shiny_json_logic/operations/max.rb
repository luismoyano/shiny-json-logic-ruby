require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Max < Base
      protected

      def run
        result = nil
        Array.wrap_nil(rules).each do |rule|
          Array.wrap_nil(evaluate(rule)).each do |val|
            result = val if result.nil? || val > result
          end
        end
        result
      end
    end
  end
end
