class YouplayProvider
  def self.method_missing(method, *args, &block)
    self.new provider: method
  end
  
  def self.providers
    [:youtube, :twitch]
  end
  
  attr_accessor :provider, :instance
  
  def initialize(hash={})
    raise "nor provider neither instance given" if hash[:provider].blank? and hash[:instance].blank?
    hash.each do |key, value|
      instance_variable_set("@#{key}".to_sym, value)
    end
    self.provider = hash[:provider] if hash[:provider]
    self.instance = hash[:instance] if hash[:instance]
  end
  
  def provider=(value)
    raise "invalid provider" if value.to_sym == :youplay
    @instance = Providers.const_get("#{value.capitalize}Provider".to_s).new
    @provider = value.to_sym
  end
  
  def instance=(value)
    @instance = value
    @provider = @instance.provider
  end
  
  def to_s
    provider.to_s
  end
  
  def to_sym
    provider.to_sym
  end
  
  def play_video(params)
    id = @instance.video_id(params)
    @instance.fetch_video(id)
  end
  
  def player_partial(player_skin)
    if @instance.respond_to?(:player_partial)
      @instance.player_partial(player_skin)
    else
      provider.to_s
    end
  end
  
  def video_id(params)
    @instance.video_id(params)
  end
  
  def fetch_video(id)
    @instance.fetch_video(id)
  end
  
  def channel(id)
    @instance.channel(id)
  end
  
  def channel_url(id)
    @instance.channel_url(id)
  end
  
  def allowed?(video, method)
    @instance.allowed?(video, method)
  end
end