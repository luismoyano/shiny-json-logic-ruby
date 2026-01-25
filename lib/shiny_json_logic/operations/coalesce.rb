require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Coalesce < Base
      protected

      def run
        rules.compact.first
      end
    end
  end
end
