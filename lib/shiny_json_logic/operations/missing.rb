require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Missing < Base
      def call
        items = Array.wrap_nil(rules)
        keys = []
        items.each do |rule|
          evaluated = evaluate(rule)
          keys.concat(Array.wrap_nil(evaluated).map(&:to_s))
        end
        return keys unless data.is_a?(Hash)

        keys - deep_keys(data)
      end

      private

      def deep_keys(hash)
        return unless hash.is_a?(Hash)

        hash.keys.map{|key| ([key.to_s] << deep_keys(hash[key])).compact.join(".") }
      end
    end
  end
end
