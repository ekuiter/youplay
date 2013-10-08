class Reader::ReaderController < ApplicationController

  include Reader::MediaReader
  
  skip_before_filter :authenticate_user!, only: [:update, :json]
  
  def update
    unless params[:pass].nil? || params[:pass] != "VtfTNRv1Fv9mrTTa6E6KCFNs1VlPdCyTczZH247ZL9gQCThL69SOjDjJh89yVBfO"
      User.first.update_videos
    end
    render nothing: true
  end

  def index
    @videos = current_user.new_videos
  end
  
  def json
    user = user_from_params
    if user && user.valid_password?(params[:password])
      new_videos = user.new_videos
      new_videos.each do |channel, videos|
        videos.each do |video|
          video.channel = @client.profile(channel).username_display
        end
      end
      render json: new_videos
    else
      render nothing: true
    end
  end
  
  def hide
    params[:videos].each do |video|
      hide_video video
    end
    render nothing: true
  end

  def show
    show_video params[:id]
    redirect_to reader_hidden_path
  end

  def hidden
    @videos = CachedVideo.joins(:hide_videos).where("hide_videos.user_id" => current_user.id).all
  end

  private
  
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == current_user.username && current_user.valid_password?(password)
    end
  end

end
