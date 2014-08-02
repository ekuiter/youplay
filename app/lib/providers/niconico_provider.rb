class Providers::NiconicoProvider < Provider
  def video_id(params)
    params.each do |key, value|     
      if value.nil?
        return key.gsub("niconico:", "") if key.starts_with?("niconico:")
      else
        return value.split('nicovideo.jp/watch/').last if value.include?('nicovideo.jp/watch/')
      end
    end
    raise 'no video id given'
  end
  
  def fetch_video(id)
    url = "http://www.nicovideo.jp/watch/#{id}"
    response = HttpRequest.http_request(
      url: url, 
      headers: { "Accept-Language" => "en-US,en" }
    )
    xml = Nokogiri.HTML(response.body)
    raise "video not found" if response.code == "404" or xml.css("title").blank?
    YouplayVideo.new provider: YouplayProvider.new(instance: self),
                     id: id,
                     title: xml.css("h1[itemprop=name]").text,
                     url: url,
                     duration: calculate_duration(xml.css(".vinfo_length").first.text),
                     uploaded_at: xml.css(".font12").first.text.strip.to_datetime,
                     views: xml.css(".font12")[1].children[1].text.strip.split(" ").last.gsub(",", "").to_i,
                     description: xml.css("p[itemprop=description]").children.to_s,
                     thumbnail: xml.css(".img_std128").attr("src").text,
                     channel: YouplayChannel.new(
                       name: xml.css("strong[itemprop=name]").text,
                       id: xml.css("strong[itemprop=name]").text
                     )
  end
  
  def channel(id)
    { id: id, name: id }
  end
  
  def channel_url(id)
    "https://www.google.de/search?q=#{id}%20site:nicovideo.jp"
  end
  
  def allowed?(video, method)
    return true if method == :embedding
    return false if method == :rating
    return false if method == :commenting
  end
  
  private
  
  def calculate_duration(duration)
    duration.split(":").reverse.each_with_index.map do |value, key| 
      value.to_i * (60 ** key)
    end.sum
  end
end