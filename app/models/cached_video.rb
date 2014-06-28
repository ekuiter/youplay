class CachedVideo < ActiveRecord::Base
  attr_accessible :channel, :title, :url, :uploaded_at
  has_many :hide_videos, dependent: :destroy
  has_many :users, through: :hide_videos
  validates :channel, :title, :url, :uploaded_at, presence: true
  validates :url, uniqueness: true

  include UrlMixin

  def provider
    :youtube
  end
end
