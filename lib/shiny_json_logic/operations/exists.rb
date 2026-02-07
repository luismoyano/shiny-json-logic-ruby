require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Exists < Base
      def call
        current = data

        Array.wrap_nil(rules).each do |rule|
          segment = evaluate(rule)
          return false unless current.key?(segment)
          current = current[segment]
        end

        true
      rescue StandardError
        false
      end
    end
  end
end
