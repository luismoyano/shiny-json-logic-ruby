# frozen_string_literal: true

require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Concatenation < Base
      def self.execute(rules, scope_stack)
        result = +""
        Utils::Array.wrap_nil(rules).each do |rule|
          evaluated = evaluate(rule, scope_stack)
          if evaluated.is_a?(Array)
            evaluated.each { |v| result << v.to_s }
          else
            result << evaluated.to_s
          end
        end
        result
      end
    end
  end
end
