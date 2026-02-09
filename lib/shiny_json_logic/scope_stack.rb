# frozen_string_literal: true

require "core_ext/indifferent_hash"

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
  class ScopeStack
    attr_reader :stack

    def initialize(root_data)
      @root_data = wrap_indifferent(root_data)
      @stack = [{ data: @root_data, index: 0 }]
    end

    # Push a new scope onto the stack (when entering an iteration)
    def push(data, index: 0)
      stack.push({ data: wrap_indifferent(data), index: index })
    end

    # Pop the top scope (when exiting an iteration)
    def pop
      stack.pop if stack.size > 1
    end

    # Returns the current scope's data (top of stack)
    def current
      stack.last[:data]
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
      
      data = scope[:data]

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
        
        result = if obj.is_a?(Hash)
          obj[key]
        elsif obj.is_a?(Array)
          # Convert string keys to integers for arrays
          index = key.is_a?(String) ? key.to_i : key
          obj[index]
        else
          nil
        end

        # Wrap nested hashes for indifferent access
        result.is_a?(Hash) && !result.is_a?(IndifferentHash) ? IndifferentHash.new(result) : result
      end
    end

    def wrap_indifferent(obj)
      if obj.is_a?(IndifferentHash)
        obj
      elsif obj.is_a?(Hash)
        IndifferentHash.new(obj)
      else
        obj
      end
    end
  end
end
