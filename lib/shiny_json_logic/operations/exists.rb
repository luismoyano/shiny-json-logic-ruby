require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Exists < Base
      def call
        current = data

        Array.wrap(rules).each do |segment|
          return false unless current.key?(segment)

          current = current[segment]
        end

        true
      rescue
        false
      end
    end
  end
end
