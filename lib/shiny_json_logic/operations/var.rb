require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Var < Base
      protected

      def run
        key = evaluate(rules[0])
        default = rules[1] ? evaluate(rules[1]) : nil

        return data if key.nil?

        data&.deep_fetch(*Array.wrap(key)) || default
      rescue
        default || data
      end
    end
  end
end

