class Player::PlayerController < ApplicationController
  include ControllerMixins::PlayerController

  def index
    @recently_watched_videos = current_user.recently_watched_videos
    @favorited_video_ids = current_user.favorites.map {|f| f.video_id}
  end

  def play
    @people = current_user.people.map {|p| [p.name, p.id] }
    @video = play_video params
  end
end
