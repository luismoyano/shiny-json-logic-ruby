# frozen_string_literal: true

require "shiny_json_logic/version"
require "shiny_json_logic/engine"
require "shiny_json_logic/errors/base"
require "shiny_json_logic/errors/invalid_arguments"
require "shiny_json_logic/errors/not_a_number"
require "shiny_json_logic/errors/unknown_operator"
require "shiny_json_logic/operator_solver"
require "shiny_json_logic/scope_stack"

module ShinyJsonLogic
  def self.apply(rule, data = {})
    scope_stack = [data || {}]
    Engine.call(rule, scope_stack)
  end
end

JsonLogic = ShinyJsonLogic
JSONLogic = ShinyJsonLogic
