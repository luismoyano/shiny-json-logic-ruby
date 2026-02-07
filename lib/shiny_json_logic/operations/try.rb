require "core_ext/array"

module ShinyJsonLogic
  module Operations
    class Try < Base
      SHINY_ERROR_PATTERN = /shiny_error_[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i

      protected

      def run
        items = Array.wrap_nil(rules)
        last_error = nil

        items.each do |item|
          # If previous item was an error, switch context to error payload
          # Push two levels to match iterator convention:
          # - Level 1: empty context (like iterator's index context)
          # - Level 0: error payload (like iterator's current item)
          if last_error
            scope_stack.push({})  # intermediate level for [[1]] access
            scope_stack.push(last_error.payload)
          end

          engine = Engine.new(item, scope_stack)
          result = engine.call

          # Pop error contexts if we pushed them
          if last_error
            scope_stack.pop  # error payload
            scope_stack.pop  # intermediate level
          end

          # Check if result is an error
          if result.is_a?(String) && result.match?(SHINY_ERROR_PATTERN)
            # Find the error object
            last_error = engine.errors.find { |e| e.id == result }
          else
            # Found a valid result, return it
            return result
          end
        end

        # All items were errors, re-raise the last one
        if last_error
          self.errors = [last_error]
          last_error.id
        end
      end
    end
  end
end