class ChannelController < ApplicationController
  
  def info
    if params[:channels].is_a? Array
      channels = [params[:i]]
      params[:channels].each do |data|
        split = data.split(':')
        channel = YouplayChannel.new(id: split[1], provider: split[0].to_sym).fetch
        channels.push username: channel.name, url: channel.url
      end
      render json: channels
    else
      render nothing: true
    end
  end

end
