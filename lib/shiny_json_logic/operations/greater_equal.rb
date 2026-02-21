# frozen_string_literal: true

require "shiny_json_logic/operations/base"
require "shiny_json_logic/comparisons/comparable"

module ShinyJsonLogic
  module Operations
    class GreaterEqual < Base
      raise_on_dynamic_args!

      def self.execute(rules, scope_stack)
        Comparisons::Comparable.compare_chain(rules, scope_stack) { |r| r >= 0 }
      end
    end
  end
end
