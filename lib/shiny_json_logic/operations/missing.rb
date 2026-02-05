require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Missing < Base
      protected

      def run
        keys = []
        rules.each do |rule|
          evaluated = evaluate(rule)
          keys.concat(Array.wrap_nil(evaluated))
        end
        return keys unless data.is_a?(Hash) && rules.is_a?(Array)

        keys - deep_keys(data)
      end

      private

      def deep_keys(hash)
        return unless hash.is_a?(Hash)

        hash.keys.map{|key| ([key] << deep_keys(hash[key])).compact.join(".") }
      end
    end
  end
end
