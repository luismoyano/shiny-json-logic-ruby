require "shiny_json_logic/version"
require "shiny_json_logic/engine"
require "shiny_json_logic/errors/base"
require "shiny_json_logic/operator_solver"
require "shiny_json_logic/scope_stack"

module ShinyJsonLogic
  def self.apply(rule, data = {})
    validate_operators!(rule)
    
    scope_stack = ScopeStack.new(data || {})
    engine = Engine.new(rule, scope_stack)
    engine.call
  end

  # Validates that all operations in the rule tree use known operators
  def self.validate_operators!(rule)
    case rule
    when Hash
      return if rule.empty?
      
      # Multi-key hashes are invalid
      if rule.size > 1
        raise Errors::Base.new(type: "Unknown Operator")
      end
      
      operation, args = rule.first
      
      # Check if operation is known
      unless OperatorSolver.new.solvers.key?(operation)
        raise Errors::Base.new(type: "Unknown Operator")
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
