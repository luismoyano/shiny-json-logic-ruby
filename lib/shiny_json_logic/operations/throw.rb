# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Throw < Base
      def self.execute(rules, scope_stack)
        raw_value = rules.is_a?(Array) ? rules[0] : rules

        error_type =
          if op?(raw_value)
            evaluate(raw_value, scope_stack)
          else
            raw_value
          end

        extracted_type = error_type.is_a?(Hash) && error_type.key?("type") ? error_type["type"] : error_type
        extracted_type = scope_stack.last["type"] if extracted_type.nil?

        raise Errors::Base.new(type: extracted_type)
      end
    end
  end
end
