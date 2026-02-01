require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class All < Iterable::Base
      private

      def on_after(results)
        return false if results.empty?

        results.all? { |res| res == true }
      end
    end
  end
end
