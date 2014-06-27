class Api::ReaderController < Api::AuthenticatedController
  def index
    new_videos = current_user.new_videos
    mappings = {}
    YouplayChannel.prefetch_all
    new_videos.map do |channel, videos|
      mappings[channel] = YouplayChannel.new(id: channel, provider: YouplayProvider.youtube).name
    end
    new_videos = Hash[new_videos.map {|channel, videos| [mappings[channel], videos] }]
    new_videos.each do |channel, videos|
      videos.each do |video|
        video.channel = channel
      end
    end
    render json: new_videos
  end
  
  def subscribe
    channel = YouplayChannel.new(name: params[:channel], provider: YouplayProvider.youtube)
    raise unless current_user.subscribed_channels.create(channel: channel.id)
    render nothing: true
  end
  
  def add_hiding_rule  
    hiding_rule = current_user.hiding_rules.new
    hiding_rule.pattern = params[:pattern]
    unless params[:channel].blank?
      channel = YouplayChannel.new(name: params[:channel], provider: YouplayProvider.youtube)
      hiding_rule.channel = channel.id
    end
    raise unless hiding_rule.save
    render nothing: true
  end
end