class HideVideo < ActiveRecord::Base
  attr_accessible :cached_video, :channel, :user
  belongs_to :cached_video
  belongs_to :user
  validates :cached_video_id, :user_id, presence: true
  validates :cached_video_id, uniqueness: {scope: :user_id}
end
