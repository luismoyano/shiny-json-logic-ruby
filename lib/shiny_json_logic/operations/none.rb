require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class None < Iterable::Base
      private

      def on_after(results)
        return true if results.empty?

        results.all? { |res| res == false }
      end
    end
  end
end
