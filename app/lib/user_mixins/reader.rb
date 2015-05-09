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
      subscribed_channels = SubscribedChannel.pluck(:channel).uniq
      playlists = fetch_playlists(subscribed_channels)
      playlists.each do |channel, playlist|
        Rails.logger.info "[youplay/update] Updating channel #{channel} with playlist #{playlist}"
        fetch_videos(playlist).each do |video|
          videoId = video.snippet.resourceId.videoId
          unless videos.include? videoId
            Rails.logger.info "[youplay/update]   [#{videoId}] #{video.snippet.title}"
            cached_video = CachedVideo.create channel: channel[2..-1], title: video.snippet.title,
                url: videoId, uploaded_at: video.snippet.publishedAt
            hide_video_if_rule_applies(video, channel, cached_video)
          end
        end
      end
    end
    
    def tidy_videos
      users, videos, hide_videos, cached_videos = User.all, Video.all, HideVideo.all, CachedVideo.all
      cached_videos_to_destroy, hide_videos_to_destroy = [], []
      cached_videos.each do |cached_video|
        keep = false
        users.each do |user|
          watched, hidden, channel_videos = select_watched_hidden_channel_videos(
              videos, hide_videos, cached_videos, user, cached_video
          )
          keep = true if channel_videos.count <= Settings.videos_per_channel or
                         (not watched.include? cached_video.url and
                          not hidden.include? cached_video.id)
        end
        unless keep
          Rails.logger.info "[youplay/tidy] Remove cached        video [#{cached_video.url}] #{cached_video.title}"
          cached_videos_to_destroy << cached_video.id
          hide_videos.select {|v| v.cached_video_id == cached_video.id}.each do |hidden_video|
            Rails.logger.info "[youplay/tidy] Remove        hidden video [#{cached_video.url}]"
            hide_videos_to_destroy << hidden_video.id
          end
        end
      end
      count = HideVideo.delete hide_videos_to_destroy
      Rails.logger.debug "[youplay/tidy] Removed #{count} hidden videos"
      count = CachedVideo.delete cached_videos_to_destroy
      Rails.logger.debug "[youplay/tidy] Removed #{count} cached videos"
    end

    private

    def fetch_playlists(channels)
      set_client_and_api
      max_results = 50
      playlists = {}

      channels.each_slice(max_results).each do |channels|
        channel_items = @client.execute(api_method: @api.channels.list,
            parameters: { part: 'contentDetails', id: "UC#{channels.join(",UC")}", maxResults: max_results }
        ).data.items
        channel_items.each { |channel| playlists[channel.id] = channel.content_details.related_playlists.uploads }
      end

      playlists
    end

    def fetch_videos(playlist)
      set_client_and_api

      @client.execute(api_method: @api.playlist_items.list,
          parameters: { part: 'snippet', playlistId: playlist, maxResults: Settings.videos_per_channel }
      ).data.items
    end

    def set_client_and_api
      @client ||= YouplayProvider.youtube.instance.client
      @api ||= YouplayProvider.youtube.instance.api
    end
    
    def hidden_cached_videos
      CachedVideo.joins(:hide_videos).where("hide_videos.user_id" => id).all
    end

    def watched_cached_videos
      CachedVideo.joins("INNER JOIN videos ON videos.url = cached_videos.url").where(["videos.user_id = ?", id])
    end
  
    def hide_video_if_rule_applies(video, channel, cached_video)
      hiding_rules.each do |hiding_rule|
        if (hiding_rule.channel.blank? and video.snippet.title.downcase.include?(hiding_rule.pattern.downcase)) or
           (channel == hiding_rule.channel and video.snippet.title.downcase.include?(hiding_rule.pattern.downcase))
          HideVideo.create cached_video: cached_video, channel: channel, user_id: hiding_rule.user_id
        end
      end
    end
  
    def select_watched_hidden_channel_videos(videos, hide_videos, cached_videos, user, cached_video)
      watched = videos.select {|v| v.user_id == user.id}.map {|v| v.url}
      hidden = hide_videos.select {|v| v.user_id == user.id}.map {|v| v.cached_video_id}
      channel_videos = cached_videos.select {|v| v.channel == cached_video.channel}
      [watched, hidden, channel_videos]
    end
  end
end