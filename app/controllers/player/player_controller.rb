class Player::PlayerController < ApplicationController

  include Player::VideoPlayer

  def index
    @recently_watched_videos = current_user.recently_watched_videos
  end

  def video
    begin
      fetched = fetch_video params
    @video = fetched[:video]
    #sourcecode = fetched[:sourcecode]
    @downloads = fetched[:downloads]
    logger.debug @downloads.to_yaml
    current_user.videos.create browser: user_browser, channel_topic: @video.author.name, title: @video.title, url: @video.unique_id
    rescue
      bad_request
    end
  end

  #def video_download
  #  begin
  #    fetched = fetch_video params
  #  rescue
  #    bad_request
  #  end
  #  downloads = fetched[:downloads]
  #  download_url = nil
  #  downloads.each do |download|
  #    if download[:itag] == params[:itag].to_i
  #      download_url = download[:url]
  #      break
  #    end
  #  end
  #  if download_url
  #    send_file download_url
  #  else
  #    bad_request
  #  end
  #end

  def broadcast

  end

end
