require "core_ext/array"
require "core_ext/hash"
Dir[File.join(__dir__, "operations/**/*.rb")].each do |file|
  require file
end

module ShinyJsonLogic
  class OperatorSolver
    def operation?(value)
      value.keys.any? { |key| solvers.key?(key) }
    end

    def solvers
      @@solvers ||= {
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
        "if" => Operations::If,
        "?:" => Operations::If,
        "filter" => Operations::Filter,
        "map" => Operations::Map,
        "reduce" => Operations::Reduce,
        "all" => Operations::All,
        "none" => Operations::None,
        "some" => Operations::Some,
        "preserve" => Operations::Preserve,
      }
    end
  end
end