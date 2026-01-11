require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Var < Base
      def call
        return data unless rules.map { |rule| ShinyJsonLogic::Truthy.call(rule) }.reduce(:&)
        return data&.deep_fetch(*rules[0]) || rules[1] if rules.is_a?(Array) && rules.count > 1

        data.deep_fetch(*rules) rescue data
      end
    end
  end
end
