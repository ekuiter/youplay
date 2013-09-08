class Reader::ReaderController < ApplicationController

  include Reader::MediaReader
  
  def channels
    render json: current_user.subscribed_channels.map {|c|c.channel}
  end
  
  def read_channel
    begin
      @channel = current_user.subscribed_channels.where(channel: params[:channel]).first
      @videos = current_user.new_videos_by_channel(@channel)
      render "read", layout: false
    rescue
      render nothing: true
    end
  end
  
  def update_channel
    begin
      @channel = current_user.subscribed_channels.where(channel: params[:channel]).first
      @videos = current_user.update_videos_by_channel(@channel)
    rescue
    end
    render nothing: true
  end
  
  def index
  end
  
  def update
  end

  def hide
    hide_video params[:id]
    redirect_to reader_path
  end

  def show
    show_video params[:id]
    redirect_to reader_hidden_path
  end

  def hidden
  end

end
