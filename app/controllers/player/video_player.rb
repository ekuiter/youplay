module Player::VideoPlayer

  def fetch_youtube_video(hash)
    id = extract_youtube_id hash
    client = youtube_client "player_video_#{id}"
    raw_video = client.video_by id
    YouplayVideo.new id: id,
                     title: raw_video.title,
                     url: raw_video.player_url,
                     duration: raw_video.duration,
                     access_control: raw_video.access_control,
                     uploaded_at: raw_video.uploaded_at,
                     topic: raw_video.categories[0].label,
                     provider: :youtube,
                     views: raw_video.view_count,
                     rating: raw_video.rating,
                     description: raw_video.description,
                     thumbnail: raw_video.thumbnails[1].url,
                     comments: client.comments(id),
                     channel: YouplayChannel.new(id: raw_video.author.uri.gsub('http://gdata.youtube.com/feeds/api/users/', ''))
  end
  
  def fetch_twitch_video(hash)
    id = extract_twitch_id hash
    raw_video = twitch_client.getVideo(id)[:body]
    profile = 
    YouplayVideo.new id: id,
                     title: raw_video['title'],
                     url: raw_video['url'],
                     duration: raw_video['length'],
                     access_control: {},
                     uploaded_at: raw_video['recorded_at'].to_datetime,
                     topic: raw_video['game'],
                     provider: :twitch,
                     views: raw_video['views'],
                     description: raw_video['description'],
                     thumbnail: raw_video['preview'],
                     channel: YouplayChannel.new(id: raw_video['channel']['name'])
  end

  def extract_youtube_id(hash)
    id = nil
    hash.each do |key, value|
      if key.include? 'youtube.com/watch?v' || key == 'v' || key == 'url'
        id = value
        break
      elsif value.nil?
        id = key
        break
      elsif value.include? 'youtube.com/watch?v='
        id = value
        break
      end
    end
    split = id.split('v=')
    id = split.length == 2 ? split[1].split('&')[0] : split[0].split('&')[0]
    raise 'no video id given' if id.blank?
    id
  end

  def extract_twitch_id(hash)
    id = nil
    hash.each do |key, value|
      if value.nil?
        id = key
        break
      elsif value.include?('twitch.tv/') && value.include?('/b/')
        id = value.split('/b/')[1]
        break
      end
    end
    raise 'no video id given' if id.blank?
    return "a#{id}" unless id.starts_with? 'a'
    id
  end
  
  class YouplayVideo    
    attr_accessor :id, :url, :title, :duration, :access_control, :uploaded_at, :topic, :views, :rating, :description, :thumbnail, :channel, :comments, :provider
    
    def initialize(hash={})
      hash.each do |key, value|
        instance_variable_set("@#{key}".to_sym, value)
      end
      @channel.provider = @provider if @channel
    end
    
    def channel=(value)
      @channel = value
      @channel.provider = @provider
    end
  end
  
  class YouplayChannel
    attr_accessor :id, :name, :provider
    
    def initialize(hash={})
      hash.each do |key, value|
        instance_variable_set("@#{key}".to_sym, value)
      end
    end
    
    include YoutubeConnector
    
    def fetch
      return self if @id && @name
      profile = Channel.where(channel_id: @id, provider: @provider).first
      if profile
        @id = profile.channel_id
        @name = profile.channel_name
        return self
      end
      if @provider == :youtube
        profile = youtube_client.profile(@id)
        @id = profile.user_id
        @name = profile.username_display
      elsif @provider == :twitch
        profile = twitch_client.getChannel(@id)[:body]
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

end