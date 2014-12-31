class Log::LogController < ApplicationController
  include ControllerMixins::LogController
  before_filter :set_video, only: [:destroy, :set_favorite, :unset_favorite]
  
  def index
    @categories = current_user.categories.map { |c| [c.name, c.id] }    
    @collection, @search, @search_type, @search_subject = figure_collection(params[:search])
    if @collection.count == 1
      redirect_to @collection.first.play_url
    elsif @collection.count == 0
      redirect_to "#{play_url}?url=#{params[:search]}"
    else
      log @collection, params[:results], params[:page], true
      @unique_category_id = @videos.first.category_id if @videos.map { |v| v.category_id }.uniq.count == 1
    end
  end
  
  def category
    collection, = figure_collection(params[:search])
    if params[:category].blank?
      category_id = nil
    else
      category_id = current_user.categories.find(params[:category]).id
    end
    collection.update_all category_id: category_id   
    redirect_to action: :index, search: params[:search]
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
