class Providers::NewgroundsAudioProvider < Providers::NewgroundsProvider  
  def name
    "Newgrounds Audio"
  end

  def video_id(params)
    video_id_by_url("newgrounds.com/audio/listen/", :newgrounds_audio, params)
  end
  
  def fetch_video(id)
    @sourcecode, @xml, @id = nil, nil, id
    attributes = self.attributes.merge id: id,
                                       duration: duration,
                                       uploaded_at: uploaded_at("%m/%d/%Y"),
                                       description: xml.css(".fatcol .podcontent")[2].text
    YouplayVideo.new attributes
  end
  
  private
  
  def url
    "http://www.newgrounds.com/audio/listen/#{@id}"
  end
 
  def duration
    duration_string = xml.css("dl.sidestats").first.css("dd")[3].text
    duration_string.split(" ").first.to_i * 60 + duration_string.split(" ")[2].to_i
  end
end
