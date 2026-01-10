require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Equal < Base
      def call
        rules[0].to_s == rules[1].to_s
      end
    end
  end
end