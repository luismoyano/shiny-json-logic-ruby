# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/utils/array"

module ShinyJsonLogic
  module Operations
    class Base
      include Utils::Array

      def initialize(rules, scope_stack)
        @scope_stack = scope_stack
        @dynamic_args = operation?(rules)
        @rules = pre_process(rules)
      end

      def call
        raise NotImplementedError
      end

      protected

      attr_reader :scope_stack
      attr_accessor :rules

      # Access current data through scope_stack
      def data
        scope_stack.current
      end

      def evaluate(rule)
        Engine.call(rule, scope_stack)
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
        return evaluate(rules) if operation?(rules)

        rules
      end

      def operation?(value)
        return false unless value.is_a?(Hash) && !value.empty?

        OperatorSolver.operation?(value)
      end
    end
  end
end
