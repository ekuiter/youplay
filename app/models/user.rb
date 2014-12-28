class User < ActiveRecord::Base
  attr_accessible :username, :full_name, :email, :password, :password_confirmation, :remember_me
  has_many :videos, dependent: :destroy
  has_many :subscribed_channels, dependent: :destroy
  has_many :people, dependent: :destroy
  has_many :hide_videos, dependent: :destroy
  has_many :hiding_rules, dependent: :destroy
  has_many :cached_videos, through: :hide_videos
  has_many :configurations, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :categories, dependent: :destroy
  validates :username, :full_name, presence: true
  validates :username, uniqueness: true
  
  devise :database_authenticatable, :trackable, :validatable, :registerable
  
  include UserMixins::Reader
  include UserMixins::Log
  include UserMixins::Player
  include UserMixins::Conf
  include UserMixins::Stats
  include UserMixins::Admin
  include UserMixins::Token
  
  before_destroy do |user|
    user
    preserve_last_admin!
  end
  
  before_save :ensure_authentication_token
end
