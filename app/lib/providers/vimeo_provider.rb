class Providers::VimeoProvider < Provider
  def video_id(params)
    params.each do |key, value|     
      if value.nil?
        return key.gsub("vimeo:", "") if key.starts_with?("vimeo:")
      else
        return value.split('vimeo.com/').last if value.include?('vimeo.com/')
      end
    end
    raise 'no video id given'
  end
  
  def fetch_video(id)
    videos = Vimeo::Simple::Video.info(id)
    raise "video not found" if videos.response.code == "404"
    video = videos.first
    YouplayVideo.new provider: YouplayProvider.new(instance: self),
                     id: id,
                     title: video['title'],
                     url: video['url'],
                     duration: video['duration'],
                     access_control: video['embed_privacy'],
                     uploaded_at: video['upload_date'].to_datetime,
                     views: video['stats_number_of_plays'],
                     description: video['description'],
                     thumbnail: video['thumbnail_large'],
                     channel: YouplayChannel.new(
                       name: video['user_name'],
                       id: video['user_id']
                     )
  end
  
  def channel(id)
    channel = Vimeo::Simple::User.info(id)
    raise "channel not found" if channel.response.code == "404"
    { id: channel['id'], name: channel['display_name'] }
  end
  
  def channel_url(id)
    "http://vimeo.com/user#{id}"
  end
  
  def allowed?(video, method)
    return video.access_control == "anywhere" if method == :embedding
    return false if method == :rating
    return false if method == :commenting
  end
end