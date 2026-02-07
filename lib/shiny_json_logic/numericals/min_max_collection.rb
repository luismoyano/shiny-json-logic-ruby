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
        result = []
        Array.wrap_nil(rules).each do |rule|
          evaluated = evaluate(rule)
          # If rule was an operation (Hash), expand the result array
          # If rule was a literal array, it's invalid (will fail numeric check)
          if operation?(rule)
            Array.wrap_nil(evaluated).each { |val| result << val }
          else
            result << evaluated
          end
        end
        result
      end
    end
  end
end
