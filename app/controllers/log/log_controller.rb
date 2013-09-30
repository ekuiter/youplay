class Log::LogController < ApplicationController

  def index
    log
  end
  
  def favorites
    log favorited: true
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
  
  def log hash={}
    @client = youtube_client
    default_number = 50
    @results_range = default_number..400
    results = params[:results].nil? ? default_number : Integer(params[:results])
    results = @results_range.min unless @results_range.include? results
    page = params[:page].nil? ? 0 : Integer(params[:page]) - 1
    page = 0 if page < 0
    if hash[:favorited]
      @videos = current_user.favorited_videos results, page
      video_count = current_user.favorites.count
    else
      @videos = current_user.watched_videos results, page
      video_count = current_user.videos.count
    end
    @page_count = if video_count % results == 0
                    video_count / results
                  else
                    video_count / results + 1
                  end
    @current_page = page + 1
    @results = results
    @video_count = video_count
    @is_admin = current_user.admin
    @title_length = current_user.max_title_length
    @favorited_video_ids = current_user.favorites.map {|f| f.video_id}
  end

end
