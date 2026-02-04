require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/missing"

module ShinyJsonLogic
  module Operations
    class MissingSome < Missing
      protected

      def run
        min_required = evaluate(rules[0])
        keys = Array.wrap(evaluate(rules[1])).flatten
        return keys unless data.is_a?(Hash) && rules.is_a?(Array)

        present = keys & data.keys
        ctx = { "rules" => keys, "data" => data, "errors" => errors }
        present.size >= min_required ? [] : Missing.new(ctx).call["result"]
      end
    end
  end
end
