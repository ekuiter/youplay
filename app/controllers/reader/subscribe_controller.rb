class Reader::SubscribeController < ApplicationController

  def index
    @subscribed_channels = current_user.subscribed_channels
  end

  def channel_add
    begin
      @client = youtube_client
      profile = @client.profile params[:channel]
      flash[:alert] = t 'reader.subscribe.failure' unless profile
      sc = current_user.subscribed_channels.new
      sc.channel = profile.user_id
      if sc.save
        flash[:notice] = t 'reader.subscribe.channel_success', channel: profile.username_display
      else
        flash[:alert] = t 'reader.subscribe.failure'
      end
    rescue
      flash[:alert] = t 'reader.subscribe.failure'
    end
    redirect_to reader_subscribe_path
  end

  def channel_delete
    if params[:channel].nil?
      current_user.subscribed_channels.all.each { |channel| channel.destroy }
    else
      current_user.subscribed_channels.find(params[:channel]).destroy
    end
    redirect_to reader_subscribe_path
  end

end
