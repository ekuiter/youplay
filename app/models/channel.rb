class Channel < ActiveRecord::Base
  attr_accessible :channel_id, :channel_name
  
  validates :channel_id, :channel_name, presence: true
  validates :channel_id, uniqueness: true
end
