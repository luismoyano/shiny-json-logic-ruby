# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Filter < Iterable::Base
      raise_on_nil_filter!
      raise_on_dynamic_args!

      private

      def on_each(item)
        Truthy.call(Engine.call(filter, scope_stack)) ? item : nil
      end

      def on_after(results)
        results.compact
      end
    end
  end
end
