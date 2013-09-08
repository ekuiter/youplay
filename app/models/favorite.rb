class Favorite < ActiveRecord::Base
  attr_accessible :user, :video
  belongs_to :user
  belongs_to :video
  validates :user_id, :video_id, presence: true
  validates :video_id, uniqueness: {scope: :user_id}
end
