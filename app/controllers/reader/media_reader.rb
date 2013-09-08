module Reader
  module MediaReader

    def hide_video(id)
      cached_video = CachedVideo.where(url: id).first
      current_user.hide_videos.create cached_video: cached_video, channel: cached_video.channel
    end

    def show_video(id)
      if id.nil?
        current_user.hide_videos.all.each { |sv| sv.destroy }
      else
        cached_video = CachedVideo.where(url: id).first
        current_user.hide_videos.where(cached_video_id: cached_video.id).each {|hv| hv.destroy}
      end
    end

  end
end