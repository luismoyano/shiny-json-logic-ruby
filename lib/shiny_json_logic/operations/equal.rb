require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Equal < Base
      protected

      def run
        rules.map(&:to_s).all? { |v| v == rules[0].to_s }
      end
    end
  end
end