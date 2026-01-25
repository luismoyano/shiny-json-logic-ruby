require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Max < Base
      protected

      def run
        rules.max
      end
    end
  end
end
