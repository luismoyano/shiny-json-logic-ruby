require "core_ext/array"
require "core_ext/hash"
require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/base"

module ShinyJsonLogic
  module Operations
    class If < Base
      def call
        rules.each_slice(2) do |condition, value|
          return condition if value.nil?
          return value if Truthy.call(condition)
        end

        nil
      end
    end
  end
end
