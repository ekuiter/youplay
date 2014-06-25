module UserMixins
  module Reader            
    def new_videos
      cached_videos = CachedVideo.all - hidden_cached_videos - watched_cached_videos                         
      videos = {}
      subscribed_channels.each do |channel|
        new_videos = cached_videos.select  { |video| video.channel == channel.channel }
                                  .sort_by { |video| video.uploaded_at }
                                  .reverse
        videos[channel.channel] = new_videos unless new_videos.blank?
      end
      videos
    end
    
    def update_videos
      videos, hiding_rules = CachedVideo.all.map {|v| v.url}, HidingRule.all
      subscribed_channels = SubscribedChannel.all.map {|subscribed_channel| subscribed_channel.channel}.uniq
      subscribed_channels.each do |channel|
        fetch_videos(channel).each do |video|
          unless videos.include? video.unique_id
            cached_video = CachedVideo.create channel: channel, title: video.title,
                                              url: video.unique_id, uploaded_at: video.uploaded_at
            hide_video_if_rule_applies(video, channel, cached_video)
          end
        end
      end
    end
    
    def tidy_videos
      users, videos, hide_videos, cached_videos = User.all, Video.all, HideVideo.all, CachedVideo.all
      cached_videos.each do |cached_video|
        keep = false
        users.each do |user|
          watched, hidden, channel_videos = select_watched_hidden_channel_videos(user, cached_video)
          keep = true if channel_videos.count <= Settings::videos_per_channel or
                         (not watched.include? cached_video.url and
                          not hidden.include? cached_video.id)
        end
        cached_video.destroy unless keep
      end
    end
    
    private
    
    def hidden_cached_videos
      CachedVideo.joins(:hide_videos).where("hide_videos.user_id" => id).all
    end

    def watched_cached_videos
      CachedVideo.joins("INNER JOIN videos ON videos.url = cached_videos.url").where(["videos.user_id = ?", id])
    end
  
    def fetch_videos(channel)
      url = "http://gdata.youtube.com/feeds/api/users/UC#{channel}/uploads?v=2"
      raw_xml = HttpRequest::http_request(url: url).body
      xml = YouTubeIt::Parser::VideosFeedParser.new(raw_xml).parse
      xml.videos[0..Settings::videos_per_channel - 1]
    end
  
    def hide_video_if_rule_applies(video, channel, cached_video)
      hiding_rules.each do |hiding_rule|
        if (hiding_rule.channel.blank? and video.title.downcase.include?(hiding_rule.pattern.downcase)) or
           (channel == hiding_rule.channel and video.title.downcase.include?(hiding_rule.pattern.downcase))
          HideVideo.create cached_video: cached_video, channel: channel, user_id: hiding_rule.user_id
        end
      end
    end
  
    def select_watched_hidden_channel_videos(user, cached_video)
      watched = videos.select {|v| v.user_id == user.id}.map {|v| v.url}
      hidden = hide_videos.select {|v| v.user_id == user.id}.map {|v| v.cached_video_id}
      channel_videos = cached_videos.select {|v| v.channel == cached_video.channel}
      [watched, hidden, channel_videos]
    end
  end
end