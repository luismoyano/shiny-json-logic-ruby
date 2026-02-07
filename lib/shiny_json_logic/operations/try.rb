require "core_ext/array"

module ShinyJsonLogic
  module Operations
    class Try < Base
      def call
        items = Array.wrap_nil(rules)
        last_error = nil

        items.each do |item|
          # If previous item was an error, switch context to error payload
          if last_error
            scope_stack.push({})  # intermediate level for [[1]] access
            scope_stack.push(last_error.payload)
          end

          begin
            engine = Engine.new(item, scope_stack)
            result = engine.call

            # Pop error contexts if we pushed them
            if last_error
              scope_stack.pop  # error payload
              scope_stack.pop  # intermediate level
            end

            # Found a valid result, return it
            return result
          rescue ShinyJsonLogic::Errors::Base => e
            # Pop error contexts if we pushed them
            if last_error
              scope_stack.pop  # error payload
              scope_stack.pop  # intermediate level
            end

            last_error = e
            # Don't add to errors array - we're handling it
          end
        end

        # All items were errors, re-raise the last one
        raise last_error if last_error
      end
    end
  end
end