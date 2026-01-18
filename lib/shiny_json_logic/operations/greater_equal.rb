require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class GreaterEqual < Base
      def call
        # p rules, data
        rules.map(&:to_f).each_cons(2).all? { |a, b| a.to_f >= b.to_f }
      end
    end
  end
end