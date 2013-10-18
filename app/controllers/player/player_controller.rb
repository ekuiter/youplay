class Player::PlayerController < ApplicationController

  def index
    @recently_watched_videos = current_user.recently_watched_videos
    @title_length = current_user.max_title_length
    @favorited_video_ids = current_user.favorites.map {|f| f.video_id}
  end

  def play
    begin
      @video = fetch_youtube_video params
    rescue
      begin
        @video = fetch_twitch_video params
      rescue
        flash[:alert] = t('player.wrong_url') unless @redirecting
        redirect_to player_path unless @redirecting
        @video = false
      end
    end
    if @video
      @saved_video = current_user.videos.where(url: @video.id).first
      if @saved_video.nil?
        @saved_video = current_user.videos.new browser: user_browser, channel_topic: @video.channel.fetch.id,
                        title: @video.title, url: @video.id, duration: @video.duration, provider: @video.provider
        @saved_video.save
      end
    end
  end
  
  def comment
    begin
      @video = fetch_youtube_video params
      if @video && @video.provider == :youtube && !params[:comment].blank?
        youtube_client.add_comment @video.id, params[:comment]
      end
    rescue
    end
    render nothing: true
  end

end
