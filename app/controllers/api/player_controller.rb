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
  
  def share
    video = play_video params rescue raise "invalid video"
    pp video
    person = current_user.people.find params[:person]
    YouplayMailer.share(current_user, video, person, params[:message]).deliver
    render nothing: true
  end
end