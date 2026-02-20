# frozen_string_literal: true

require "shiny_json_logic/errors/base"

module ShinyJsonLogic
  module Errors
    class UnknownOperator < Base
      def initialize
        super(type: "Unknown Operator")
      end
    end
  end
end
