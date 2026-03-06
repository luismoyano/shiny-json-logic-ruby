# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Coalesce < Base
      def self.execute(rules, scope_stack)
        i = 0
        n = rules.size
        while i < n
          result = evaluate(rules[i], scope_stack)
          return result unless result.nil?
          i += 1
        end
        nil
      end
    end
  end
end
