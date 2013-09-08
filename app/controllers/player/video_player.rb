module Player::VideoPlayer

  def fetch_video(params)
    begin
      id = extract_id params
      client = youtube_connect current_user: current_user, state: "player_video_#{id}", access_token: current_user.access_token,
                               refresh_token: current_user.refresh_token, expires_in: current_user.expires_in
      video = client.video_by id
      sourcecode = http_request(url: video.player_url).body.encode
      { video: video, sourcecode: sourcecode }
    rescue
      flash[:alert] = t('player.wrong_url');
      redirect_to player_path
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