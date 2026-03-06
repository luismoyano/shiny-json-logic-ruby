# frozen_string_literal: true

require "shiny_json_logic/utils/hash_fetch"

module ShinyJsonLogic
  # Helpers for navigating the scope stack in nested iterators.
  #
  # The scope stack is a plain Array passed as an argument — no object instantiation.
  # Each entry is a scope (Hash or value). The last entry is the current scope.
  #
  # Entering/exiting a scope:
  #   scope_stack << item   (push)
  #   scope_stack.pop       (pop)
  #   scope_stack.last      (current)
  #
  # Cross-level navigation (val + [[n]] syntax) uses ScopeStack.resolve.
  #
  module ScopeStack
    module_function

    # Resolve a value by going up n levels and then accessing keys.
    # Used by val.rb for {"val": [[n], "key"]} syntax.
    def resolve(stack, levels, keys)
      target_index = stack.size - 1 - levels
      return nil if target_index < 0

      data = stack[target_index]
      keys.empty? ? data : dig_value(data, keys)
    end

    def dig_value(data, keys)
      return nil if data.nil?

      obj = data
      i = 0
      n = keys.size
      while i < n
        return nil if obj.nil?
        obj = Utils::HashFetch.fetch(obj, keys[i].to_s)
        i += 1
      end
      obj
    end
  end
end
