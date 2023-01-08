require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Base
      attr_reader :rules, :data

      def initialize(rules, data)
        @rules = rules
        @data = data
      end

      def call
        raise "Not implemented"
      end
    end
  end
end
