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
        error_type = e.is_a?(Errors::Base) ? e.type : e.class.to_s
        raise Errors::Base.new(type: error_type)
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
