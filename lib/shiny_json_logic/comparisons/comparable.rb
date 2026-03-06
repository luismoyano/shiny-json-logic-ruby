# frozen_string_literal: true

require "shiny_json_logic/numericals/numerify"
require "shiny_json_logic/errors/not_a_number"
require "shiny_json_logic/errors/invalid_arguments"

module ShinyJsonLogic
  module Comparisons
    module Comparable
      module_function

      def compare(a, b)
        return :nan if a.is_a?(Array) || a.is_a?(Hash) || b.is_a?(Array) || b.is_a?(Hash)

        if a.is_a?(String) && b.is_a?(String)
          return a <=> b
        end

        num_a = numerify_for_comparison(a)
        num_b = numerify_for_comparison(b)
        return :nan if num_a.nil? || num_b.nil?

        num_a <=> num_b
      end

      def numerify_for_comparison(value)
        return value.to_f if value.is_a?(Numeric)
        return 0.0 if value == false
        return 1.0 if value == true
        return 0.0 if value.nil?
        return value.to_f if value.is_a?(String) && Numericals::Numerify.numeric_string?(value)
        nil
      end

      # Normalize numeric types for strict equality comparisons (=== semantics).
      def cast(value)
        value.is_a?(Numeric) ? value.to_f : value
      end

      # Shared loop for all chain-comparison operators.
      # Yields the compare result for each consecutive pair; block returns true to continue, false to short-circuit.
      # Returns true if all pairs pass, false otherwise. Raises on :nan or invalid args.
      def compare_chain(rules, scope_stack)
        operands = Utils::Array.wrap_nil(rules)
        n = operands.length
        raise Errors::InvalidArguments if n < 2

        prev = Engine.call(operands[0], scope_stack)
        i = 1
        while i < n
          curr = Engine.call(operands[i], scope_stack)
          result = compare(prev, curr)
          raise Errors::NotANumber if result == :nan
          return false unless yield(result)
          prev = curr
          i += 1
        end
        true
      end
    end
  end
end
