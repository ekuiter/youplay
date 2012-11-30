class Configuration < ActiveRecord::Base

  attr_accessible :feature, :value, :user
  belongs_to :user
  validates :feature, :value, :user_id, presence: true
  validates :feature, uniqueness: {scope: :user_id}

end