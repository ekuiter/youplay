module Reader
  module MediaReader

    def hide_video_or_broadcast(id)
      cached_video = current_user.cached_videos.select { |cv| cv.url == id }[0]
      if cached_video.nil?
        cached_broadcast = current_user.cached_broadcasts.select { |cb| cb.md5 == id }[0]
        if cached_broadcast.nil?
          raise 'neither a video nor a broadcast'
        else
          current_user.hide_broadcasts.create cached_broadcast: cached_broadcast
        end
      else
        current_user.hide_videos.create cached_video: cached_video
      end
    end

    def show_video_or_broadcast(id)
      if id.nil?
        current_user.hide_videos.all.each { |sv| sv.destroy }
        current_user.hide_broadcasts.all.each { |sb| sb.destroy }
      else
        cached_video = current_user.cached_videos.select { |cv| cv.url == id }[0]
        if cached_video.nil?
          cached_broadcast = current_user.cached_broadcasts.select { |cb| cb.md5 == id }[0]
          if cached_broadcast.nil?
            raise 'neither a video nor a broadcast'
          else
            current_user.hide_broadcasts.find_by_cached_broadcast_id(cached_broadcast.id).destroy
          end
        else
          current_user.hide_videos.find_by_cached_video_id(cached_video.id).destroy
        end
      end
    end

  end
end