# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class None < Iterable::Base
      raise_on_dynamic_args!

      private

      def on_after(results)
        return true if results.empty?

        results.none? { |res| Truthy.call(res) }
      end
    end
  end
end
