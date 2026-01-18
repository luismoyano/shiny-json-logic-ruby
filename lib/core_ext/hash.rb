class Hash
  def deep_fetch(key, default = nil)
    keys = key.empty? ? [key] : key.to_s.split('.')
    value = dig(*keys) rescue default
    value.nil? ? default : value  # value can be false (Boolean)
  end
end
