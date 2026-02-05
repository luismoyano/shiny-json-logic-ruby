require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Val < Base
      protected

      def run
        return nil if rules.nil? || (rules.is_a?(Array) && rules.empty?)

        items = Array.wrap_nil(rules)
        keys = items.map { |rule| evaluate(rule) }
        data.dig(*keys)
      end
    end
  end
end

