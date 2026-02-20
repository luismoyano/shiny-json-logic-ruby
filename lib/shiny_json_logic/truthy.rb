# frozen_string_literal: true

# https://jsonlogic.com/truthy.html

module ShinyJsonLogic
  module Truthy
    def self.call(subject)
      return subject if [true, false].include? subject
      return !subject.zero?	if subject.is_a? Numeric
      return subject.any? if subject.is_a? Array
      return !subject.empty? if subject.is_a? String
      return subject.keys.any? if subject.is_a? Hash

      !subject.nil?
    end
  end
end
