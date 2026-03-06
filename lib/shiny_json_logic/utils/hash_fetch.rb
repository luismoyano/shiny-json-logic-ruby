# frozen_string_literal: true

module ShinyJsonLogic
  module Utils
    module HashFetch
      module_function

      # Fetches a value from a Hash or Array using a string key, with symbol fallback.
      #
      # For Hash: tries string key first, then symbol key. Uses key? to correctly
      # distinguish "key missing" from "key present with nil value".
      # For Array: converts key to integer index.
      #
      # This allows callers to skip deep_stringify_keys upfront while still
      # supporting Ruby data hashes with symbol keys (the common real-world case).
      def fetch(obj, key_s)
        if obj.is_a?(::Hash)
          if obj.key?(key_s)
            obj[key_s]
          else
            sym = key_s.to_sym
            obj.key?(sym) ? obj[sym] : nil
          end
        elsif obj.is_a?(::Array)
          obj[key_s.to_i]
        end
      end
    end
  end
end
