require "shiny_json_logic/errors/base"

module ShinyJsonLogic
  module Errors
    class InvalidArguments < Base
      def initialize
        super(type: "Invalid Arguments")
      end
    end
  end
end
