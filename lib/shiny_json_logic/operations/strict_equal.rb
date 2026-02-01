require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class StrictEqual < Base
      protected

      def run
        casted = rules.map do |value|
          value.is_a?(Numeric) ? value.to_f : value
        end

        casted.all? { |v| v == casted[0] }
      end
    end
  end
end