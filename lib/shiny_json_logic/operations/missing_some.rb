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
        present.size >= min_required ? [] : Missing.new(keys, scope_stack).call
      end
    end
  end
end
