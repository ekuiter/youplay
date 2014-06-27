class ChannelController < ApplicationController
  def info
    if params[:channels].is_a? Array
      channels = [params[:i]]
      YouplayChannel.prefetch_all
      params[:channels].each do |channel|
        parts = channel.split(':')
        provider = YouplayProvider.new provider: parts.first
        channel = YouplayChannel.new id: parts.last, provider: provider
        channels.push username: channel.name, url: channel.url
      end
      render json: channels
    else
      render nothing: true
    end
  end
end