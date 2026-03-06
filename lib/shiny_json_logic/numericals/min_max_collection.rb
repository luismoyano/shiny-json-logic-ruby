# frozen_string_literal: true

require "shiny_json_logic/errors/invalid_arguments"

module ShinyJsonLogic
  module Numericals
    module MinMaxCollection
      module_function

      def collect_numeric_values(rules, scope_stack)
        values = collect_values(rules, scope_stack)
        raise Errors::InvalidArguments if values.empty?
        i = 0
        n = values.size
        while i < n
          raise Errors::InvalidArguments unless values[i].is_a?(Numeric)
          i += 1
        end
        values
      end

      # Single-pass scan returning min or max without building an intermediate array.
      # Only works when rules is a plain Array of directly-evaluatable items.
      def scan(rules, scope_stack, operator)
        return nil unless rules.is_a?(::Array) && !rules.empty?

        best = nil
        i = 0
        n = rules.size
        while i < n
          v = Engine.call(rules[i], scope_stack)
          raise Errors::InvalidArguments unless v.is_a?(Numeric)
          best = best.nil? || (operator == :min ? v < best : v > best) ? v : best
          i += 1
        end
        best
      end

      def collect_values(rules, scope_stack)
        if rules.is_a?(Hash) && !rules.empty?
          key = nil
          rules.each_key { |k| key = k; break }
          if Engine::OPERATIONS.key?(key.is_a?(::String) ? key : key.to_s)
            evaluated = Engine.call(rules, scope_stack)
            return Utils::Array.wrap_nil(evaluated)
          end
        end

        wrapped = Utils::Array.wrap_nil(rules)
        n = wrapped.size
        result = Array.new(n)
        i = 0
        while i < n
          result[i] = Engine.call(wrapped[i], scope_stack)
          i += 1
        end
        result
      end
    end
  end
end
