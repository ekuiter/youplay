class CachedVideo < ActiveRecord::Base
  attr_accessible :channel, :description, :title, :url, :uploaded_at
  has_many :hide_videos
  has_many :users, through: :hide_videos
  validates :channel, :description, :title, :url, :uploaded_at, presence: true
  validates :url, uniqueness: true

  def play_url
    "#{Rails.application.routes.url_helpers.player_video_path}?#{url}"
  end

end
