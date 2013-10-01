class CachedVideo < ActiveRecord::Base
  attr_accessible :channel, :title, :url, :uploaded_at
  has_many :hide_videos, dependent: :destroy
  has_many :users, through: :hide_videos
  validates :channel, :title, :url, :uploaded_at, presence: true
  validates :url, uniqueness: true

  def play_url
    "#{Rails.application.routes.url_helpers.play_path}?#{url}"
  end

end
