require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Base
      def initialize(context)
        @context = context
        @rules, @data, @errors = @context.values_at("rules", "data", "errors")
      end

      def call
        deliver run
      rescue StandardError => e # TODO: refine error handling
        error_type = e.is_a?(Errors::Base) ? e.type : e.class.to_s

        Errors::Base.new(type: error_type)
      end

      protected

      attr_reader :rules, :context
      attr_accessor :data, :errors

      def run
        raise NotImplementedError
      end

      def deliver(result = nil)
        {"result" => result, "data" => self.data, "errors" => self.errors}
      end
    end
  end
end
