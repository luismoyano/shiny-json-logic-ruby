require "shiny_json_logic/version"
require "core_ext/array"
require "core_ext/hash"
Dir[File.join(__dir__, "shiny_json_logic/operations/**/*.rb")].each do |file|
  require file
end

module ShinyJsonLogic
  def self.apply(rule, data = {})
    if rule.is_a?(Hash)
      operation, raw_args = rule.to_a.first
      if collection_solvers.key?(operation)
        collection_solvers.fetch(operation).new(raw_args, data).call
      else
        evaluated_args =
          if raw_args.is_a?(Array)
            raw_args.map { |val| apply(val, data) }
          else
            Array.wrap(apply(raw_args, data))
          end

        solvers.fetch(operation).new(evaluated_args, data).call
      end
    elsif rule.is_a?(Array)
      rule.map { |item| apply(item, data) }
    else
      rule
    end
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
      "!!" => Operations::DoubleNot,
      "val" => Operations::Val,
      "??" => Operations::Coalesce,
      "exists" => Operations::Exists,
    }
  end

  def self.collection_solvers
    {
      "filter" => Operations::Filter,
      "map" => Operations::Map,
      "reduce" => Operations::Reduce,
      "all" => Operations::All,
      "none" => Operations::None,
      "some" => Operations::Some,
    }
  end
end
