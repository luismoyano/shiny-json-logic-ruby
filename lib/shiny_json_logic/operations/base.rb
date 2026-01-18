require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Base
      def initialize(rules, data)
        @rules = rules
        @data = data
      end

      def call
        raise "Not implemented"
      end

      protected

      attr_reader :rules
      attr_accessor :data
    end
  end
end
