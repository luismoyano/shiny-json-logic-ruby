require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Exists < Base
      protected

      def run
        current = data

        Array.wrap(rules).each do |segment|
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
