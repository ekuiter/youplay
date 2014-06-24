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
end