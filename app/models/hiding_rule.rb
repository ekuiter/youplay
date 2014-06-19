class HidingRule < ActiveRecord::Base
  attr_accessible :channel, :pattern, :user_id
  
  belongs_to :user
  
  validates :pattern, :user_id, presence: true
  validates :pattern, uniqueness: {scope: [:user_id, :channel]}
end
