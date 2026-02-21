# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/numericals/with_error_handling"
require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Operations
    class Addition < Base
      extend Numericals::WithErrorHandling

      def self.execute(rules, scope_stack)
        safe_arithmetic do
          result = 0.0
          Utils::Array.wrap_nil(rules).each do |rule|
            val = Numericals::Numerify.numerify(evaluate(rule, scope_stack))
            result += val.nil? ? 0 : val
          end
          result
        end
      end
    end
  end
end
