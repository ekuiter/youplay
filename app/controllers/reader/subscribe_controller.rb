class Reader::SubscribeController < ApplicationController
  def index
    @subscribed_channels = current_user.subscribed_channels
  end

  def create
    begin
      profile = Providers::youtube_client.profile params[:channel]
      channel = current_user.subscribed_channels.new channel: profile.user_id
      if channel.save
        flash[:notice] = t 'reader.subscribe.channel_success', channel: profile.username_display
      else
        flash[:alert] = t 'reader.subscribe.failure'
      end
    rescue
      flash[:alert] = t 'reader.subscribe.failure'
    end
    redirect_to reader_subscribe_path
  end

  def destroy
    if params[:channel].nil?
      current_user.subscribed_channels.destroy_all
    else
      current_user.subscribed_channels.find(params[:channel]).destroy
    end
    redirect_to reader_subscribe_path
  end
end
