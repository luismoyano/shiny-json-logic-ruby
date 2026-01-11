require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Inclusion < Base
      def call
        rules.last.include? rules.first
      end
    end
  end
end
