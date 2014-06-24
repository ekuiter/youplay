module Providers
  require 'youtube_it'
  
  def self.youtube_client
    return @youtube_client if @youtube_client
    @youtube_client = YouTubeIt::Client.new client_id: Settings::client_id, client_secret: Settings::client_secret, dev_key: Settings::developer_key
  end
  
  def self.twitch_client
    return @twitch_client if @twitch_client
    require 'twitch'
    @twitch_client = Twitch.new
  end

  def self.fetch_youtube_video(hash)
    id = extract_youtube_id hash
    client = Providers::youtube_client
    raw_video = client.video_by id
    channel = YouplayChannel.new(id: raw_video.author.uri.gsub('http://gdata.youtube.com/feeds/api/users/', ''))
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
                     channel: channel
  end
  
  def self.fetch_twitch_video(hash)
    id = extract_twitch_id hash
    raw_video = Providers::twitch_client.getVideo(id)[:body]
    channel = YouplayChannel.new(id: raw_video['channel']['name'])
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
                     channel: channel,
                     embed_id: id.gsub("a", "").gsub("c", ""),
                     embed_type: (id.starts_with?("a") ? :archive_id : :chapter_id)
  end
  
  private

  def self.extract_youtube_id(hash)
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

  def self.extract_twitch_id(hash)
    id = nil
    hash.each do |key, value|
      if value.nil?
        id = key
        break
      elsif value.include?('twitch.tv/') && value.include?('/b/')
        id = value.split('/b/').last
        return "a#{id}"
      elsif value.include?('twitch.tv/') && value.include?('/c/')
        id = value.split('/c/').last
        return "c#{id}"
      end
    end
    raise 'no video id given' if id.blank?
    id
  end
end