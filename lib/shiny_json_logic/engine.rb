require "core_ext/array"
require "core_ext/hash"
require "shiny_json_logic/operator_solver"

module ShinyJsonLogic
  class Engine
    attr_reader :errors

    def initialize(rule, data = {})
      @rule = rule
      @data = data || {}
      @errors = []
    end

    def call(rule = self.rule, data = self.data)
      if rule.is_a?(Hash)
        return rule if rule.empty?

        operation, raw_args = rule.to_a.first
        args = raw_args.is_a?(Array) ? raw_args : [raw_args]
        solve(operation, args, data)
      elsif rule.is_a?(Array)
        rule.map { |val| call(val, data) }
      else
        rule
      end
    end

    private

    attr_reader :rule
    attr_accessor :data
    attr_writer :errors

    def solve(operation, args, initial_data)
      context = {"rules" => args, "data" => initial_data, "errors" => errors}
      result, data, errors = operations.solvers.fetch(operation).new(context).call.values_at("result", "data", "errors")
      self.errors = [*self.errors, *errors].uniq
      self.data.merge data if self.data.is_a?(Hash) && data.is_a?(Hash)

      result
    end

    def operations
      @operations ||= OperatorSolver.new
    end
  end
end