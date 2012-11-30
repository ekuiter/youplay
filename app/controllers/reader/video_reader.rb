module Reader
  module VideoReader

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

  end
end