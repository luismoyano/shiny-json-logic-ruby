# frozen_string_literal: true

require "set"
require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Missing < Base
      def self.execute(rules, scope_stack)
        keys = Utils::Array.wrap_nil(rules).each_with_object([]) do |rule, keys|
          evaluated = evaluate(rule, scope_stack)
          if evaluated.is_a?(Array)
            evaluated.each { |v| keys << v.to_s }
          else
            keys << evaluated.to_s
          end
        end

        current_data = scope_stack.current
        return keys unless current_data.is_a?(Hash)

        existing = Set.new
        deep_keys(current_data, nil, existing)
        keys.reject { |k| existing.include?(k) }
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
