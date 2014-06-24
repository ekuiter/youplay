module ControllerMixins
  module PlayerController
    private
    
    def play_video(params)
      begin
        video = Providers::fetch_youtube_video params
      rescue
        video = Providers::fetch_twitch_video params
      end
      video.saved_video = current_user.videos.where(url: video.id).first
      if video.saved_video.nil?
        video.saved_video = current_user.videos.create browser: view_context.user_browser, channel_topic: video.channel.fetch.id,
                             title: video.title, url: video.id, duration: video.duration, provider: video.provider
      end
      video
    end
  end
end