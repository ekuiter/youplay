class Provider
  attr_accessor :provider
  
  def initialize
    self.provider = self.class.name.split("::").last.underscore.gsub("_provider", "").to_sym
  end
end