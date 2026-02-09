require "core_ext/array"
require "core_ext/hash"
require "shiny_json_logic/operator_solver"

module ShinyJsonLogic
  class Engine
    def initialize(rule, scope_stack)
      @rule = rule
      @scope_stack = scope_stack
    end

    def call(rule = self.rule)
      if rule.is_a?(Hash)
        return rule if rule.empty?

        operation, args = rule.to_a.first
        operation_key = operation.to_s
        return rule unless operations.key?(operation_key)

        operations.fetch(operation_key).new(args, scope_stack).call
      elsif rule.is_a?(Array)
        rule.map { |val| call(val) }
      else
        rule
      end
    end

    private

    attr_reader :rule, :scope_stack

    def operations
      @operations ||= OperatorSolver.new.solvers
    end
  end
end