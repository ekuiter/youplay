class Category < ActiveRecord::Base
  attr_accessible :name, :user_id
  belongs_to :user
  has_many :videos
  validates :name, presence: true
  validates :name, uniqueness: {scope: :user_id}
  validates :user_id, presence: true
end
