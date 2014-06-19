class Api::PlayerController < Api::AuthenticatedController
  def index
    render json: current_user.recently_watched_videos
  end
  
  def play
    begin
      @video = fetch_youtube_video params
    rescue
      begin
        @video = fetch_twitch_video params
      rescue
        raise "invalid video"
      end
    end
    @saved_video = current_user.videos.where(url: @video.id).first
    if @saved_video.nil?
      @saved_video = current_user.videos.new browser: user_browser, channel_topic: @video.channel.fetch.id,
                      title: @video.title, url: @video.id, duration: @video.duration, provider: @video.provider
      @saved_video.save
    end
    render json: @video
  end
end