class User < ActiveRecord::Base

  # reader: latest_videos, hidden_videos, new_videos
  include Reader::UserHelper

  # log: watched_videos
  include Log::UserHelper

  # player: recently_watched_videos
  include Player::UserHelper

  # conf: max_recently_watched, max_recently_watched=
  #       max_title_length, max_title_length=
  #       player_skin, player_skin=
  include Conf::UserHelper

  # stats: /
  include Stats::UserHelper

  include HttpRequest

  # Include devise modules
  devise :database_authenticatable, :trackable, :validatable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :full_name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :videos, dependent: :destroy
  has_many :subscribed_channels, dependent: :destroy
  has_many :people, dependent: :destroy
  has_many :hide_videos, dependent: :destroy
  has_many :cached_videos, through: :hide_videos
  has_many :configurations, dependent: :destroy
  has_many :favorites, dependent: :destroy
  validates :username, :full_name, presence: true
  validates :username, uniqueness: true

  before_destroy do |user|
    user
    last_admin
  end

  def admin
    role == 'admin' ? true : false
  end

  def admin=(boolean)
    if boolean
      write_attribute :role, 'admin'
      true
    else
      last_admin
      write_attribute :role, ''
      false
    end
  end

  def self.admins
    where role: 'admin'
  end

  def role=
  end

  private

  def last_admin
    admins = self.class.admins
    raise 'You can\'t remove the last admin' if admins.count == 1 && admins.first == self
  end

end
