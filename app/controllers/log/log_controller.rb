class Log::LogController < ApplicationController

  def index
    @results_range = 50..200
    results = params[:results].nil? ? 50 : Integer(params[:results])
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
    if current_user.admin
      @video = current_user.videos.find params[:id]
      @video.destroy
      flash[:notice] = 'Log entry deleted.'
      redirect_to log_path
    else
      bad_request
    end
  end

end
