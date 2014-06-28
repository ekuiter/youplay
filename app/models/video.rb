class Video < ActiveRecord::Base
  attr_accessible :browser, :channel_topic, :station, :title, :url, :user, :duration, :provider, :favorite
  belongs_to :user
  has_one :favorite, dependent: :destroy
  validates :channel_topic, :title, :url, :user_id, :browser, :provider, presence: true
  validates :url, uniqueness: {scope: [:user_id, :provider]}
  
  include UrlMixin
  
  def as_json(args = nil)
    super except: [:updated_at, :user_id]
  end
  
  def youplay_channel
    youplay_provider = YouplayProvider.new provider: provider
    YouplayChannel.new(id: channel_topic, provider: youplay_provider)
  end
end
