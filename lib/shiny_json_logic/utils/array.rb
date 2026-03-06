# frozen_string_literal: true

module ShinyJsonLogic
  module Utils
    module Array
      module_function

      def wrap(object)
        return [] if object.nil?
        return object if object.is_a?(::Array)

        [object]
      end

      def wrap_nil(object)
        return object if object.is_a?(::Array)

        [object]
      end
    end
  end
end
