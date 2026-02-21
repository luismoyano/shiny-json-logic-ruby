# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Inclusion < Base
      def self.execute(rules, scope_stack)
        needle = evaluate(rules.first, scope_stack)
        haystack = evaluate(rules.last, scope_stack)
        haystack.include?(needle)
      end
    end
  end
end
