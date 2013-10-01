module Reader
  module UserHelper    
    
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
      SubscribedChannel.all.map {|subscribed_channel| subscribed_channel.channel}.uniq.each do |channel|
        url = "http://gdata.youtube.com/feeds/api/users/UC#{channel}/uploads?v=2"
        raw_xml = http_request(url: url).body
        xml = YouTubeIt::Parser::VideosFeedParser.new(raw_xml).parse
        xml.videos.each do |video|
          CachedVideo.create channel: channel, title: video.title,
          url: video.unique_id, uploaded_at: video.uploaded_at unless videos.include? video.unique_id
        end
      end
    end
    
  end
end