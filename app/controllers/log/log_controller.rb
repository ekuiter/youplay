class Log::LogController < ApplicationController

  def index
    default_number = 15 #50
    @results_range = default_number..200
    results = params[:results].nil? ? default_number : Integer(params[:results])
    results = @results_range.min unless @results_range.include? results
    page = params[:page].nil? ? 0 : Integer(params[:page]) - 1
    page = 0 if page < 0
    @videos = current_user.watched_videos results, page
    video_count = current_user.videos.count
    @page_count = if video_count % results == 0
                    video_count / results
                  else
                    video_count / results + 1
                  end
    @current_page = page + 1
    @results = results
    @video_count = video_count
    @is_admin = current_user.admin
  end

  def destroy
    @video = current_user.videos.find params[:id]
    @video.destroy
    flash[:notice] = 'Log entry deleted.'
    redirect_to log_path
  end
  
  def favorites
    default_number = 15 #50
    @results_range = default_number..200
    results = params[:results].nil? ? default_number : Integer(params[:results])
    results = @results_range.min unless @results_range.include? results
    page = params[:page].nil? ? 0 : Integer(params[:page]) - 1
    page = 0 if page < 0
    @videos = current_user.favorited_videos results, page
    video_count = current_user.videos.count
    @page_count = if video_count % results == 0
                    video_count / results
                  else
                    video_count / results + 1
                  end
    @current_page = page + 1
    @results = results
    @video_count = video_count
    @is_admin = current_user.admin
  end
  
  def set_favorite
    video = current_user.videos.where(url: params[:video]).first
    current_user.favorites.new(video: video).save unless video.nil?
    redirect_to request.referer
  end
  
  def unset_favorite
    video = current_user.videos.where(url: params[:video]).first
    unless video.nil?
      video.favorite = nil
      video.save
    end
    redirect_to request.referer
  end

end
