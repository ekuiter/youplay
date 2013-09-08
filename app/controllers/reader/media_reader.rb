module Reader
  module MediaReader

    def hide_video(id)
      cached_video = current_user.cached_videos.select { |cv| cv.url == id }[0]
      current_user.hide_videos.create cached_video: cached_video, channel: cached_video.channel
    end

    def show_video(id)
      if id.nil?
        current_user.hide_videos.all.each { |sv| sv.destroy }
      else
        cached_video = current_user.cached_videos.select { |cv| cv.url == id }[0]
        current_user.hide_videos.find_by_cached_video_id(cached_video.id).destroy
      end
    end

  end
end