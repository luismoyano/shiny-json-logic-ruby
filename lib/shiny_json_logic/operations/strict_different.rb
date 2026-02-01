require "shiny_json_logic/operations/base"
require "shiny_json_logic/operations/strict_equal"

module ShinyJsonLogic
  module Operations
    class StrictDifferent < Base
      def call
        ctx = Operations::StrictEqual.new(context).call
        {"result" => !ctx["result"], "data" => ctx["data"], "errors" => ctx["errors"]}
      end
    end
  end
end