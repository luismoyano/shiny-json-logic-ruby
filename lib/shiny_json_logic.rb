require "shiny_json_logic/version"
require "shiny_json_logic/engine"

module ShinyJsonLogic
  def self.apply(rule, data = {})
    engine = Engine.new(rule, data)
    engine.call.tap do |result|
      raise engine.errors.shift if engine.errors.any?

      result
    end
  end
end

JsonLogic = ShinyJsonLogic
JSONLogic = ShinyJsonLogic
