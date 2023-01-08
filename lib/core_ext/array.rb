require 'backport_dig' if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.3')

class Array
  def self.wrap(object)
    if object.nil?
      []
    elsif object.respond_to?(:to_ary)
      object.to_ary || [object]
    else
      [object]
    end
  end

  def deep_fetch(index, default = nil)
    indexes = index.to_s.split('.').map(&:to_i)
    value = dig(*indexes) rescue default
    value.nil? ? default : value  # value can be false (Boolean)
  end
end
