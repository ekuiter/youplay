module Reader
  module UserHelper
    
    def videos_per_channel
      10
    end
    
    def new_videos
      cached_videos = CachedVideo.all - 
        CachedVideo.joins(:hide_videos).where("hide_videos.user_id" => id).all -
        CachedVideo.find_by_sql("SELECT `cached_videos`.* FROM `cached_videos` 
                                 INNER JOIN `videos` ON `videos`.`url` = `cached_videos`.`url` 
                                 WHERE `videos`.`user_id` = #{id}")                                         
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
      videos = CachedVideo.all.map {|v| v.url}
      hiding_rules = HidingRule.all
      SubscribedChannel.all.map {|subscribed_channel| subscribed_channel.channel}.uniq.each do |channel|
        url = "http://gdata.youtube.com/feeds/api/users/UC#{channel}/uploads?v=2"
        raw_xml = http_request(url: url).body
        xml = YouTubeIt::Parser::VideosFeedParser.new(raw_xml).parse
        xml.videos[0..videos_per_channel - 1].each do |video|
          unless videos.include? video.unique_id
            cached_video = CachedVideo.create channel: channel, title: video.title,
                                              url: video.unique_id, uploaded_at: video.uploaded_at
            hiding_rules.each do |hiding_rule|
              if (hiding_rule.channel.blank? and video.title.downcase.include?(hiding_rule.pattern.downcase)) or
                 (channel == hiding_rule.channel and video.title.include?(hiding_rule.pattern))
                HideVideo.create cached_video: cached_video, channel: channel, user_id: hiding_rule.user_id
              end
            end
          end
        end
      end
    end
    
    def tidy_videos
      users = User.all
      videos = Video.all
      hide_videos = HideVideo.all
      cached_videos = CachedVideo.all
      cached_videos.each do |cached_video|
        keep = false
        users.each do |user|
          watched = videos.select {|v| v.user_id == user.id}.map {|v| v.url}
          hidden = hide_videos.select {|v| v.user_id == user.id}.map {|v| v.cached_video_id}
          channel_videos = cached_videos.select {|v| v.channel == cached_video.channel}
          keep = true if channel_videos.count <= videos_per_channel or
                         (not watched.include? cached_video.url and
                          not hidden.include? cached_video.id)
        end
        cached_video.destroy if not keep
      end
    end
  end
end