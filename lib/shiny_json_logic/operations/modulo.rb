require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Modulo < Base
      def call
        rules.reduce(:%)
      end
    end
  end
end
