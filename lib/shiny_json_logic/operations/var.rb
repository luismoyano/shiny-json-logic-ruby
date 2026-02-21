# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Var < Base
      def self.execute(rules, scope_stack)
        items = Utils::Array.wrap_nil(rules)
        key = evaluate(items[0], scope_stack)
        default = items[1] ? evaluate(items[1], scope_stack) : nil
        current_data = scope_stack.current

        return current_data if key.nil? || key == ""

        result = fetch_value(current_data, key)
        result.nil? ? default : result
      rescue
        default || scope_stack.current
      end

      def self.fetch_value(obj, key)
        return nil if obj.nil?

        keys = key.to_s.split('.')

        keys.reduce(obj) do |current, k|
          return nil if current.nil?

          if current.is_a?(Hash)
            current[k]
          elsif current.is_a?(Array)
            current[k.to_i]
          else
            nil
          end
        end
      end
      private_class_method :fetch_value
    end
  end
end

