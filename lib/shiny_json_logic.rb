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
require "shiny_json_logic/operations/smaller"
require "shiny_json_logic/operations/smaller_equal"
require "shiny_json_logic/operations/not"
require "shiny_json_logic/operations/or"
require "shiny_json_logic/operations/and"
require "shiny_json_logic/operations/inclusion"
require "shiny_json_logic/operations/concatenation"
require "shiny_json_logic/operations/modulo"
require "shiny_json_logic/operations/max"
require "shiny_json_logic/operations/min"
require "shiny_json_logic/operations/addition"
require "shiny_json_logic/operations/product"
require "shiny_json_logic/operations/subtraction"
require "shiny_json_logic/operations/division"
require "shiny_json_logic/operations/substring"
require "shiny_json_logic/operations/merge"

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
      "<" => Operations::Smaller,
      "<=" => Operations::SmallerEqual,
      "!" => Operations::Not,
      "or" => Operations::Or,
      "and" => Operations::And,
      "?:" => Operations::If,
      "in" => Operations::Inclusion,
      "cat" => Operations::Concatenation,
      "%" => Operations::Modulo,
      "max" => Operations::Max,
      "min" => Operations::Min,
      "+" => Operations::Addition,
      "*" => Operations::Product,
      "-" => Operations::Subtraction,
      "/" => Operations::Division,
      "substr" => Operations::Substring,
      "merge" => Operations::Merge,
    }
  end
end
