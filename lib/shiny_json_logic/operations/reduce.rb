require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Reduce < Iterable::Base
      def initialize(rules, data)
        super
        @accumulator = ShinyJsonLogic.apply(rules[2], data) # third argument
      end

      private

      attr_accessor :accumulator

      def on_before_each(_item)
        super
        data["accumulator"] = accumulator
      end

      def on_each(_item)
        self.accumulator = ShinyJsonLogic.apply(filter, data)
      end

      def on_after(_results)
        self.accumulator
      end

      def current_key
        "current"
      end
    end
  end
end
