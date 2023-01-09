require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/missing"

module ShinyJsonLogic
  module Operations
    class MissingSome < Missing
      def call
        return rules[1] unless data.is_a?(Hash) && rules.is_a?(Array)

        present = rules[1] & data.keys
        present.size >= rules[0] ? [] : Missing.new(rules[1], data).call
      end
    end
  end
end
