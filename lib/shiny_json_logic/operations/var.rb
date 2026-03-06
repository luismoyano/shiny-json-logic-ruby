# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"
require "shiny_json_logic/utils/data_hash"
require "shiny_json_logic/utils/hash_fetch"

module ShinyJsonLogic
  module Operations
    class Var < Base
      def self.execute(rules, scope_stack)
        items = Utils::Array.wrap_nil(rules)
        key = evaluate(items[0], scope_stack)
        default = items[1] ? evaluate(items[1], scope_stack) : nil
        current_data = scope_stack.current

        if key.nil? || key == ""
          return Utils::DataHash.wrap(current_data)
        end

        result = fetch_value(current_data, key)
        result = result.nil? ? default : result
        Utils::DataHash.wrap(result)
      rescue
        default || scope_stack.current
      end

      def self.fetch_value(obj, key)
        return nil if obj.nil?

        key_s = key.to_s
        # Fast path: no dot notation, single key lookup
        unless key_s.include?(".")
          return Utils::HashFetch.fetch(obj, key_s)
        end

        key_s.split(".").reduce(obj) do |current, k|
          return nil if current.nil?
          Utils::HashFetch.fetch(current, k)
        end
      end
      private_class_method :fetch_value
    end
  end
end

