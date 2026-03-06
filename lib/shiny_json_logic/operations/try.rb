# frozen_string_literal: true

module ShinyJsonLogic
  module Operations
    class Try < Base
      def self.call(rules, scope_stack)
        items = Utils::Array.wrap_nil(rules)
        last_error = nil
        i = 0
        n = items.size

        while i < n
          item = items[i]
          # If previous item was an error, switch context to error payload
          if last_error
            scope_stack.push({})  # intermediate level for [[1]] access
            scope_stack.push(last_error.payload)
          end

          begin
            result = Engine.call(item, scope_stack)

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
          end
          i += 1
        end

        # All items were errors, re-raise the last one
        raise last_error if last_error
      end
    end
  end
end