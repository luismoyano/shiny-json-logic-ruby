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
        return rule unless operations.solvers.key?(operation)

        solve(operation, args)
      elsif rule.is_a?(Array)
        rule.map { |val| call(val) }
      else
        rule
      end
    end

    private

    attr_reader :rule, :scope_stack

    def solve(operation, args)
      context = {
        "rules" => args,
        "scope_stack" => scope_stack
      }
      operations.solvers.fetch(operation).new(context).call
    end

    def operations
      @operations ||= OperatorSolver.new
    end
  end
end