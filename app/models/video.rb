class Video < ActiveRecord::Base
  attr_accessible :browser, :channel_topic, :gronkh_url, :station, :title, :url, :user
  belongs_to :user
  validates :channel_topic, :title, :url, :user_id, :browser, presence: true
  validates :url, uniqueness: {scope: :user_id}

  def play_url
    if station.nil?
      "#{Rails.application.routes.url_helpers.player_video_path}?#{url}"
    else
      "#{Rails.application.routes.url_helpers.player_broadcast_path}?#{url}"
    end
  end

end
