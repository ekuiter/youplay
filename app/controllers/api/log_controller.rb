class Api::LogController < Api::AuthenticatedController
  def index
    log
  end
  
  def favorites
    log favorited: true
  end
  
  private
  
  def log hash={}
    results = params[:results] ? params[:results].to_i : 25
    page = params[:page] ? params[:page].to_i : 0
    if hash[:favorited]
      videos = current_user.favorited_videos results, page
    else
      videos = current_user.watched_videos results, page
    end
    videos.each do |video|
      video.channel_topic = YouplayChannel.new(id: video.channel_topic, provider: video.provider.to_sym).fetch.name
    end
    render json: videos
  end
end