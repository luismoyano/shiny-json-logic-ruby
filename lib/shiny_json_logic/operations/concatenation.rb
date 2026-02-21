# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Concatenation < Base
      def self.execute(rules, scope_stack)
        result = []
        Utils::Array.wrap_nil(rules).each do |rule|
          evaluated = evaluate(rule, scope_stack)
          Utils::Array.wrap_nil(evaluated).each { |v| result << v.to_s }
        end
        result.join
      end
    end
  end
end
