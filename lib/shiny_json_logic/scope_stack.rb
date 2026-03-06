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
      @data_stack  = [root_data]
      @index_stack = [0]
    end

    # Push a new scope onto the stack (when entering an iteration)
    def push(data, index: 0)
      @data_stack  << data
      @index_stack << index
    end

    # Pop the top scope (when exiting an iteration)
    def pop
      if @data_stack.size > 1
        @data_stack.pop
        @index_stack.pop
      end
    end

    # Returns the current scope's data (top of stack)
    def current
      @data_stack.last
    end

    # Resolve a value by going up n levels and then accessing keys
    #
    # @param levels [Integer] number of levels to go up (0 = current, 1 = parent, etc.)
    # @param keys [Array] keys to dig into after reaching the target scope
    # @return [Object] the resolved value
    def resolve(levels, *keys)
      target_index = @data_stack.size - 1 - levels
      return nil if target_index < 0

      data = @data_stack[target_index]

      if keys.empty?
        data
      else
        dig_value(data, keys)
      end
    end

    private

    def dig_value(data, keys)
      return nil if data.nil?

      keys.reduce(data) do |obj, key|
        return nil if obj.nil?
        Utils::HashFetch.fetch(obj, key.to_s)
      end
    end
  end
end
