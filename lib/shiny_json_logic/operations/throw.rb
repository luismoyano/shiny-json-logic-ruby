require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
  class Throw < Base
      protected

      def run
        error_type = ShinyJsonLogic.apply(rules.fetch(0), data)
        raise ShinyJsonLogic::Errors::Base.new(type: error_type)
      end
    end
  end
end