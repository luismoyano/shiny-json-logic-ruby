# frozen_string_literal: true

require "shiny_json_logic/errors/invalid_arguments"

module ShinyJsonLogic
  module Numericals
    module MinMaxCollection
      module_function

      def collect_numeric_values(rules, scope_stack)
        values = collect_values(rules, scope_stack)
        raise Errors::InvalidArguments if values.empty?
        raise Errors::InvalidArguments unless values.all? { |v| v.is_a?(Numeric) }
        values
      end

      def collect_values(rules, scope_stack)
        if Operations::Base.op?(rules)
          evaluated = Engine.call(rules, scope_stack)
          return Utils::Array.wrap_nil(evaluated)
        end

        result = []
        Utils::Array.wrap_nil(rules).each do |rule|
          result << Engine.call(rule, scope_stack)
        end
        result
      end
    end
  end
end
