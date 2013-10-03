class Player::PlayerController < ApplicationController

  include Player::VideoPlayer

  def index
    @recently_watched_videos = current_user.recently_watched_videos
    @client = youtube_client
    @title_length = current_user.max_title_length
    @favorited_video_ids = current_user.favorites.map {|f| f.video_id}
  end

  def play
    fetched = fetch_video params
    if fetched
      @video = fetched[:video]
      @comments = fetched[:comments]
      @profile = fetched[:profile]
      @saved_video = current_user.videos.where(url: @video.unique_id).first
      if @saved_video.nil?
        @saved_video = current_user.videos.new browser: user_browser, channel_topic: @profile.user_id,
                        title: @video.title, url: @video.unique_id, duration: @video.duration
        @saved_video.save
      end
    end
  end
  
  def comment
    begin
      fetched = fetch_video params
      if fetched && !params[:comment].blank?
        fetched[:client].add_comment fetched[:video].unique_id, params[:comment]
      end
    rescue
    end
    render nothing: true
  end

end
