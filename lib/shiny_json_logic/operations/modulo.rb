require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Modulo < Base
      protected

      def run
        rules.reduce(:%)
      end
    end
  end
end
