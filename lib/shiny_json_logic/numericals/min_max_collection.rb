require "shiny_json_logic/errors/invalid_arguments"

module ShinyJsonLogic
  module Numericals
    module MinMaxCollection
      private

      def collect_numeric_values
        values = collect_values
        raise Errors::InvalidArguments if values.empty?
        raise Errors::InvalidArguments unless values.all? { |v| v.is_a?(Numeric) }
        values
      end

      def collect_values
        # Logic chaining: if rules is a single operation, expand the result
        # e.g., {"max": {"val": "data"}} where data is [1,2,3] -> max of 1,2,3
        if operation?(rules)
          evaluated = evaluate(rules)
          return wrap_nil(evaluated)
        end

        # Otherwise, rules is an array of arguments - evaluate each without expanding
        # e.g., {"max": [1, 2, 3]} or {"max": [1, {"val": "x"}]}
        # Note: {"max": [{"val": "data"}]} where data is [1,2,3] -> invalid (array is one element)
        result = []
        wrap_nil(rules).each do |rule|
          result << evaluate(rule)
        end
        result
      end
    end
  end
end
