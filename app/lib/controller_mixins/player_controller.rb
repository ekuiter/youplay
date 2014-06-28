module ControllerMixins
  module PlayerController
    private
    
    def play_video(params)
      id = id_from_params
      video = YouplayProvider.new(provider: id[:provider]).fetch_video(id[:id])
      video.saved_video = current_user.videos.where(url: video.id).first
      if video.saved_video.nil?
        video.saved_video = current_user.videos.create browser: view_context.user_browser, channel_topic: video.channel.id,
                             title: video.title, url: video.id, duration: video.duration, provider: video.provider.to_s
      end
      video
    end
    
    private
    
    def id_from_params
      ids = []
      YouplayProvider.providers.each do |provider|
        begin
          ids << {provider: provider, id: YouplayProvider.new(provider: provider).video_id(params) }
        rescue
        end
      end
      ids.first
    end
  end
end