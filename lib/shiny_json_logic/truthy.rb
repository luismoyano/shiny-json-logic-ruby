# frozen_string_literal: true

# https://jsonlogic.com/truthy.html

module ShinyJsonLogic
  module Truthy
    def self.call(subject)
      case subject
      when true, false then subject
      when Numeric     then !subject.zero?
      when String      then !subject.empty?
      when Array       then subject.any?
      when Hash        then !subject.empty?
      when NilClass    then false
      else                  true
      end
    end
  end
end
