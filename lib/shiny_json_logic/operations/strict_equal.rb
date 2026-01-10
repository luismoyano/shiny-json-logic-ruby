require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class StrictEqual < Base
      def call
        rules[0] == rules[1]
      end
    end
  end
end