require "shiny_json_logic/version"
require "core_ext/array"
require "shiny_json_logic/operations/var"

module ShinyJsonLogic
  class Error < StandardError; end


  def self.apply(rule, data = {})
    return rule unless rule.is_a?(Hash)

    transformed_rule = rule.to_a.first
    solvers[transformed_rule.first].new(Array.wrap(transformed_rule.last).map{|val| apply(val, data)}, data).call
  end

  def self.solvers
    {
      "var" => Operations::Var
    }
  end
end
