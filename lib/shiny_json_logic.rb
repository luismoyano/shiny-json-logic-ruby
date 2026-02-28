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
    normalized_data = deep_stringify_keys(data || {})
    scope_stack = ScopeStack.new(normalized_data)
    Engine.call(rule, scope_stack)
  end

  # Recursively converts all hash keys to strings.
  # Fast path: if all keys are already strings, skip the copy.
  def self.deep_stringify_keys(obj)
    case obj
    when Hash
      return obj if obj.keys.all? { |k| k.is_a?(String) }
      obj.each_with_object({}) do |(key, value), result|
        result[key.to_s] = deep_stringify_keys(value)
      end
    when Array
      obj.map { |item| deep_stringify_keys(item) }
    else
      obj
    end
  end
end

JsonLogic = ShinyJsonLogic
JSONLogic = ShinyJsonLogic
