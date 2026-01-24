require "core_ext/array"
require "core_ext/hash"
Dir[File.join(__dir__, "operations/**/*.rb")].each do |file|
  require file
end

module ShinyJsonLogic
  class Engine
    def initialize(rule, data = {})
      @rule = rule
      @data = data
    end

    def call(rule = self.rule, data = self.data)
      if rule.is_a?(Hash)
        operation, raw_args = rule.to_a.first
        if collection_solvers.key?(operation)
          collection_solvers.fetch(operation).new(raw_args, data).call
        else
          evaluated_args =
            if raw_args.is_a?(Array)
              raw_args.map { |val| call(val, data) }
            else
              Array.wrap(call(raw_args, data))
            end

          solvers.fetch(operation).new(evaluated_args, data).call
        end
      elsif rule.is_a?(Array)
        rule.map { |item| call(item, data) }
      else
        rule
      end
    end

    private

    attr_reader :rule, :data

    def solvers
      @solvers ||= {
        "var" => ::ShinyJsonLogic::Operations::Var,
        "missing" => ::ShinyJsonLogic::Operations::Missing,
        "missing_some" => ::ShinyJsonLogic::Operations::MissingSome,
        "if" => ::ShinyJsonLogic::Operations::If,
        "==" => ::ShinyJsonLogic::Operations::Equal,
        "===" => ::ShinyJsonLogic::Operations::StrictEqual,
        "!=" => ::ShinyJsonLogic::Operations::Different,
        "!==" => ::ShinyJsonLogic::Operations::StrictDifferent,
        ">" => ::ShinyJsonLogic::Operations::Greater,
        ">=" => ::ShinyJsonLogic::Operations::GreaterEqual,
        "<" => ::ShinyJsonLogic::Operations::Smaller,
        "<=" => ::ShinyJsonLogic::Operations::SmallerEqual,
        "!" => ::ShinyJsonLogic::Operations::Not,
        "or" => ::ShinyJsonLogic::Operations::Or,
        "and" => ::ShinyJsonLogic::Operations::And,
        "?:" => ::ShinyJsonLogic::Operations::If,
        "in" => ::ShinyJsonLogic::Operations::Inclusion,
        "cat" => ::ShinyJsonLogic::Operations::Concatenation,
        "%" => ::ShinyJsonLogic::Operations::Modulo,
        "max" => ::ShinyJsonLogic::Operations::Max,
        "min" => ::ShinyJsonLogic::Operations::Min,
        "+" => ::ShinyJsonLogic::Operations::Addition,
        "*" => ::ShinyJsonLogic::Operations::Product,
        "-" => ::ShinyJsonLogic::Operations::Subtraction,
        "/" => ::ShinyJsonLogic::Operations::Division,
        "substr" => ::ShinyJsonLogic::Operations::Substring,
        "merge" => ::ShinyJsonLogic::Operations::Merge,
        "!!" => ::ShinyJsonLogic::Operations::DoubleNot,
        "val" => ::ShinyJsonLogic::Operations::Val,
        "??" => ::ShinyJsonLogic::Operations::Coalesce,
        "exists" => ::ShinyJsonLogic::Operations::Exists,
      }
    end

    def collection_solvers
      @collection_solvers ||= {
        "filter" => ::ShinyJsonLogic::Operations::Filter,
        "map" => ::ShinyJsonLogic::Operations::Map,
        "reduce" => ::ShinyJsonLogic::Operations::Reduce,
        "all" => ::ShinyJsonLogic::Operations::All,
        "none" => ::ShinyJsonLogic::Operations::None,
        "some" => ::ShinyJsonLogic::Operations::Some,
      }
    end
  end
end