require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Or < Base
      protected

      def run
        rules.find { |v| Truthy.call(v) } || rules.last
      end
    end
  end
end