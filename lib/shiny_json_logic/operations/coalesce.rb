require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Coalesce < Base
      def call
        rules.compact.first
      end
    end
  end
end
