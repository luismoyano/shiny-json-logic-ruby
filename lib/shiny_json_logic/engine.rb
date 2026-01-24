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

    def call
      stack   = [[rule, data, :enter]]
      results = []

      while stack.any?
        node, ctx, state = stack.pop

        if state == :exit
          # Already evaluated children, we solve
          if node.is_a?(Hash)
            op, raw_args = node.to_a.first

            if collection_solvers.key?(op)
              results << collection_solvers.fetch(op).new(raw_args, ctx).call
            else
              if raw_args.is_a?(Array)
                argc = raw_args.size
                args = results.pop(argc)
                results << solvers.fetch(op).new(args, ctx).call
              else
                args = Array.wrap(results.pop)
                results << solvers.fetch(op).new(args, ctx).call
              end
            end
          elsif node.is_a?(Array)
            results << results.pop(node.size)
          end

          next
        end

        # ENTER phase
        case node
        when Hash
          op, raw_args = node.to_a.first

          stack << [node, ctx, :exit]

          unless collection_solvers.key?(op)
            if raw_args.is_a?(Array)
              raw_args.reverse_each { |a| stack << [a, ctx, :enter] }
            else
              stack << [raw_args, ctx, :enter]
            end
          end

        when Array
          stack << [node, ctx, :exit]
          node.reverse_each { |n| stack << [n, ctx, :enter] }

        else
          results << node
        end
      end

      results.last
    end

    private

    attr_reader :rule, :data

    def solvers
      @@solvers ||= {
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

    def collection_solvers
      @@collection_solvers ||= {
        "filter" => Operations::Filter,
        "map" => Operations::Map,
        "reduce" => Operations::Reduce,
        "all" => Operations::All,
        "none" => Operations::None,
        "some" => Operations::Some,
      }
    end
  end
end