require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Min < Base
      protected

      def run
        rules.min
      end
    end
  end
end
