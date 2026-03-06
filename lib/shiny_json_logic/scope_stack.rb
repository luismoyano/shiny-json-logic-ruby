# frozen_string_literal: true

require "shiny_json_logic/utils/hash_fetch"

module ShinyJsonLogic
  # Manages a stack of scopes for nested data access in iterators.
  #
  # The scope stack allows:
  # - `current` - returns the top of the stack (current item in iterator)
  # - `resolve(n, *keys)` - go up n levels, then access keys via dig
  # - `push(scope)` / `pop` - manage stack during iteration
  #
  # When inside an iterator like map:
  #   {"val": []} -> returns current scope (the item being iterated)
  #   {"val": [[1], "key"]} -> go up 1 level, access "key"
  #   {"val": [[2], "key"]} -> go up 2 levels, access "key"
  #
  # Note: Data is normalized to string keys upfront in ShinyJsonLogic.apply,
  # so no indifferent access is needed here.
  #
  class ScopeStack
    def initialize(root_data)
      @root  = root_data
      @extra = nil  # nil => stack has exactly 1 element (common case, no allocation)
    end

    # Push a new scope onto the stack (when entering an iteration)
    def push(data)
      if @extra
        @extra << data
      else
        @extra = [@root, data]
      end
    end

    # Pop the top scope (when exiting an iteration)
    def pop
      return unless @extra
      @extra.pop
      @extra = nil if @extra.size == 1
    end

    # Returns the current scope's data (top of stack)
    def current
      @extra ? @extra.last : @root
    end

    # Resolve a value by going up n levels and then accessing keys
    #
    # @param levels [Integer] number of levels to go up (0 = current, 1 = parent, etc.)
    # @param keys [Array] keys to dig into after reaching the target scope
    # @return [Object] the resolved value
    def resolve(levels, *keys)
      if @extra
        target_index = @extra.size - 1 - levels
        return nil if target_index < 0
        data = @extra[target_index]
      else
        return nil if levels > 0
        data = @root
      end

      keys.empty? ? data : dig_value(data, keys)
    end

    private

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
