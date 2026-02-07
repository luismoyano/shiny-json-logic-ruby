require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Base
      def initialize(context)
        @context = context
        @rules, @errors, @scope_stack = @context.values_at("rules", "errors", "scope_stack")
        @dynamic_args = operation?(@rules)
        @rules = pre_process(@rules)
      end

      def call
        deliver run
      end

      protected

      attr_reader :context, :scope_stack
      attr_accessor :rules, :errors

      # Access current data through scope_stack
      def data
        scope_stack.current
      end

      def run
        raise NotImplementedError
      end

      def deliver(result = nil)
        {"result" => result, "errors" => self.errors}
      end

      def evaluate(rule)
        engine = Engine.new(rule, scope_stack)
        result = engine.call
        self.errors = [*errors, *engine.errors].uniq
        result
      end

      def dynamic_args?
        @dynamic_args && self.class.raise_on_dynamic_args?
      end

      def self.raise_on_dynamic_args!
        @raise_on_dynamic_args = true
      end

      def self.raise_on_dynamic_args?
        @raise_on_dynamic_args
      end

      private

      def pre_process(rules)
        if operation?(rules)
          evaluate(rules)
        else
          rules
        end
      end

      def operation?(value)
        return false unless value.is_a?(Hash) && !value.empty?
        OperatorSolver.new.operation?(value)
      end
    end
  end
end
