class Providers::NewgroundsVideoProvider < Providers::NewgroundsProvider  
  def name
    "Newgrounds Video"
  end
  
  def video_id(params)
    video_id_by_url("newgrounds.com/portal/view/", :newgrounds_video, params)
  end
  
  def fetch_video(id)
    @sourcecode, @xml, @id = nil, nil, id
    attributes = self.attributes.merge id: id,
                                       duration: 0,
                                       uploaded_at: uploaded_at("%b %d, %Y"),
                                       description: xml.css(".fatcol .podcontent")[0].text
    YouplayVideo.new attributes
  end
  
  private
  
  def url
    "http://www.newgrounds.com/portal/view/#{@id}"
  end
end
