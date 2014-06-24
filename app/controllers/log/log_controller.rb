class Log::LogController < ApplicationController
  include ControllerMixins::LogController
  before_filter :set_video, only: [:destroy, :set_favorite, :unset_favorite]
  
  def index
    @search, @collection = search params[:search]
    if @collection.count == 1
      redirect_to @collection.first.play_url
    elsif @collection.count == 0
      redirect_to "#{play_url}?#{params[:search]}"
    else
      log @collection, params[:results], params[:page], true
    end
  end

  def destroy
    @video.destroy
    flash[:notice] = t('video_list.deleted')
    redirect_to request.referer
  end
  
  def set_favorite
    current_user.favorites.new(video: @video).save unless @video.nil?
    render nothing: true
  end
  
  def unset_favorite
    @video.update_attributes favorite: nil unless @video.nil?
    render nothing: true
  end
  
  private
  
  def set_video
    @video = current_user.videos.find params[:id]
  end
end
