require "shiny_json_logic/errors/base"

module ShinyJsonLogic
  module Errors
    class NotANumber < Base
      def initialize
        super(type: "NaN")
      end
    end
  end
end
