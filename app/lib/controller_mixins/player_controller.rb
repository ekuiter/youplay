module ControllerMixins
  module PlayerController
    private
    
    def play_video(params)
      video = nil
      YouplayProvider.providers.each do |provider|
        begin
          video = YouplayProvider.new(provider: provider).play_video(params)
          break
        rescue
        end
      end
      video.saved_video = current_user.videos.where(url: video.id).first
      if video.saved_video.nil?
        video.saved_video = current_user.videos.create browser: view_context.user_browser, channel_topic: video.channel.id,
                             title: video.title, url: video.id, duration: video.duration, provider: video.provider.to_s
      end
      video
    end
  end
end