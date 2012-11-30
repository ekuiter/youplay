class SubscribedChannel < ActiveRecord::Base
  attr_accessible :channel, :user
  belongs_to :user
  validates :channel, :user_id, presence: true
  validates :channel, uniqueness: {scope: :user_id}
end
