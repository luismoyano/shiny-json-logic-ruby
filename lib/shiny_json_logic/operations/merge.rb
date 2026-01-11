require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class Merge < Base
      def call
        rules.map{Array.wrap(it)}.reduce(:+) || []
      end
    end
  end
end
