class HideBroadcast < ActiveRecord::Base
  attr_accessible :user, :md5
  belongs_to :user
  validates :md5, :user_id, presence: true
  validates :md5, uniqueness: {scope: :user_id}
end
