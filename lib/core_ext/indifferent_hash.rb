# frozen_string_literal: true

require "delegate"

module ShinyJsonLogic
  class IndifferentHash < SimpleDelegator
    # Make is_a?(Hash) return true so existing code works
    def is_a?(klass)
      klass == Hash || super
    end
    alias kind_of? is_a?

    def [](key)
      obj = __getobj__
      return obj[key] if obj.key?(key)

      alt_key = alternate_key(key)
      return obj[alt_key] if alt_key && obj.key?(alt_key)

      nil
    end

    def fetch(key, *args, &block)
      obj = __getobj__
      return obj.fetch(key, *args, &block) if obj.key?(key)

      alt_key = alternate_key(key)
      return obj.fetch(alt_key, *args, &block) if alt_key && obj.key?(alt_key)

      # Key not found - use original fetch behavior for default/block
      obj.fetch(key, *args, &block)
    end

    def key?(key)
      obj = __getobj__
      return true if obj.key?(key)

      alt_key = alternate_key(key)
      alt_key && obj.key?(alt_key)
    end

    alias has_key? key?
    alias include? key?
    alias member? key?

    def dig(key, *rest)
      value = self[key]
      return value if rest.empty? || value.nil?

      # Wrap nested hash for continued indifferent access
      nested = value.is_a?(Hash) && !value.is_a?(IndifferentHash) ? IndifferentHash.new(value) : value
      nested.dig(*rest)
    end

    def deep_fetch(key, default = nil)
      keys = key.empty? ? [key] : key.to_s.split('.')
      value = dig(*keys) rescue default
      value.nil? ? default : value
    end

    private

    def alternate_key(key)
      case key
      when String
        key.to_sym
      when Symbol
        key.to_s
      end
    end
  end
end
