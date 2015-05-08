class Providers::YoutubeProvider < Provider
  def name
    "YouTube"
  end

  def video_id(params)
    id = nil
    params.each do |key, value|
      if value.nil?
        id = key.gsub("youtube:", "") if key.starts_with?("youtube:")
      else
        id = value and break if value.include? 'youtube.com/watch?v='
      end
    end
    split = id.split('v=')
    id = split.length == 2 ? split[1].split('&')[0] : split[0].split('&')[0]
    raise 'no video id given' if id.blank?
    id
  end

  def fetch_video(id)
    video = client.execute(api_method: api.videos.list,
        parameters: { part: 'snippet,contentDetails,statistics,status', id: id }).data.items[0]
    require 'ostruct'
    YouplayVideo.new provider: YouplayProvider.new(instance: self),
                     id: id,
                     title: video.snippet.title,
                     url: "https://www.youtube.com/watch?v=#{id}",
                     duration: ISO8601::Duration.new(video.content_details.duration).to_i,
                     access_control: video.status.embeddable,
                     uploaded_at: video.snippet.publishedAt,
                     views: video.statistics.viewCount,
                     rating: OpenStruct.new({ likes: video.statistics.likeCount, dislikes: video.statistics.dislikeCount }),
                     description: video.snippet.description,
                     thumbnail: video.snippet.thumbnails.medium.url,
                     #comments: comments,
                     #comment_length: comment_length(comments),
                     channel: YouplayChannel.new(id: video.snippet.channelId[2..-1], name: video.snippet.channelTitle)
  end

  def player_partial(player_skin)
    player_skin == I18n.t('conf.youtube_player') ? "youtube_embed" : "youtube"
  end

  def channel(id)
    channel = client.profile(id) rescue raise("channel not found")
    { id: channel.user_id, name: channel.username_display }
  end

  def channel_url(id)
    "http://www.youtube.com/channel/UC#{id}"
  end

  def allowed?(video, method)
    return video.access_control if method == :embedding
    return true if method == :rating
    return false if method == :commenting
  end

  private

  def client
    return @client if @client

    require 'google/api_client'

    @client = Google::APIClient.new
    @client.authorization = nil
    @client.key = Settings.developer_key

    api_cache = 'lib/youtube-v3.cache'
    if File.exists? api_cache
      File.open(api_cache) do |file|
        @api = Marshal.load(file)
      end
    else
      @api = @client.discovered_api('youtube', 'v3')
      File.open(api_cache, 'w') do |file|
        Marshal.dump(@api, file)
      end
    end

    @client
  end

  def api
    return @api if @api
    client
    @api
  end

  def comment_length(comments)
    if comments.length < 5
      nil
    else
      comments.map {|comment| comment.content.length}.sum / comments.length
    end
  end
end