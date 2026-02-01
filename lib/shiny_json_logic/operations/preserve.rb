require "shiny_json_logic/truthy"

module ShinyJsonLogic
  module Operations
    class Preserve < Iterable::Base
      def initialize(context)
        super
        @collection = context["rules"] || []
      end

      private

      def on_each(item)
        Engine.new(item, data).then do |engine|
          [engine.call, engine]
        end
      end

      def on_after(results)
        return results.first if results.size == 1

        results
      end

      def on_before_each(_item)
      end
    end
  end
end
