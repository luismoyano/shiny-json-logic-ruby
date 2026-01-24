require "shiny_json_logic/version"
require "shiny_json_logic/engine"

module ShinyJsonLogic
  def self.apply(rule, data = {})
    Engine.new(rule, data).call
  end
end
