class Video < ActiveRecord::Base
  attr_accessible :browser, :channel_topic, :station, :title, :url, :user, :duration, :provider, :favorite, :category, :comment_length
  belongs_to :user
  belongs_to :category
  has_one :favorite, dependent: :destroy
  validates :channel_topic, :title, :url, :user_id, :browser, :provider, presence: true
  validates :url, uniqueness: {scope: [:user_id, :provider]}
  validates :comment_length, :duration, numericality: { only_integer: true, allow_nil: true }
  scope :none, where(:id => nil).where("id IS NOT ?", nil)

  include UrlMixin
  
  def as_json(args = nil)
    super except: [:updated_at, :user_id]
  end
  
  def youplay_channel
    youplay_provider = YouplayProvider.new provider: provider
    YouplayChannel.new(id: channel_topic, provider: youplay_provider)
  end
end
