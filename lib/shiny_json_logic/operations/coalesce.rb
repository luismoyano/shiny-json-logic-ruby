# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Coalesce < Base
      def self.execute(rules, scope_stack)
        rules.each do |rule|
          result = evaluate(rule, scope_stack)
          return result unless result.nil?
        end
        nil
      end
    end
  end
end
