class YouplayChannel  
  class << self
   attr_accessor :prefetched_channels
  end
 
  attr_accessor :id, :name, :provider
  
  def self.prefetch_all
    self.prefetched_channels = Channel.all
  end
  
  def initialize(hash={})
    hash.each do |key, value|
      instance_variable_set("@#{key}".to_sym, value)
    end
  end

  def id
    @id ||= fetch(:id)
  end

  def name
    @name ||= fetch(:name)
  end

  def url
    provider.channel_url(id)
  end

  def link
    "<a href=\"#{url}\" target=\"_blank\">#{name}</a>".html_safe
  end

  private

  def find_channel(instance_method, cache_method)
    prefetched_channels = self.class.prefetched_channels
    instance_variable = instance_variable_get("@#{instance_method}")
    if prefetched_channels
      prefetched_channels.select {|c| c.send(cache_method) == instance_variable and c.provider == @provider.to_s }
    else
      conditions = { provider: @provider.to_s }
      conditions[cache_method] = instance_variable
      Channel.where conditions
    end.first
  end

  def fetch_from_cache
    channel = find_channel(:id, :channel_id) if @name.blank?
    channel = find_channel(:name, :channel_name) if @id.blank?
    if channel
      @id = channel.channel_id
      @name = channel.channel_name
      true
    else
      false
    end
  end
  
  def insert_into_cache
    channel = @provider.channel(@id) if @name.blank?
    channel = @provider.channel(@name) if @id.blank?
    @id = channel[:id]
    @name = channel[:name]
    Channel.create channel_id: @id, channel_name: @name, provider: @provider.to_s
  end

  def fetch(method)
    raise "neither id nor name given" if @id.blank? and @name.blank?
    raise "provider not given" if @provider.blank?
    raise "provider invalid" unless @provider.kind_of?(YouplayProvider)
    return send(method) if fetch_from_cache
    insert_into_cache
    send(method)
  end

end