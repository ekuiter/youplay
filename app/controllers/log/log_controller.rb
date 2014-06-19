class Log::LogController < ApplicationController
  
  skip_before_filter :authenticate_user!, only: [:log_json, :favorites_json]

  def index
    @search = params[:search] ? params[:search] : ""
    @collection = if @search == "favorites"
                    current_user.videos.joins(:favorite)
                  elsif not params[:search].blank?
                    current_user.videos.where "title like ?", "%#{params[:search]}%"
                  else
                    current_user.videos
                  end
    if @collection.count == 1
      redirect_to @collection.first.play_url
    elsif @collection.count == 0
      redirect_to "#{play_url}?#{params[:search]}"
    else
      log @collection
    end
  end

  def destroy
    @video = current_user.videos.find params[:id]
    @video.destroy
    flash[:notice] = 'Log entry deleted.'
    redirect_to request.referer
  end
  
  def set_favorite
    video = current_user.videos.find params[:id]
    current_user.favorites.new(video: video).save unless video.nil?
    render nothing: true
  end
  
  def unset_favorite
    video = current_user.videos.find params[:id]
    unless video.nil?
      video.favorite = nil
      video.save
    end
    render nothing: true
  end
  
  private
  
  def log(collection)
    default_number = 50
    @results_range = default_number..400
    @results = params[:results].nil? ? default_number : Integer(params[:results])
    @results = @results_range.min unless @results_range.include? @results
    page = params[:page].nil? ? 0 : Integer(params[:page]) - 1
    page = 0 if page < 0
    @videos = current_user.pagination collection, @results, page
    @video_count = collection.count
    @page_count = if @video_count % @results == 0
                    @video_count / @results
                  else
                    @video_count / @results + 1
                  end
    @current_page = page + 1
    @title_length = current_user.max_title_length
    @favorited_video_ids = current_user.favorites.map {|f| f.video_id}
  end

end
