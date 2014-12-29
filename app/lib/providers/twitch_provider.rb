class Providers::TwitchProvider < Provider
  def name
    "Twitch"
  end
  
  def video_id(params)
    params.each do |key, value|     
      if value.nil?
        return key.gsub("twitch:", "") if key.starts_with?("twitch:")
      else
        return "a#{value.split('/b/').last}" if value.include?('twitch.tv/') && value.include?('/b/')
        return "c#{value.split('/c/').last}" if value.include?('twitch.tv/') && value.include?('/c/')
      end
    end
    raise 'no video id given'
  end
  
  def fetch_video(id)
    video = client.getVideo(id)[:body]
    YouplayVideo.new provider: YouplayProvider.new(instance: self),
                     id: id,
                     title: video['title'],
                     url: video['url'],
                     duration: video['length'],
                     access_control: {},
                     uploaded_at: video['recorded_at'].to_datetime,
                     topic: video['game'],
                     views: video['views'],
                     description: video['description'],
                     thumbnail: video['preview'],
                     channel: YouplayChannel.new(id: video['channel']['name']),
                     embed_id: id.gsub("a", "").gsub("c", ""),
                     embed_type: (id.starts_with?("a") ? :archive_id : :chapter_id)
  end
  
  def channel(id)
    channel = client.getChannel(id)[:body]
    raise "channel not found" if channel["error"]
    { id: channel['name'], name: channel['display_name'] }
  end
  
  def channel_url(id)
    "http://www.twitch.tv/#{id}"
  end
  
  def allowed?(video, method)
    return true if method == :embedding
    return false if method == :rating
    return false if method == :commenting
  end
  
  private
  
  def client
    require 'twitch'
    @client = Twitch.new
  end
end
