require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Exists < Base
      protected

      def run
        current = data

        rules.each do |rule|
          segment = evaluate(rule)
          Array.wrap(segment).flatten.each do |s|
            return false unless current.key?(s)
            current = current[s]
          end
        end

        true
      rescue StandardError
        false
      end
    end
  end
end
