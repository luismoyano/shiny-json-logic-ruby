require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/missing"

module ShinyJsonLogic
  module Operations
    class MissingSome < Missing
      protected

      def run
        return rules[1] unless data.is_a?(Hash) && rules.is_a?(Array)

        present = rules[1] & data.keys
        ctx = { "rules" => rules[1], "data" => data, "errors" => errors }
        present.size >= rules[0] ? [] : Missing.new(ctx).call["result"]
      end
    end
  end
end
