class Reader::ReaderController < ApplicationController

  include Reader::MediaReader
  
  skip_before_filter :authenticate_user!, only: :update
  
  def update
    unless params[:pass].nil? || params[:pass] != "VtfTNRv1Fv9mrTTa6E6KCFNs1VlPdCyTczZH247ZL9gQCThL69SOjDjJh89yVBfO"
      subscribed_channels = SubscribedChannel.all.map {|subscribed_channel| subscribed_channel.channel}.uniq
      subscribed_channels.each do |channel|
        User.first.update_videos_by_channel channel
      end
    end
    render nothing: true
  end
  
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
  
  def index
  end

  def hide
    hide_video params[:id]
    render nothing: true
  end

  def show
    show_video params[:id]
    redirect_to reader_hidden_path
  end
  
  def hide_channel
    channel = current_user.subscribed_channels.where(channel: params[:channel]).first
    current_user.new_videos_by_channel(channel).each do |video|
      hide_video video.url
    end
    redirect_to reader_path
  end

  def hidden
    @hidden_videos = current_user.hide_videos
  end

end
