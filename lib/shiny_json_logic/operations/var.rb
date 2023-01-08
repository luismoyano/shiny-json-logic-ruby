require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Var < Base
      def call
        rls = search_route(rules)
        return data unless ShinyJsonLogic::Truthy.call(rls)
        return data&.dig(*rls) || rules[1] if rules.is_a?(Array) && rules.count > 1

        data&.dig(*rls)
      end

      private

      def search_route(rule)
        rule = rule.first if rule.is_a?(Array)

        return rule.split(".") if rule.is_a?(String) && rule.include?(".")
        rule
      end
    end
  end
end
