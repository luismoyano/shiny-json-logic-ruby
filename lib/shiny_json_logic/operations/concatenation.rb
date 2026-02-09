require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Concatenation < Base
      def call
        result = []
        wrap_nil(rules).each do |rule|
          evaluated = evaluate(rule)
          wrap_nil(evaluated).each { |v| result << v.to_s }
        end
        result.join
      end
    end
  end
end
