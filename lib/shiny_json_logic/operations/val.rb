require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Val < Base
      protected

      def run
        raw_keys = Array.wrap_nil(rules)
        
        return data if raw_keys.empty? || raw_keys == [nil]

        keys = raw_keys.map { |rule| evaluate(rule) }
        data.dig(*keys)
      end
    end
  end
end

