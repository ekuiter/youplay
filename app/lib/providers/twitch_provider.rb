class Providers::TwitchProvider < Provider
  def video_id(params)
    id = nil
    params.each do |key, value|     
      return key if value.nil?       
      return "a#{value.split('/b/').last}" if value.include?('twitch.tv/') && value.include?('/b/')
      return "c#{value.split('/c/').last}" if value.include?('twitch.tv/') && value.include?('/c/')
    end
    raise 'no video id given' if id.blank?
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