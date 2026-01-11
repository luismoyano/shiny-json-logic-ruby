require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Max < Base
      def call
        rules.max
      end
    end
  end
end
