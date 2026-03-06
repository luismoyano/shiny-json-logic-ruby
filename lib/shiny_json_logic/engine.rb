# frozen_string_literal: true

require "shiny_json_logic/operator_solver"
require "shiny_json_logic/utils/data_hash"

module ShinyJsonLogic
  module Engine
    OPERATIONS = OperatorSolver::SOLVERS

    def self.call(rule, scope_stack)
      if rule.is_a?(Utils::DataHash)
        rule
      elsif rule.is_a?(Hash)
        return rule if rule.empty?

        raise Errors::UnknownOperator if rule.size > 1

        operation, args = rule.first
        operation_key = operation.to_s

        op = OPERATIONS[operation_key]
        raise Errors::UnknownOperator unless op

        op.call(args, scope_stack)
      elsif rule.is_a?(Array)
        rule.map { |val| call(val, scope_stack) }
      else
        rule
      end
    end
  end
end

