require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Base
      def initialize(rules, data)
        @rules = rules
        @data = data
      end

      def call
        run
      rescue StandardError => e # TODO: refine error handling
        raise Errors::Base.new(type: e.class.to_s)
      end

      protected

      attr_reader :rules
      attr_accessor :data

      def run
        raise NotImplementedError, "Subclasses must implement the run method"
      end
    end
  end
end
