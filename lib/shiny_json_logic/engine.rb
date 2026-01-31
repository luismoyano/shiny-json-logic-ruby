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
        operation, raw_args = rule.to_a.first
        if operations.collection_solvers.key?(operation)
          solve(operation, raw_args, data)
        else
          evaluated_args =
            if raw_args.is_a?(Array)
              raw_args.map { |val| call(val, data) }
            else
              Array.wrap(call(raw_args, data))
            end

          solve(operation, evaluated_args, data)
        end
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

    def solve(operation, args, data)
      context = {"rules" => args, "data" => data, "errors" => errors}
      p operation, context
      result, data, errors = operations.solvers.fetch(operation).new(context).call.values_at("result", "data", "errors")
      self.errors = [*self.errors, *errors].uniq
      self.data.merge data
      p "RESULT AFTER #{operation.upcase}: #{result.inspect}"

      result
    end

    def operations
      @operations ||= OperatorSolver.new
    end
  end
end