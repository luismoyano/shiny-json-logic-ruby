# frozen_string_literal: true

require "shiny_json_logic/errors/invalid_arguments"

module ShinyJsonLogic
  module Numericals
    module MinMaxCollection
      module_function

      def collect_numeric_values(rules, scope_stack)
        values = collect_values(rules, scope_stack)
        raise Errors::InvalidArguments if values.empty?
        values.each { |v| raise Errors::InvalidArguments unless v.is_a?(Numeric) }
        values
      end

      def collect_values(rules, scope_stack)
        if Operations::Base.op?(rules)
          evaluated = Engine.call(rules, scope_stack)
          return Utils::Array.wrap_nil(evaluated)
        end

        wrapped = Utils::Array.wrap_nil(rules)
        wrapped.map { |rule| Engine.call(rule, scope_stack) }
      end
    end
  end
end
