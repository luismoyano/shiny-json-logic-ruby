require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Missing < Base
      def call
        p rules
        return rules unless data.is_a?(Hash) && rules.is_a?(Array)

        rules - deep_keys(data)
      end

      protected

      def deep_keys(hash)
        return unless hash.is_a?(Hash)

        hash.keys.map{|key| ([key] << deep_keys(hash[key])).compact.join(".") }
      end
    end
  end
end
