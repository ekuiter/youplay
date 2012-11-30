class Person < ActiveRecord::Base
  attr_accessible :email, :name, :user
  belongs_to :user
  validates :email, :name, :user_id, presence: true
  validates :email, uniqueness: {:scope => [:name, :user_id]}
  validates :name, uniqueness: {:scope => [:email, :user_id]}
end
