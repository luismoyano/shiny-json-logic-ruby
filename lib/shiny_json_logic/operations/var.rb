require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Var < Base
      protected

      def run
        items = Array.wrap_nil(rules)
        key = evaluate(items[0])
        default = items[1] ? evaluate(items[1]) : nil

        return data if key.nil?

        data&.deep_fetch(*Array.wrap(key)) || default
      rescue
        default || data
      end
    end
  end
end

