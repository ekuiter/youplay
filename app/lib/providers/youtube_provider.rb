class Providers::YoutubeProvider < Provider
  def video_id(params)
    id = nil
    params.each do |key, value|           
      if value.nil?
        id = key.gsub("youtube:", "") if key.starts_with?("youtube:")
      else
        id = value and break if value.include? 'youtube.com/watch?v='
      end
    end
    split = id.split('v=')
    id = split.length == 2 ? split[1].split('&')[0] : split[0].split('&')[0]
    raise 'no video id given' if id.blank?
    id
  end
  
  def fetch_video(id)
    video = client.video_by id
    channel_name = video.author.uri.gsub('http://gdata.youtube.com/feeds/api/users/', '')
    YouplayVideo.new provider: YouplayProvider.new(instance: self),
                     id: id,
                     title: video.title,
                     url: video.player_url,
                     duration: video.duration,
                     access_control: video.access_control,
                     uploaded_at: video.uploaded_at,
                     topic: video.categories[0].label,
                     views: video.view_count,
                     rating: video.rating,
                     description: video.description,
                     thumbnail: video.thumbnails[1].url,
                     comments: client.comments(id),
                     channel: YouplayChannel.new(name: channel_name)
  end
  
  def player_partial(player_skin)
    player_skin == I18n.t('conf.youtube_player') ? "youtube_embed" : "youtube"
  end
  
  def channel(id)
    channel = client.profile(id) rescue raise("channel not found")
    { id: channel.user_id, name: channel.username_display }
  end
  
  def channel_url(id)
    "http://www.youtube.com/channel/UC#{id}"
  end
  
  def allowed?(video, method)
    return video.access_control['embed'] == 'allowed' if method == :embedding
    return video.access_control['rate'] == 'allowed' if method == :rating
    return video.access_control['comment'] == 'allowed' if method == :commenting
  end
  
  private
  
  def client
    require "youtube_it"
    @client ||= YouTubeIt::Client.new client_id: Settings.client_id, client_secret: Settings.client_secret, dev_key: Settings.developer_key
  end
end