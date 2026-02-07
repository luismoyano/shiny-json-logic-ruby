require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/missing"

module ShinyJsonLogic
  module Operations
    class MissingSome < Missing
      def call
        min_required = evaluate(rules[0])
        keys = Array.wrap_nil(evaluate(rules[1]))
        return keys unless data.is_a?(Hash) && rules.is_a?(Array)

        present = keys & data.keys
        ctx = { "rules" => keys, "scope_stack" => scope_stack }
        present.size >= min_required ? [] : Missing.new(ctx).call
      end
    end
  end
end
