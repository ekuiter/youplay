class ChannelController < ApplicationController
  def info
    if params[:channels].is_a? Array
      channels = [params[:i]]
      YouplayChannel.prefetch_all
      params[:channels].each do |channel|
        parts = channel.split(':')
        provider = YouplayProvider.new provider: parts.first
        channel = YouplayChannel.new id: parts.last, provider: provider
        begin
          channels.push username: channel.name, url: channel.url
        rescue
          channels.push username: parts.last, url: "http://www.youtube.com/user/#{parts.last}"
        end
      end
      render json: channels
    else
      render nothing: true
    end
  end
end