require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Val < Base
      protected

      def run
        return nil if rules.empty?

        data.dig(*rules)
      end
    end
  end
end

