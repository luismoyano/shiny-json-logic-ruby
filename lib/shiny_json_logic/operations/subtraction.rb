require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Subtraction < Base
      protected

      def run
        return rules.first.to_f * -1 if rules.size == 1
        rules.map(&:to_f).reduce(:-)
      end
    end
  end
end
