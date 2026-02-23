# frozen_string_literal: true

module ShinyJsonLogic
  module Utils
    # A Hash subclass that marks its contents as user data (result of var/val).
    # The Engine uses this to skip operator validation for these values.
    class DataHash < Hash
      def self.wrap(obj)
        return obj unless obj.is_a?(Hash)
        return obj if obj.is_a?(DataHash)

        result = new
        obj.each { |k, v| result[k] = v }
        result
      end
    end
  end
end
