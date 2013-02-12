class Reader::SubscribeController < ApplicationController

  def index
    @subscribed_channels = current_user.subscribed_channels
    @subscribed_broadcasts = current_user.subscribed_broadcasts
  end

  def channel_add
    begin
      youtube_check = http_request(url: "http://gdata.youtube.com/feeds/api/users/#{params[:channel]}/uploads?v=2").body
      if youtube_check.include? '<error><domain>GData</domain><code>'
        flash[:alert] = t 'reader.subscribe.failure'
      else
        channel = youtube_check.split('<author><name>')[1].split('</name>')[0]
        sc = current_user.subscribed_channels.new
        sc.channel = channel
        if sc.save
          flash[:notice] = t 'reader.subscribe.channel_success', channel: channel
        else
          flash[:alert] = t 'reader.subscribe.failure'
        end
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

  def broadcast_delete
    if params[:broadcast].nil?
      current_user.subscribed_broadcasts.all.each { |broadcast| broadcast.destroy }
    else
      current_user.subscribed_broadcasts.find(params[:broadcast]).destroy
    end
    redirect_to reader_subscribe_path
  end

end
