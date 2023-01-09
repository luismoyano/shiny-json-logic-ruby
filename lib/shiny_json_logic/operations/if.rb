require "core_ext/array"
require "core_ext/hash"
require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class If < Base
      def call
        p rules
        rules.each_slice(2) do |condition, value|
          return condition if value.nil?
          return value if condition
        end
      end
    end
  end
end
