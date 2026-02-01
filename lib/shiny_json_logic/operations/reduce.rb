require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"
require "shiny_json_logic/numericals/with_error_handling"

module ShinyJsonLogic
  module Operations
    class Reduce < Iterable::Base
      include Numericals::WithErrorHandling

      def initialize(context)
        super
        @accumulator = Engine.new(context.dig("rules", 2), context["data"]).call # third argument
      end

      private

      attr_accessor :accumulator

      def on_before_each(_item)
        super
        data["accumulator"] = accumulator
      end

      def on_each(_item)
        engine = Engine.new(filter, data)
        self.accumulator = engine.call
        [self.accumulator, engine]
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
