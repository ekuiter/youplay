class Providers::NewgroundsProvider < Provider
  def initialize
    super
    raise "use subclass instead" if instance_of? Providers::NewgroundsProvider
  end
    
  def channel(id)
    response = HttpRequest.http_request(url: channel_url(id)).body
    xml = Nokogiri.HTML(response)
    raise "user not found" if xml.css("title").text == "Newgrounds - Error"
    { id: id, name: xml.css("#page_username").text }
  end
  
  def channel_url(id)
    "http://#{id}.newgrounds.com/"
  end
  
  def allowed?(video, method)
    return true if method == :embedding
    return false if method == :rating
    return false if method == :commenting
  end
  
  def player_partial(player_skin)
    "newgrounds"
  end
  
  def image
    "newgrounds"
  end
  
  protected
  
  def video_id_by_url(url_template, sub_provider, params)
    params.each do |key, value|  
      if value.nil?
        return key.gsub("#{sub_provider}:", "") if key.starts_with?("#{sub_provider}:")
      else
        return "#{value.split(url_template).last}" if value.include?(url_template)
      end
    end
    raise 'no video id given'
  end
  
  def attributes
    {
      provider: YouplayProvider.new(instance: self),
      title: xml.css("h2[itemprop=name]").first.text,
      url: url,
      topic: xml.css("dl.contentdata").first.css("dd")[3].text,
      views: xml.css("dl.contentdata").first.css("dd")[1].text.split(" ").first.gsub(",", "").to_i,
      channel: YouplayChannel.new(
        name: author_link.text,
        id:   author_link.attributes["href"].value.split("http://").last.split(".").first
      ),
      file: JSON.parse("{#{xml.to_s.split("embedController([{").last.split("}").first}}}")["url"]
    }
  end
  
  def xml
    @response ||= HttpRequest.http_request(url: url)
    @xml ||= Nokogiri.HTML(@response.body)
    raise "video not found" if @response.code == "404" or @xml.css("title").text == "Newgrounds - Error"
    @xml
  end
  
  def uploaded_at(format)
    date_string = xml.css("dl.sidestats").first.css("dd").first.text
    DateTime.strptime(date_string, format)
  end
  
  def author_link
    xml.css(".authorlinks").first.css("a").last
  end
end