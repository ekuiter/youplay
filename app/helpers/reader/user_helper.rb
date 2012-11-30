module Reader
  module UserHelper

    include Reader::BroadcastReader

    def cached_videos # get all videos from subscribed channels as a plain array
      cached_videos = []
      subscribed_channels.all.each do |sc|
        CachedVideo.where(channel: sc.channel).all.each do |cached_video|
          cached_videos << cached_video
        end
      end
      return cached_videos
    end

    def latest_videos # get all videos from subscribed channels
      latest_videos = {}
      subscribed_channels.all.each do |sc|
        channel_videos = CachedVideo.where(channel: sc.channel).all
        latest_videos[sc.channel] = channel_videos unless channel_videos.empty?
      end
      return latest_videos
    end

    def hidden_videos # get user hidden videos
      hidden_videos = []
      hide_videos.all.each do |sv|
        hidden_videos << sv.cached_video
      end
      return hidden_videos
    end

    def new_videos # get latest videos and keep out hidden and watched videos
      new_videos = {}
      latest_videos.each do |channel_index, channel|
        new_videos[channel_index] = []
        channel.each do |lv|
          if hidden_videos.include? lv then
            next
          end
          if videos.where(url: lv.url).all.count > 0 then
            next
          end
          if videos.where(gronkh_url: lv.url).all.count > 0 then
            next
          end
          new_videos[channel_index] << lv
        end
        new_videos[channel_index] = new_videos[channel_index].sort_by { |video| video.uploaded_at }.reverse
      end
      return new_videos
    end

    def latest_broadcasts # get all broadcasts from subscribed broadcasts (array of next_broadcast's)
      latest_broadcasts = {}
      subscribed_broadcasts.all.each do |sb|
        latest_broadcasts[sb.broadcast] = []
        if !sb.broadcast[:all].is_a?(NilClass) && !sb.broadcast[:all].empty? then
          reset_broadcast
          while cb = next_broadcast do
            if cb[:published_at].to_s.include?(sb.broadcast[:all]) ||
                cb[:station].include?(sb.broadcast[:all])||
                cb[:topic].include?(sb.broadcast[:all]) ||
                cb[:title].include?(sb.broadcast[:all])
              latest_broadcasts[sb.broadcast] << cb
            end
          end
        else
          reset_broadcast
          while cb = next_broadcast do
            if  cb.station.include?(sb.broadcast[:station])||
                cb.topic.include?(sb.broadcast[:topic]) ||
                cb.title.include?(sb.broadcast[:title])
              latest_broadcasts[sb.broadcast] << cb
            end
          end
        end
      end
      return latest_broadcasts
    end

    def hidden_broadcasts # get user hidden broadcasts (array of md5s)
      hidden_broadcasts = []
      show_broadcasts.where(show: false).all.each do |sb|
        hidden_broadcasts << sb.md5
      end
      return hidden_broadcasts
    end

    def new_broadcasts # get latest broadcasts and keep out hidden and watched broadcasts (hash of arrays of next_bc's)
      new_broadcasts = {}
      latest_broadcasts.each do |broadcast_index, broadcasts|
        new_broadcasts[broadcast_index] = []
        broadcasts.each do |bc|
          if hidden_broadcasts.include? bc[:md5] then
            next
          end
          if videos.where(url: bc[:url]).all.count > 0 then
            next
          end
          new_broadcasts[broadcast_index] << bc
        end
      end
      return new_broadcasts
    end

  end
end