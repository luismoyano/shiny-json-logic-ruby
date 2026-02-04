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
      end

      protected

      attr_reader :context
      attr_accessor :rules, :data, :errors

      def run
        raise NotImplementedError
      end

      def deliver(result = nil)
        {"result" => result, "data" => self.data, "errors" => self.errors}
      end

      # Evalúa un argumento raw usando el Engine
      def evaluate(rule)
        engine = Engine.new(rule, data)
        result = engine.call
        self.errors = [*errors, *engine.errors].uniq
        result
      end
    end
  end
end
