require "shiny_json_logic/operations/base"
require "shiny_json_logic/operations/equal"

module ShinyJsonLogic
  module Operations
    class Different < Base
      def call
        ctx = Operations::Equal.new(context).call
        {"result" => !ctx["result"], "data" => ctx["data"], "errors" => ctx["errors"]}
      end
    end
  end
end