module Player::VideoPlayer

  def fetch_video(params)
    id = extract_id params
    client = youtube_connect current_user: current_user, state: "player_video_#{id}", access_token: current_user.access_token,
                             refresh_token: current_user.refresh_token, expires_in: current_user.expires_in
    video = client.video_by id
    sourcecode = http_request(url: video.player_url).body.encode
    downloads = extract_downloads id, sourcecode
    {video: video, sourcecode: sourcecode, downloads: downloads}
  end

  def extract_id(params)
    id = nil
    params.each do |key, value|
      if key.include? 'youtube.com/watch?v'
        id = value
        break
      elsif key == 'v'
        id = value
        break
      elsif key == 'url'
        id = value
        break
      elsif value.nil?
        id = key
        break
      end
    end
    split = id.split('v=')
    id = split.length == 2 ? split[1].split('&')[0] : split[0].split('&')[0]
    raise 'no video id given' if id.blank?
    id
  end

  def extract_downloads(id, sourcecode)
    require 'cgi'
    url_map = sourcecode.split 'url_encoded_fmt_stream_map='
    url_map = url_map[1].split '='
    url_map = url_map[0].strip
    url_map = CGI.unescape(url_map).split(',')
    downloads = []
    url_map.each do |url|
      download = {}
      params = url.split('&')
      params.each do |param|
        split = param.split '='
        if split[0] == 'url'
          download[:url] = CGI.unescape(CGI.unescape(split[1]))
        elsif split[0] == 'itag'
          itag = split[1].to_i
          download[:itag] = itag
          download[:quality] = itag2quality itag
        end
      end
      download[:link] = player_video_download_path id, download[:itag]
      downloads << download
    end
    downloads
  end

  def itag2quality(itag)
    itags = {
        38 => {format: formats[:mp4], resolution: resolutions[:highres]},
        85 => {format: formats[:mp4], resolution: resolutions[:p1080], s3d: true},
        37 => {format: formats[:mp4], resolution: resolutions[:p1080]},
        84 => {format: formats[:mp4], resolution: resolutions[:p720], s3d: true},
        22 => {format: formats[:mp4], resolution: resolutions[:p720]},
        83 => {format: formats[:mp4], resolution: resolutions[:p480], s3d: true},
        82 => {format: formats[:mp4], resolution: resolutions[:p360], s3d: true},
        18 => {format: formats[:mp4], resolution: resolutions[:p360]},
        102 => {format: formats[:webm], resolution: resolutions[:p720], s3d: true},
        45 => {format: formats[:webm], resolution: resolutions[:p720]},
        101 => {format: formats[:webm], resolution: resolutions[:p480], s3d: true},
        44 => {format: formats[:webm], resolution: resolutions[:p480]},
        100 => {format: formats[:webm], resolution: resolutions[:p360], s3d: true},
        43 => {format: formats[:webm], resolution: resolutions[:p360]},
        35 => {format: formats[:flv], resolution: resolutions[:p480]},
        34 => {format: formats[:flv], resolution: resolutions[:p360]},
        5 => {format: formats[:flv], resolution: resolutions[:p240]},
        36 => {format: formats[:gpp], resolution: resolutions[:p240]}
    }
    itags[itag]
  end

  def formats
    {
        mp4: t('player.download.formats.mp4'),
        webm: t('player.download.formats.webm'),
        flv: t('player.download.formats.flv'),
        gpp: t('player.download.formats.3gp')
    }
  end

  def resolutions
    {
        highres: t('player.download.resolutions.highres'),
        p1080: t('player.download.resolutions.1080p'),
        p720: t('player.download.resolutions.720p'),
        p480: t('player.download.resolutions.480p'),
        p360: t('player.download.resolutions.360p'),
        p240: t('player.download.resolutions.240p')
    }
  end

end