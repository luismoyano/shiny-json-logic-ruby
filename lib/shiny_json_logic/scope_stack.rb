# frozen_string_literal: true

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
    attr_reader :stack

    def initialize(root_data)
      @root_data = root_data
      @stack = [[@root_data, 0]]
    end

    # Push a new scope onto the stack (when entering an iteration)
    def push(data, index: 0)
      stack.push([data, index])
    end

    # Pop the top scope (when exiting an iteration)
    def pop
      stack.pop if stack.size > 1
    end

    # Returns the current scope's data (top of stack)
    def current
      stack.last[0]
    end

    # Resolve a value by going up n levels and then accessing keys
    # 
    # @param levels [Integer] number of levels to go up (0 = current, 1 = parent, etc.)
    # @param keys [Array] keys to dig into after reaching the target scope
    # @return [Object] the resolved value
    def resolve(levels, *keys)
      target_index = stack.size - 1 - levels
      return nil if target_index < 0

      scope = stack[target_index]
      return nil unless scope
      
      data = scope[0]

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
        
        if obj.is_a?(Hash)
          # Normalize key to string for lookup
          obj[key.to_s]
        elsif obj.is_a?(Array)
          # Convert string keys to integers for arrays
          index = key.is_a?(String) ? key.to_i : key
          obj[index]
        else
          nil
        end
      end
    end
  end
end
