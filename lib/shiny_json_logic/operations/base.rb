# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/utils/array"

module ShinyJsonLogic
  module Operations
    class Base
      extend Utils::Array

      def self.call(rules, scope_stack)
        execute(resolve_rules(rules, scope_stack), scope_stack)
      end

      def self.resolve_rules(rules, scope_stack)
        dynamic = op?(rules)
        raise Errors::InvalidArguments if dynamic && raise_on_dynamic_args?

        return Engine.call(rules, scope_stack) if dynamic
        rules
      end

      def self.execute(_rules, _scope_stack)
        raise NotImplementedError
      end

      def self.raise_on_dynamic_args!
        @raise_on_dynamic_args = true
      end

      def self.raise_on_dynamic_args?
        @raise_on_dynamic_args
      end

      def self.evaluate(rule, scope_stack)
        Engine.call(rule, scope_stack)
      end

      def self.op?(value)
        return false unless value.is_a?(Hash)
        return false if value.empty?

        OperatorSolver.operation?(value)
      end
    end
  end
end
