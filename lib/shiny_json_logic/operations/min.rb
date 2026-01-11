require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Min < Base
      def call
        rules.min
      end
    end
  end
end
