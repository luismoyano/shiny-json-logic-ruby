# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Inclusion < Base
      def self.execute(rules, scope_stack)
        needle = evaluate(rules.first, scope_stack)
        haystack = evaluate(rules.last, scope_stack)

        # Normalize Symbols to String so :foo matches "foo" and vice-versa
        needle = needle.to_s if needle.is_a?(Symbol)

        if haystack.is_a?(Array)
          haystack.any? { |el| (el.is_a?(Symbol) ? el.to_s : el) == needle }
        else
          haystack.include?(needle)
        end
      end
    end
  end
end
