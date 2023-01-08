# https://jsonlogic.com/truthy.html

module ShinyJsonLogic
  module Truthy
    def self.call(subject)
      return !subject.zero?	if subject.is_a? Numeric
      return subject.any? if subject.is_a? Array
      return !subject.empty? if subject.is_a? String

      !subject.nil?
    end
  end
end
