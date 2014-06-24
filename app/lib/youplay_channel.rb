class YouplayChannel
  attr_accessor :id, :name, :provider
  
  def initialize(hash={})
    hash.each do |key, value|
      instance_variable_set("@#{key}".to_sym, value)
    end
  end
  
  def fetch(channels = nil)
    return self if @id && @name
    profile = if channels
      channels.select {|c| c.channel_id == @id and c.provider == @provider.to_s }
    else
      Channel.where(channel_id: @id, provider: @provider)
    end.first
    if profile
      @id = profile.channel_id
      @name = profile.channel_name
      return self
    end
    if @provider == :youtube
      profile = Providers::youtube_client.profile(@id)
      @id = profile.user_id
      @name = profile.username_display
    elsif @provider == :twitch
      profile = Providers::twitch_client.getChannel(@id)[:body]
      @id = profile['name']
      @name = profile['display_name']
    else
      raise 'no provider given'
    end
    Channel.create channel_id: @id, channel_name: @name, provider: @provider
    self
  end
  
  def url
    return "http://www.youtube.com/channel/UC#{id}" if provider == :youtube
    return "http://www.twitch.tv/#{id}" if provider == :twitch
  end
  
  def link
    "<a href=\"#{fetch.url}\" target=\"_blank\">#{fetch.name}</a>".html_safe
  end
end