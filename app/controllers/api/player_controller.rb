class Api::PlayerController < Api::AuthenticatedController
  include ControllerMixins::PlayerController
  include ControllerMixins::LogController
  
  def index
    render json: videos_with_channel_names(current_user.recently_watched_videos)
  end
  
  def play
    @video = play_video params rescue raise "invalid video"
    render json: @video
  end

  def category
    info = id_from_params
    puts info[:provider]
    puts info[:id]
    video = current_user.videos.where(provider: info[:provider], url: info[:id]).first
    raise "invalid video" if video.nil?
    if params[:category].to_i == -1
      category = nil
    else
      category = current_user.categories.find params[:category]
    end
    video.update_attributes category: category
    render nothing: true
  end
  
  def share
    video = play_video params rescue raise "invalid video"
    person = current_user.people.find params[:person]
    YouplayMailer.share(current_user, video, person, params[:message]).deliver
    render nothing: true
  end
end
