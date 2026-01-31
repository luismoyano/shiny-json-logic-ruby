require "core_ext/array"
require "core_ext/hash"
Dir[File.join(__dir__, "operations/**/*.rb")].each do |file|
  require file
end

module ShinyJsonLogic
  class OperatorSolver
    def operation?(value)
      value.keys.any? { |key| solvers.key?(key) || collection_solvers.key?(key) }
    end

    def solvers
      @@solvers = { **single_solvers, **collection_solvers }
    end

    def single_solvers
      @@single_solvers ||= {
        "var" => Operations::Var,
        "missing" => Operations::Missing,
        "missing_some" => Operations::MissingSome,
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
        "throw" => Operations::Throw,
        "try" => Operations::Try,
      }
    end

    def collection_solvers
      @@collection_solvers ||= {
        "if" => Operations::If,
        "filter" => Operations::Filter,
        "map" => Operations::Iterable::Base,
        "reduce" => Operations::Reduce,
        "all" => Operations::All,
        "none" => Operations::None,
        "some" => Operations::Some,
      }
    end
  end
end