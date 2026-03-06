# frozen_string_literal: true

require "shiny_json_logic/errors/invalid_arguments"

module ShinyJsonLogic
  module Numericals
    module MinMaxCollection
      module_function

      def resolve(rules, scope_stack, op)
        if rules.is_a?(Hash) && !rules.empty? && Engine::OPERATIONS.key?(rules.first[0].to_s)
          items = Utils::Array.wrap_nil(Engine.call(rules, scope_stack))
          evaluated = true
        else
          items = Utils::Array.wrap_nil(rules)
          evaluated = false
        end

        raise Errors::InvalidArguments if items.empty?

        best = evaluated ? items[0] : Engine.call(items[0], scope_stack)
        raise Errors::InvalidArguments unless best.is_a?(Numeric)

        i = 1
        n = items.size
        while i < n
          v = evaluated ? items[i] : Engine.call(items[i], scope_stack)
          raise Errors::InvalidArguments unless v.is_a?(Numeric)
          best = v if op == :min ? v < best : v > best
          i += 1
        end
        best
      end
    end
  end
end
