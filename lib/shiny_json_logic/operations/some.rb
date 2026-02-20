# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Some < Iterable::Base
      raise_on_dynamic_args!

      private

      def on_after(results)
        results.any? { |res| res == true }
      end
    end
  end
end
