module Player::VideoPlayer

  def fetch_video(params)
    begin
      id = extract_id params
      client = youtube_client "player_video_#{id}"
      video = client.video_by id
      sourcecode = http_request(url: video.player_url).body.encode
      comments = client.comments id
      profile = client.profile video.author.uri.gsub('http://gdata.youtube.com/feeds/api/users/', '')
      { video: video, sourcecode: sourcecode, comments: comments, profile: profile, client: client }
    rescue
      flash[:alert] = t('player.wrong_url') unless @redirecting
      redirect_to player_path unless @redirecting
      false
    end
  end

  def extract_id(params)
    id = nil
    params.each do |key, value|
      logger.debug key
      logger.debug '--'
      logger.debug value
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

end

class YouTubeIt::Model::User
  
  def url
    "http://www.youtube.com/channel/UC#{user_id}"
  end
  
end