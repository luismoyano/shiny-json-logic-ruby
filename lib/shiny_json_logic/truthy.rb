# frozen_string_literal: true

# https://jsonlogic.com/truthy.html

module ShinyJsonLogic
  module Truthy
    def self.call(subject)
      case subject
      when true, false  then subject
      when Numeric      then !subject.zero?
      when String, Hash then !subject.empty?
      when NilClass     then false
      when Array
        i = 0
        n = subject.size
        while i < n
          return true if subject[i]
          i += 1
        end
        false
      else
        true
      end
    end
  end
end
