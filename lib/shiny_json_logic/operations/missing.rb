# frozen_string_literal: true

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

        current_data = scope_stack.last
        return keys unless current_data.is_a?(Hash)

        result = []
        i = 0
        n = keys.size
        while i < n
          result << keys[i] unless present?(current_data, keys[i])
          i += 1
        end
        result
      end

      # Walks a dotted path ("user.address.city", "items.0") through hashes
      # and arrays. A key counts as present when it exists, whatever its value.
      def self.present?(data, key)
        current = data
        key.split(".", -1).each do |segment|
          if current.is_a?(::Hash)
            if current.key?(segment)
              current = current[segment]
            elsif current.key?(segment.to_sym)
              current = current[segment.to_sym]
            else
              return false
            end
          elsif current.is_a?(::Array)
            return false unless segment.match?(/\A\d+\z/) && segment.to_i < current.size

            current = current[segment.to_i]
          else
            return false
          end
        end
        true
      end

      private_class_method :present?
    end
  end
end
