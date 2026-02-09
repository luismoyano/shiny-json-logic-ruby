require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/missing"

module ShinyJsonLogic
  module Operations
    class MissingSome < Missing
      def call
        min_required = evaluate(rules[0])
        keys = wrap_nil(evaluate(rules[1])).map(&:to_s)
        return keys unless data.is_a?(Hash) && rules.is_a?(Array)

        data_keys = data.keys.map(&:to_s)
        present = keys & data_keys
        present.size >= min_required ? [] : Missing.new(keys, scope_stack).call
      end
    end
  end
end
