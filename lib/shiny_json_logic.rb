require "shiny_json_logic/version"
require "core_ext/array"
require "shiny_json_logic/operations/var"
require "shiny_json_logic/operations/missing"
require "shiny_json_logic/operations/missing_some"
require "shiny_json_logic/operations/if"
require "shiny_json_logic/operations/equal"
require "shiny_json_logic/operations/strict_equal"
require "shiny_json_logic/operations/different"
require "shiny_json_logic/operations/strict_different"
require "shiny_json_logic/operations/greater"
require "shiny_json_logic/operations/greater_equal"

module ShinyJsonLogic
  class Error < StandardError; end

  def self.apply(rule, data = {})
    return rule unless rule.is_a?(Hash)

    transformed_rule = rule.to_a.first
    solvers[transformed_rule.first].new(Array.wrap(transformed_rule.last).map{|val| apply(val, data)}, data).call
  end

  def self.solvers
    {
      "var" => Operations::Var,
      "missing" => Operations::Missing,
      "missing_some" => Operations::MissingSome,
      "if" => Operations::If,
      "==" => Operations::Equal,
      "===" => Operations::StrictEqual,
      "!=" => Operations::Different,
      "!==" => Operations::StrictDifferent,
      ">" => Operations::Greater,
      ">=" => Operations::GreaterEqual,
    }
  end
end
