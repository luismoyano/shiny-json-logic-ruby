require "core_ext/array"
require "core_ext/hash"
require "shiny_json_logic/operator_solver"

module ShinyJsonLogic
  class Engine
    attr_reader :errors

    def initialize(rule, scope_stack)
      @rule = rule
      @errors = []
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
    attr_writer :errors

    def solve(operation, args)
      context = {
        "rules" => args,
        "errors" => errors,
        "scope_stack" => scope_stack
      }
      result, errors = operations.solvers.fetch(operation).new(context).call.values_at("result", "errors")
      self.errors = [*self.errors, *errors].uniq

      result
    end

    def operations
      @operations ||= OperatorSolver.new
    end
  end
end