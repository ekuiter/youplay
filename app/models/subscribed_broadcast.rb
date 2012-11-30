class SubscribedBroadcast < ActiveRecord::Base
  attr_accessible :broadcast, :user
  belongs_to :user
  validates :broadcast, :user_id, presence: true
  validates :broadcast, uniqueness: {scope: :user_id}
  serialize :broadcast, Hash
end
