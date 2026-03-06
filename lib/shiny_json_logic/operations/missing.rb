# frozen_string_literal: true

require "set"
require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Missing < Base
      def self.execute(rules, scope_stack)
        wrapped = Utils::Array.wrap_nil(rules)
        keys = []
        i = 0
        n = wrapped.size
        while i < n
          evaluated = evaluate(wrapped[i], scope_stack)
          if evaluated.is_a?(Array)
            j = 0
            m = evaluated.size
            while j < m
              keys << evaluated[j].to_s
              j += 1
            end
          else
            keys << evaluated.to_s
          end
          i += 1
        end

        current_data = scope_stack.current
        return keys unless current_data.is_a?(Hash)

        existing = Set.new
        deep_keys(current_data, nil, existing)

        result = []
        i = 0
        n = keys.size
        while i < n
          result << keys[i] unless existing.include?(keys[i])
          i += 1
        end
        result
      end

      def self.deep_keys(hash, prefix, acc)
        return unless hash.is_a?(Hash)

        hash.each do |key, val|
          key_s = key.to_s
          full_key = prefix ? "#{prefix}.#{key_s}" : key_s
          if val.is_a?(Hash)
            deep_keys(val, full_key, acc)
          else
            acc << full_key
          end
        end
      end

      private_class_method :deep_keys
    end
  end
end
