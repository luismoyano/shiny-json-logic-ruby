require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Val < Base
      def call
        data.dig(*rules)
      end
    end
  end
end

