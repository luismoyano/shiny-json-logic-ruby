# frozen_string_literal: true

require "shiny_json_logic/truthy"
require "shiny_json_logic/operations/iterable/base"

module ShinyJsonLogic
  module Operations
    class All < Iterable::Base
      raise_on_dynamic_args!

      def self.on_each(_item, filter, scope_stack)
        throw(:early_return, false) unless Truthy.call(Engine.call(filter, scope_stack))
      end

      def self.on_after(results, _scope_stack)
        results.empty? ? false : true
      end
    end
  end
end
