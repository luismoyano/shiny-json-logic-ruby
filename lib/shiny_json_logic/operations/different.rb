require "shiny_json_logic/operations/base"
require "shiny_json_logic/operations/equal"

module ShinyJsonLogic
  module Operations
    class Different < Base
      protected

      def run
        !Operations::Equal.new(rules, data).call
      end
    end
  end
end