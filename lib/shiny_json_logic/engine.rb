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
                child = results.pop

                args =
                  if child.nil?
                    []
                  elsif child.is_a?(Array)
                    child
                  else
                    [child]
                  end

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
      @@collection_solvers ||= {
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