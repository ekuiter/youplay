class Channel < ActiveRecord::Base
  attr_accessible :channel_id, :channel_name, :provider
  validates :channel_id, :channel_name, :provider, presence: true
  validates :channel_id, uniqueness: {scope: :provider}
end
