# frozen_string_literal: true

require "shiny_json_logic/operator_solver"
require "shiny_json_logic/utils/data_hash"

module ShinyJsonLogic
  module Engine
    OPERATIONS = OperatorSolver::SOLVERS

    def self.call(rule, scope_stack)
      if rule.is_a?(Hash)
        # DataHash marks already-resolved user data — return as-is without dispatch
        return rule if rule.is_a?(Utils::DataHash) || rule.empty?

        raise Errors::UnknownOperator if rule.size > 1

        operation_key = nil
        args = nil
        rule.each { |k, v| operation_key = k.to_s; args = v }

        op = OPERATIONS[operation_key]
        raise Errors::UnknownOperator unless op

        op.call(args, scope_stack)
      elsif rule.is_a?(Array)
        # Use while loop instead of map — avoids Enumerator overhead on Ruby 3.4 no-YJIT
        n = rule.size
        result = Array.new(n)
        i = 0
        while i < n
          result[i] = call(rule[i], scope_stack)
          i += 1
        end
        result
      else
        rule
      end
    end
  end
end

