# frozen_string_literal: true

require "shiny_json_logic/numericals/numerify"

module ShinyJsonLogic
  module Comparisons
    module Comparable
      include Numericals::Numerify

      private

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
        return value.to_f if value.is_a?(String) && numeric_string?(value)
        nil
      end
    end
  end
end
