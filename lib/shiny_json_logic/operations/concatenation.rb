require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Concatenation < Base
      def call
        return rules.map(&:to_s).join if rules.is_a?(Array)

        rules
      end
    end
  end
end
