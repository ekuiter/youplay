class Reader::ReaderController < ApplicationController

  include Reader::MediaReader
  
  skip_before_filter :authenticate_user!, only: :update
  
  http_basic_authenticate_with name: '***REMOVED***', password: 'elia593', realm: 'youplay', except: :update
  
  def update
    unless params[:pass].nil? || params[:pass] != "VtfTNRv1Fv9mrTTa6E6KCFNs1VlPdCyTczZH247ZL9gQCThL69SOjDjJh89yVBfO"
      User.first.update_videos
    end
    render nothing: true
  end

  def index
    @videos = current_user.new_videos
    respond_to do |format|
      format.html
      format.json {render json: @videos}
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

end
