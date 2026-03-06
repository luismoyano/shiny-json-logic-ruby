# frozen_string_literal: true

module ShinyJsonLogic
  module Utils
    module Array
      module_function

      def wrap(object)
        return [] if object.nil?
        return object if object.is_a?(::Array)
        return object.to_ary || [object] if object.respond_to?(:to_ary)

        [object]
      end

      def wrap_nil(object)
        return [nil] if object.nil?
        return object if object.is_a?(::Array)

        wrap(object)
      end
    end
  end
end
