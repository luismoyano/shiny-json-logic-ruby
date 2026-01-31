require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"
require "shiny_json_logic/numeric/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Reduce < Iterable::Base
      include Numeric::WithErrorHandling

      def initialize(rules, data)
        super
        @accumulator = Engine.new(rules[2], data).call # third argument
      end

      private

      attr_accessor :accumulator

      def on_before_each(_item)
        super
        data["accumulator"] = accumulator
      end

      def on_each(_item)
        self.accumulator = Engine.new(filter, data).call
      end

      def on_after(_results)
        safe_arithmetic do
          self.accumulator
        end
      end

      def current_key
        "current"
      end
    end
  end
end
