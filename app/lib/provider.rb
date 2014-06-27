class Provider
  attr_accessor :provider
  
  def initialize
    self.provider = self.class.name.split("::").last.underscore.split("_").first.to_sym
  end
end