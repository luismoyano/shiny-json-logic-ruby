require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Addition < Base
      def call
        rules.map(&:to_f).reduce(:+)
      end
    end
  end
end
