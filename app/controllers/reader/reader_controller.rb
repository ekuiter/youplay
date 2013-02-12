class Reader::ReaderController < ApplicationController

  include Reader::MediaReader
  include Reader::VideoReader
  include Reader::BroadcastReader

  def index
    @new_videos = current_user.new_videos
    @broadcast_number = CachedBroadcastsInfo.find_by_key('broadcast_number')
    @database_datetime = CachedBroadcastsInfo.find_by_key('database_datetime')
    @broadcast_number = @broadcast_number.value if @broadcast_number
    @database_datetime = @database_datetime.value.to_datetime if @database_datetime
  end

  def hide
    hide_video_or_broadcast params[:id]
    redirect_to reader_path
  end

  def show
    show_video_or_broadcast params[:id]
    redirect_to reader_hidden_path
  end

  def update
    logger.debug 'updating videos now'
    update_videos
    logger.debug 'updating broadcasts now'
    update_broadcasts
    redirect_to reader_path
  end

  def hidden

  end

end
