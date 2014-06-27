class Api::ReaderController < Api::AuthenticatedController
  def index
    new_videos = current_user.new_videos
    mappings = {}
    new_videos.map do |channel, videos|
      mappings[channel] = YouplayChannel.new(id: channel, provider: :youtube).fetch.name
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
    profile = Providers::youtube_client.profile params[:channel]
    raise unless current_user.subscribed_channels.create(channel: profile.user_id)
    render nothing: true
  end
  
  def add_hiding_rule  
    hiding_rule = current_user.hiding_rules.new
    hiding_rule.pattern = params[:pattern]
    unless params[:channel].blank?
      profile = Providers::youtube_client.profile params[:channel]
      hiding_rule.channel = profile.user_id
    end
    raise unless hiding_rule.save
    render nothing: true
  end
end