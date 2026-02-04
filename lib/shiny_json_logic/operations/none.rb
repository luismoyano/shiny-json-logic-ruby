require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class None < Iterable::Base
      private

      def on_after(results)
        return true if results.empty?

        results.none? { |res| Truthy.call(res) }
      end
    end
  end
end
