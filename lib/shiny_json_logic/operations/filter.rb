require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Filter < Iterable::Base
      raise_on_nil_filter!

      private

      def on_each(item)
        engine = Engine.new(filter, scope_stack: scope_stack)
        [Truthy.call(engine.call) ? item : nil, engine]
      end

      def on_after(results)
        results.compact
      end
    end
  end
end
