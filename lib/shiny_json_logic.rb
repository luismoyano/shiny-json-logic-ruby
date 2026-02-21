# frozen_string_literal: true

require "shiny_json_logic/version"
require "shiny_json_logic/engine"
require "shiny_json_logic/errors/base"
require "shiny_json_logic/errors/invalid_arguments"
require "shiny_json_logic/errors/not_a_number"
require "shiny_json_logic/errors/unknown_operator"
require "shiny_json_logic/operator_solver"
require "shiny_json_logic/scope_stack"

module ShinyJsonLogic
  def self.apply(rule, data = {})
    validate_operators!(rule)
    
    normalized_data = deep_stringify_keys(data || {})
    scope_stack = ScopeStack.new(normalized_data)
    Engine.call(rule, scope_stack)
  end

  # Recursively converts all hash keys to strings
  def self.deep_stringify_keys(obj)
    case obj
    when Hash
      obj.each_with_object({}) do |(key, value), result|
        result[key.to_s] = deep_stringify_keys(value)
      end
    when Array
      obj.map { |item| deep_stringify_keys(item) }
    else
      obj
    end
  end

  # Validates that all operations in the rule tree use known operators
  def self.validate_operators!(rule)
    case rule
    when Hash
      return if rule.empty?
      
      # Multi-key hashes are invalid
      if rule.size > 1
        raise Errors::UnknownOperator
      end
      
      operation, args = rule.first
      
      # Check if operation is known
      unless OperatorSolver::SOLVERS.key?(operation.to_s)
        raise Errors::UnknownOperator
      end
      
      # Recursively validate args
      validate_operators!(args)
    when Array
      rule.each { |item| validate_operators!(item) }
    end
  end
end

JsonLogic = ShinyJsonLogic
JSONLogic = ShinyJsonLogic
