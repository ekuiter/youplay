module Reader
  module UserHelper

=begin
    def cached_videos # get all videos from subscribed channels as a plain array
      cached_videos = []
      subscribed_channels.all.each do |sc|
        CachedVideo.where(channel: sc.channel).all.each do |cached_video|
          cached_videos << cached_video
        end
      end
      cached_videos
    end

    def latest_videos # get all videos from subscribed channels
      latest_videos = {}
      subscribed_channels.all.each do |sc|
        channel_videos = CachedVideo.where(channel: sc.channel).all
        latest_videos[sc.channel] = channel_videos unless channel_videos.empty?
      end
      latest_videos
    end

    def hidden_videos # get user hidden videos
      hidden_videos = []
      hide_videos.all.each do |sv|
        hidden_videos << sv.cached_video
      end
      hidden_videos
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
          new_videos[channel_index] << lv
        end
        new_videos[channel_index] = new_videos[channel_index].sort_by { |video| video.uploaded_at }.reverse
      end
      new_videos
    end
    
    def update_videos # fetch latest videos from youtube
      subscribed_channels = SubscribedChannel.all.map {|subscribed_channel| subscribed_channel.channel}.uniq # read all subscribed channels
      subscribed_channels.each do |subscribed_channel| # for each channel ...
        url = "http://gdata.youtube.com/feeds/api/users/#{subscribed_channel}/uploads?v=2"
        raw_xml = http_request(url: url).body # ... go to youtube and fetch channel's latest videos
        xml = YouTubeIt::Parser::VideosFeedParser.new(raw_xml).parse # parse youtube's response
        xml.videos.each do |video|
          CachedVideo.create channel: video.author.name, description: video.description, # and create new database entry for each video
                             title: video.title, url: video.unique_id, uploaded_at: video.uploaded_at
        end
      end
    end
=end
    
    
    def new_videos_by_channel(channel)
      channel_videos = CachedVideo.where(channel: channel.channel).all   
      hidden_videos = HideVideo.where(channel: channel.channel).all.map {|v|v.cached_video }
      watched_videos = videos.all
      new_videos = []
      channel_videos.each do |video|
        next if hidden_videos.include? video
        next if watched_videos.map {|v|v.url}.include? video.url
        new_videos << video
      end
      new_videos.sort_by { |video| video.uploaded_at }.reverse
    end
    
    def update_videos_by_channel(channel)
      videos = CachedVideo.all.map {|v| v.url}
      url = "http://gdata.youtube.com/feeds/api/users/#{channel.is_a?(SubscribedChannel) ? channel.channel : channel}/uploads?v=2"
      raw_xml = http_request(url: url).body # ... go to youtube and fetch channel's latest videos
      xml = YouTubeIt::Parser::VideosFeedParser.new(raw_xml).parse # parse youtube's response
      xml.videos.each do |video|
        CachedVideo.create channel: video.author.name, description: video.description, # and create new database entry for each video
                           title: video.title, url: video.unique_id, uploaded_at: video.uploaded_at unless videos.include? video.unique_id
      end
    end
    
  end
end