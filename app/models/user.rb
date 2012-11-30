class User < ActiveRecord::Base

  # reader: latest_videos, hidden_videos, new_videos,
  #         latest_broadcasts, hidden_broadcasts, new_broadcasts
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


  include YoutubeConnector
  include HttpRequest

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :full_name, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :videos
  has_many :subscribed_channels
  has_many :subscribed_broadcasts
  has_many :people
  has_many :hide_videos
  has_many :cached_videos, through: :hide_videos
  has_many :hide_broadcasts
  has_many :configurations
  validates :username, :full_name, presence: true
  validates :username, uniqueness: true

  before_destroy do |user|
    last_admin
  end

  def tokens= tokens
    write_attribute :access_token, tokens[:access_token] unless tokens[:access_token].nil?
    write_attribute :refresh_token, tokens[:refresh_token] unless tokens[:refresh_token].nil?
    write_attribute :expires_in, tokens[:expires_in] unless tokens[:expires_in].nil?
  end

  def youtube_account
    begin
      client = youtube_connect raise_error: true, current_user: self, access_token: access_token,
                               refresh_token: refresh_token, expires_in: expires_in, state: "conf"
      account = client.current_user
    rescue
      account = nil
    end
    return account
  end

  def admin
    role == "admin" ? true : false
  end

  def admin= boolean
    if boolean
      write_attribute :role, "admin"
      return true
    else
      last_admin
      write_attribute :role, ""
      return false
    end
  end

  def self.admins
    where role: "admin"
  end

  def role=
  end

  private

  def last_admin
    admins = self.class.admins
    raise "You can't remove the last admin" if admins.count == 1 && admins.first == self
  end

end
