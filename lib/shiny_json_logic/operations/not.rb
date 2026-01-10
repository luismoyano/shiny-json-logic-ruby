require "shiny_json_logic/operations/base"
require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Not < Base
      def call
        !Truthy.call(rules.first)
      end
    end
  end
end