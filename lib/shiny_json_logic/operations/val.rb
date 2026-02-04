require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Val < Base
      protected

      def run
        return nil if rules.empty?

        keys = rules.map { |rule| evaluate(rule) }
        data.dig(*keys)
      end
    end
  end
end

