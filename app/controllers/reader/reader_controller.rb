class Reader::ReaderController < ApplicationController  
  def index
    @videos = current_user.new_videos
  end
  
  def hide
    params[:videos].each {|v| hide_video v}
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

  def hide_video(id)
    set_cached_video(id)
    current_user.hide_videos.create cached_video: @cached_video, channel: @cached_video.channel
  end

  def show_video(id)
    set_cached_video(id)
    if @cached_video
      current_user.hide_videos.where(cached_video_id: @cached_video.id)
    else
      current_user.hide_videos
    end.destroy_all
  end
  
  def set_cached_video(id)
    @cached_video = CachedVideo.where(url: id).first
  end
end
