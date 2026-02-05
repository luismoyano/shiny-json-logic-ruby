require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Concatenation < Base
      protected

      def run
        result = []
        rules.each do |rule|
          evaluated = evaluate(rule)
          Array.wrap_nil(evaluated).each { |v| result << v.to_s }
        end
        result.join
      end
    end
  end
end
