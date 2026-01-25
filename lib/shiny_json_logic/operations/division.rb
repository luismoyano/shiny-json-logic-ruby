require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Division < Base
      protected

      def run
        rules.map(&:to_f).reduce(:/)
      end
    end
  end
end
