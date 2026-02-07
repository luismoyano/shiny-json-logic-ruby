require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class Map < Iterable::Base
      raise_on_nil_filter!
      raise_on_dynamic_args!
    end
  end
end
