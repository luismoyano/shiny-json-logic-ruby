# frozen_string_literal: true

require "shiny_json_logic/operator_solver"

module ShinyJsonLogic
  module Engine
    OPERATIONS = OperatorSolver::SOLVERS

    def self.call(rule, scope_stack)
      if rule.is_a?(Hash)
        return rule if rule.empty?

        operation, args = rule.to_a.first
        operation_key = operation.to_s
        
        return rule unless OPERATIONS.key?(operation_key)

        OPERATIONS.fetch(operation_key).new(args, scope_stack).call
      elsif rule.is_a?(Array)
        rule.map { |val| call(val, scope_stack) }
      else
        rule
      end
    end
  end
end
