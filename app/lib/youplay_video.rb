class YouplayVideo    
  attr_accessor :id, :url, :title, :duration, :access_control, :uploaded_at, :topic, :views, 
                :rating, :description, :thumbnail, :channel, :comments, :provider, :saved_video, :embed_type, :embed_id
  
  def initialize(hash={})
    hash.each do |key, value|
      instance_variable_set("@#{key}".to_sym, value)
    end
    @channel.provider = @provider if @channel
  end
  
  def channel=(value)
    @channel = value
    @channel.provider = @provider
  end
  
  def humanize_duration
    self.class.humanize_duration(self)
  end
  
  def self.humanize_duration(video)
    return nil unless video.duration
    minutes = video.duration / 60
    "#{minutes} #{I18n.t 'player.meta.minutes', count: minutes}"
  end
  
  def humanize_description
    require 'rinku'
    Rinku.auto_link(description.gsub("\n", '<br />'), :all, 'target="_blank"').html_safe
  end
  
  def embedding_allowed?
    not (provider == :youtube && access_control['embed'] != 'allowed')
  end
  
  def rating_allowed?
    provider == :youtube && access_control['rate'] == 'allowed'
  end
  
  def commenting_allowed?
    provider == :youtube && access_control['comment'] == 'allowed'
  end
  
  def native_client_url
    "#{Settings.native_client}#{url}"
  end
end