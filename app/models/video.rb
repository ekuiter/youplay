class Video < ActiveRecord::Base
  attr_accessible :browser, :channel_topic, :station, :title, :url, :user, :duration
  belongs_to :user
  has_one :favorite, dependent: :destroy
  validates :channel_topic, :title, :url, :user_id, :browser, presence: true
  validates :url, uniqueness: {scope: :user_id}

  def play_url
    "#{Rails.application.routes.url_helpers.play_path}?#{url}"
  end

end
